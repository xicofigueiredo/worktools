import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "modal",
    "oldCurriculum",
    "newCurriculum",
    "oldMonthly",
    "newMonthly",
    "oldAdmission",
    "newAdmission",
    "oldRenewal",
    "newRenewal",
    "monthlyInput",
    "admissionInput",
    "renewalInput",
    "discountMfInput",
    "scholarshipInput",
    "discountAfInput",
    "discountRfInput",
    "modalBody",
    "confirmButton",
    "changesDetails"
  ]

  static values = {
    hubId: Number,
    currentCurriculum: String,
    currentProgramme: String,
    learnerInfoId: Number,
    model: String,
    country: String,
    hubName: String
  }

  connect() {
    this.form = this.element.querySelector('form')
    this.originalSubmit = this.form.onsubmit
    this.pendingFormData = null

    // Intercept form submission
    this.form.addEventListener('submit', (e) => this.handleSubmit(e))
  }

  async handleSubmit(event) {
    event.preventDefault()
    event.stopPropagation()

    const formData = new FormData(this.form)
    const newCurriculum = formData.get('learner_info[curriculum_course_option]')
    const newProgramme = formData.get('learner_info[programme]')

    // Check if curriculum or programme changed
    if (newCurriculum !== this.currentCurriculumValue || newProgramme !== this.currentProgrammeValue) {
      // Store form data for later submission
      this.pendingFormData = formData

      // Check if pricing is affected
      await this.checkPricingImpact(newCurriculum, newProgramme)
    } else {
      // No relevant change, submit normally
      this.form.submit()
    }
  }

  async checkPricingImpact(newCurriculum, newProgramme) {
    try {
      const response = await fetch(
        `/admissions/${this.learnerInfoIdValue}/check_pricing_impact?` +
        new URLSearchParams({
          curriculum: newCurriculum,
          programme: newProgramme,
          hub_id: this.hubIdValue
        })
      )

      if (!response.ok) {
        throw new Error('Failed to check pricing impact')
      }

      const data = await response.json()

      console.log(data)

      if (data.requires_confirmation) {
        this.showConfirmationModal(data)
      } else {
        // No pricing impact, submit normally
        this.form.submit()
      }
    } catch (error) {
      console.error('Error checking pricing impact:', error)
      alert('Error checking pricing information. Please try again.')
    }
  }

  showConfirmationModal(data) {
    // Set changes details dynamically
    let changesHtml = '';
    if (data.new_curriculum !== this.currentCurriculumValue) {
      changesHtml += `Curriculum: ${this.currentCurriculumValue || "N/A"} → ${data.new_curriculum}<br>`;
    }
    if (data.new_programme !== data.old_programme) {
      changesHtml += `Programme: ${data.old_programme || "N/A"} → ${data.new_programme}<br>`;
    }
    this.changesDetailsTarget.innerHTML = changesHtml;

    // Add debug message
    const debugP = document.createElement('p');
    debugP.textContent = `Debug: curriculum ${data.new_curriculum} and programme ${data.new_programme} and hub with this characteristics (model: ${data.pricing_criteria.model}, country: ${data.pricing_criteria.country}, hub_name: ${data.pricing_criteria.hub_name}) will get the pricing tier: monthly_fee ${data.new_pricing.monthly_fee}, admission_fee ${data.new_pricing.admission_fee}, renewal_fee ${data.new_pricing.renewal_fee}`;
    this.modalBodyTarget.insertBefore(debugP, this.modalBodyTarget.firstChild);

    // Set pricing tier criteria
    document.getElementById('pricing-model').textContent = data.pricing_criteria.model
    document.getElementById('pricing-country').textContent = data.pricing_criteria.country
    document.getElementById('pricing-hub').textContent = data.pricing_criteria.hub_name
    document.getElementById('pricing-curriculum').textContent = data.pricing_criteria.curriculum

    // Set old values
    this.oldMonthlyTarget.textContent = this.formatCurrency(data.current_pricing.monthly_fee)
    this.oldAdmissionTarget.textContent = this.formatCurrency(data.current_pricing.admission_fee)
    this.oldRenewalTarget.textContent = this.formatCurrency(data.current_pricing.renewal_fee)

    // Set new values in display
    this.newMonthlyTarget.textContent = this.formatCurrency(data.new_pricing.monthly_fee)
    this.newAdmissionTarget.textContent = this.formatCurrency(data.new_pricing.admission_fee)
    this.newRenewalTarget.textContent = this.formatCurrency(data.new_pricing.renewal_fee)

    // Set editable input values
    this.monthlyInputTarget.value = data.new_pricing.monthly_fee || 0
    this.admissionInputTarget.value = data.new_pricing.admission_fee || 0
    this.renewalInputTarget.value = data.new_pricing.renewal_fee || 0

    // Set discount/scholarship values (preserve existing or set to 0)
    this.discountMfInputTarget.value = data.current_pricing.discount_mf || 0
    this.scholarshipInputTarget.value = data.current_pricing.scholarship || 0
    this.discountAfInputTarget.value = data.current_pricing.discount_af || 0
    this.discountRfInputTarget.value = data.current_pricing.discount_rf || 0

    // Calculate initial billables
    this.calculateBillables()

    // Show modal
    const modal = new bootstrap.Modal(this.modalTarget)
    modal.show()
  }

  calculateBillables() {
    // Calculate billable monthly fee
    const monthlyFee = parseFloat(this.monthlyInputTarget.value) || 0
    const discountMf = parseFloat(this.discountMfInputTarget.value) || 0
    const scholarship = parseFloat(this.scholarshipInputTarget.value) || 0
    const billableMf = Math.max(0, monthlyFee - discountMf - scholarship)
    document.getElementById('billable-mf').textContent = this.formatCurrency(billableMf)

    // Calculate billable admission fee
    const admissionFee = parseFloat(this.admissionInputTarget.value) || 0
    const discountAf = parseFloat(this.discountAfInputTarget.value) || 0
    const billableAf = Math.max(0, admissionFee - discountAf)
    document.getElementById('billable-af').textContent = this.formatCurrency(billableAf)

    // Calculate billable renewal fee
    const renewalFee = parseFloat(this.renewalInputTarget.value) || 0
    const discountRf = parseFloat(this.discountRfInputTarget.value) || 0
    const billableRf = Math.max(0, renewalFee - discountRf)
    document.getElementById('billable-rf').textContent = this.formatCurrency(billableRf)
  }

  confirmChanges() {
    // Get the edited values from the modal
    const monthlyFee = this.monthlyInputTarget.value
    const admissionFee = this.admissionInputTarget.value
    const renewalFee = this.renewalInputTarget.value
    const discountMf = this.discountMfInputTarget.value
    const scholarship = this.scholarshipInputTarget.value
    const discountAf = this.discountAfInputTarget.value
    const discountRf = this.discountRfInputTarget.value

    // Update form data with confirmed values
    this.pendingFormData.set('learner_info[learner_finance_attributes][monthly_fee]', monthlyFee)
    this.pendingFormData.set('learner_info[learner_finance_attributes][admission_fee]', admissionFee)
    this.pendingFormData.set('learner_info[learner_finance_attributes][renewal_fee]', renewalFee)
    this.pendingFormData.set('learner_info[learner_finance_attributes][discount_mf]', discountMf)
    this.pendingFormData.set('learner_info[learner_finance_attributes][scholarship]', scholarship)
    this.pendingFormData.set('learner_info[learner_finance_attributes][discount_af]', discountAf)
    this.pendingFormData.set('learner_info[learner_finance_attributes][discount_rf]', discountRf)

    // Get the finance record ID if it exists
    const financeId = document.querySelector('input[name="learner_info[learner_finance_attributes][id]"]')?.value
    if (financeId) {
      this.pendingFormData.set('learner_info[learner_finance_attributes][id]', financeId)
    }

    // Close modal
    const modal = bootstrap.Modal.getInstance(this.modalTarget)
    modal.hide()

    // Submit form with updated data
    this.submitFormWithData(this.pendingFormData)
  }

  cancelChanges() {
    // Close modal
    const modal = bootstrap.Modal.getInstance(this.modalTarget)
    modal.hide()

    // Reset pending data
    this.pendingFormData = null
  }

  submitFormWithData(formData) {
    // Create a temporary form to submit
    const tempForm = document.createElement('form')
    tempForm.method = this.form.method
    tempForm.action = this.form.action
    tempForm.style.display = 'none'

    // Add all form data as hidden inputs
    for (let [key, value] of formData.entries()) {
      const input = document.createElement('input')
      input.type = 'hidden'
      input.name = key
      input.value = value
      tempForm.appendChild(input)
    }

    document.body.appendChild(tempForm)
    tempForm.submit()
  }

  formatCurrency(amount) {
    if (amount === null || amount === undefined || amount === '') {
      return "€0.00"
    }
    return `€${parseFloat(amount).toLocaleString('pt-PT', { minimumFractionDigits: 2, maximumFractionDigits: 2 })}`
  }
}
