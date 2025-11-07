import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "modal",
    "oldMonthly",
    "newMonthly",
    "oldAdmission",
    "newAdmission",
    "oldRenewal",
    "newRenewal",
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
    hubName: String,
    currencySymbol: String
  }

  connect() {
    console.log('CurriculumPricing controller connected')
    // The controller is attached to the form itself
    this.form = this.element
    this.pendingFormData = null

    // Store original values on connect
    this.originalHubId = this.hubIdValue
    this.originalCurriculum = this.currentCurriculumValue
    this.originalProgramme = this.currentProgrammeValue

    const hubSelect = this.form.querySelector('select[name="learner_info[hub_id]"]')
    if (hubSelect && hubSelect.selectedIndex >= 0) {
      this.originalHubName = hubSelect.options[hubSelect.selectedIndex].text
    } else {
      this.originalHubName = "N/A"
    }

    // Store reference to this controller globally
    window.curriculumPricingController = this

    // Intercept form submission
    this.form.addEventListener('submit', (e) => this.handleSubmit(e))
  }

  disconnect() {
    // Clean up global reference
    if (window.curriculumPricingController === this) {
      window.curriculumPricingController = null
    }
  }

  async handleSubmit(event) {
    event.preventDefault()
    event.stopPropagation()

    const formData = new FormData(this.form)
    const newCurriculum = formData.get('learner_info[curriculum_course_option]')
    const newProgramme = formData.get('learner_info[programme]')
    const newHubId = formData.get('learner_info[hub_id]')

    console.log('Form submission check:', {
      original: {
        curriculum: this.originalCurriculum,
        programme: this.originalProgramme,
        hubId: this.originalHubId
      },
      new: {
        curriculum: newCurriculum,
        programme: newProgramme,
        hubId: newHubId
      }
    })

    // Check if curriculum, programme, or hub changed
    const curriculumChanged = newCurriculum !== this.originalCurriculum
    const programmeChanged = newProgramme !== this.originalProgramme
    const hubChanged = newHubId != this.originalHubId // Use != for type coercion

    if (curriculumChanged || programmeChanged || hubChanged) {
      console.log('Pricing-relevant change detected')
      // Store form data for later submission
      this.pendingFormData = formData
      // Store new values for comparison in modal
      this.newCurriculum = newCurriculum
      this.newProgramme = newProgramme
      this.newHubId = newHubId

      // Check if pricing is affected
      await this.checkPricingImpact(newCurriculum, newProgramme, newHubId)
    } else {
      console.log('No pricing-relevant changes, submitting normally')
      // No relevant change, submit normally
      this.form.submit()
    }
  }

  async checkPricingImpact(newCurriculum, newProgramme, newHubId) {
    try {
      const response = await fetch(
        `/admissions/${this.learnerInfoIdValue}/check_pricing_impact?` +
        new URLSearchParams({
          curriculum: newCurriculum,
          programme: newProgramme,
          hub_id: newHubId
        })
      )

      if (!response.ok) {
        throw new Error('Failed to check pricing impact')
      }

      const data = await response.json()

      console.log('Pricing impact response:', data)

      if (data.requires_confirmation) {
        this.showConfirmationModal(data)
      } else if (data.error) {
        alert(data.error)
        // Still allow form submission despite pricing error
        this.form.submit()
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
    // Find modal elements (they might be outside the form)
    const modal = document.getElementById('pricingConfirmationModal')
    const changesDetails = modal.querySelector('[data-curriculum-pricing-target="changesDetails"]')
    const oldMonthly = modal.querySelector('[data-curriculum-pricing-target="oldMonthly"]')
    const newMonthly = modal.querySelector('[data-curriculum-pricing-target="newMonthly"]')
    const oldAdmission = modal.querySelector('[data-curriculum-pricing-target="oldAdmission"]')
    const newAdmission = modal.querySelector('[data-curriculum-pricing-target="newAdmission"]')
    const oldRenewal = modal.querySelector('[data-curriculum-pricing-target="oldRenewal"]')
    const newRenewal = modal.querySelector('[data-curriculum-pricing-target="newRenewal"]')
    const discountMfInput = modal.querySelector('[data-curriculum-pricing-target="discountMfInput"]')
    const scholarshipInput = modal.querySelector('[data-curriculum-pricing-target="scholarshipInput"]')
    const discountAfInput = modal.querySelector('[data-curriculum-pricing-target="discountAfInput"]')
    const discountRfInput = modal.querySelector('[data-curriculum-pricing-target="discountRfInput"]')

    // Set changes details dynamically - use the stored new values from form submission
    let changesHtml = '';
    if (this.newCurriculum !== this.originalCurriculum) {
      changesHtml += `Curriculum: ${this.originalCurriculum || "N/A"} → ${this.newCurriculum}<br>`;
    }
    if (this.newProgramme !== this.originalProgramme) {
      changesHtml += `Programme: ${this.originalProgramme || "N/A"} → ${this.newProgramme}<br>`;
    }

    // Get the new hub name from the select option
    const hubSelect = this.form.querySelector('select[name="learner_info[hub_id]"]')
    let newHubName = "N/A"
    if (hubSelect && this.newHubId) {
      const selectedOption = hubSelect.querySelector(`option[value="${this.newHubId}"]`)
      if (selectedOption) {
        newHubName = selectedOption.text
      }
    }

    if (newHubName !== this.originalHubName) {
      changesHtml += `Hub: ${this.originalHubName || "N/A"} → ${newHubName}<br>`;
    }

    changesDetails.innerHTML = changesHtml;

    // Set pricing tier criteria
    document.getElementById('pricing-model').textContent = data.pricing_criteria.model
    document.getElementById('pricing-country').textContent = data.pricing_criteria.country
    document.getElementById('pricing-hub').textContent = data.pricing_criteria.hub_name
    document.getElementById('pricing-curriculum').textContent = data.pricing_criteria.curriculum

    // Set old values
    oldMonthly.textContent = this.formatCurrency(data.current_pricing.monthly_fee)
    oldAdmission.textContent = this.formatCurrency(data.current_pricing.admission_fee)
    oldRenewal.textContent = this.formatCurrency(data.current_pricing.renewal_fee)

    // Set new fees
    this.newMonthlyFee = data.new_pricing.monthly_fee || 0;
    this.newAdmissionFee = data.new_pricing.admission_fee || 0;
    this.newRenewalFee = data.new_pricing.renewal_fee || 0;

    // Set new values in display
    newMonthly.textContent = this.formatCurrency(data.new_pricing.monthly_fee)
    newAdmission.textContent = this.formatCurrency(data.new_pricing.admission_fee)
    newRenewal.textContent = this.formatCurrency(data.new_pricing.renewal_fee)

    // Set discount/scholarship values (preserve existing or set to 0)
    discountMfInput.value = data.current_pricing.discount_mf || 0
    scholarshipInput.value = data.current_pricing.scholarship || 0
    discountAfInput.value = data.current_pricing.discount_af || 0
    discountRfInput.value = data.current_pricing.discount_rf || 0

    // Store references for later use
    this.modalDiscountMfInput = discountMfInput
    this.modalScholarshipInput = scholarshipInput
    this.modalDiscountAfInput = discountAfInput
    this.modalDiscountRfInput = discountRfInput

    // Calculate initial billables
    this.calculateBillables()

    // Add event listeners for confirm and cancel buttons
    const confirmBtn = modal.querySelector('#pricing-confirm-btn')
    const cancelBtn = modal.querySelector('#pricing-cancel-btn')

    // Remove any existing listeners to prevent duplicates
    confirmBtn.removeEventListener('click', this.boundConfirmChanges)
    cancelBtn.removeEventListener('click', this.boundCancelChanges)

    // Bind methods to preserve 'this' context
    this.boundConfirmChanges = this.confirmChanges.bind(this)
    this.boundCancelChanges = this.cancelChanges.bind(this)

    confirmBtn.addEventListener('click', this.boundConfirmChanges)
    cancelBtn.addEventListener('click', this.boundCancelChanges)

    // Show modal
    this.bootstrapModal = new bootstrap.Modal(modal)
    this.bootstrapModal.show()

    // Clean up listeners when modal is hidden
    modal.addEventListener('hidden.bs.modal', () => {
      confirmBtn.removeEventListener('click', this.boundConfirmChanges)
      cancelBtn.removeEventListener('click', this.boundCancelChanges)
    }, { once: true })
  }

  calculateBillables() {
    // Calculate billable monthly fee
    const monthlyFee = parseFloat(this.newMonthlyFee) || 0;
    const discountMf = parseFloat(this.modalDiscountMfInput?.value || 0);
    const scholarship = parseFloat(this.modalScholarshipInput?.value || 0);
    const discountPercentMf = (discountMf + scholarship) / 100;
    const billableMf = Math.max(0, monthlyFee * (1 - discountPercentMf));
    document.getElementById('billable-mf').textContent = this.formatCurrency(billableMf);

    // Calculate billable admission fee
    const admissionFee = parseFloat(this.newAdmissionFee) || 0;
    const discountAf = parseFloat(this.modalDiscountAfInput?.value || 0);
    const discountPercentAf = discountAf / 100;
    const billableAf = Math.max(0, admissionFee * (1 - discountPercentAf));
    document.getElementById('billable-af').textContent = this.formatCurrency(billableAf);

    // Calculate billable renewal fee
    const renewalFee = parseFloat(this.newRenewalFee) || 0;
    const discountRf = parseFloat(this.modalDiscountRfInput?.value || 0);
    const discountPercentRf = discountRf / 100;
    const billableRf = Math.max(0, renewalFee * (1 - discountPercentRf));
    document.getElementById('billable-rf').textContent = this.formatCurrency(billableRf);
  }

  confirmChanges() {
    console.log('Confirming changes...')

    // Get the edited values from the modal
    const monthlyFee = this.newMonthlyFee;
    const admissionFee = this.newAdmissionFee;
    const renewalFee = this.newRenewalFee;
    const discountMf = this.modalDiscountMfInput.value;
    const scholarship = this.modalScholarshipInput.value;
    const discountAf = this.modalDiscountAfInput.value;
    const discountRf = this.modalDiscountRfInput.value;

    // Calculate billable values
    const billableMf = monthlyFee * (1 - (parseFloat(discountMf) + parseFloat(scholarship)) / 100);
    const billableAf = admissionFee * (1 - parseFloat(discountAf) / 100);
    const billableRf = renewalFee * (1 - parseFloat(discountRf) / 100);

    // Update form data with confirmed values
    this.pendingFormData.set('learner_info[learner_finance_attributes][monthly_fee]', monthlyFee)
    this.pendingFormData.set('learner_info[learner_finance_attributes][admission_fee]', admissionFee)
    this.pendingFormData.set('learner_info[learner_finance_attributes][renewal_fee]', renewalFee)
    this.pendingFormData.set('learner_info[learner_finance_attributes][discount_mf]', discountMf)
    this.pendingFormData.set('learner_info[learner_finance_attributes][scholarship]', scholarship)
    this.pendingFormData.set('learner_info[learner_finance_attributes][discount_af]', discountAf)
    this.pendingFormData.set('learner_info[learner_finance_attributes][discount_rf]', discountRf)
    this.pendingFormData.set('learner_info[learner_finance_attributes][billable_mf]', billableMf.toFixed(2))
    this.pendingFormData.set('learner_info[learner_finance_attributes][billable_af]', billableAf.toFixed(2))
    this.pendingFormData.set('learner_info[learner_finance_attributes][billable_rf]', billableRf.toFixed(2))

    // Get the finance record ID if it exists
    const financeId = document.querySelector('input[name="learner_info[learner_finance_attributes][id]"]')?.value
    if (financeId) {
      this.pendingFormData.set('learner_info[learner_finance_attributes][id]', financeId)
    }

    // Close the modal before submitting
    this.bootstrapModal.hide()

    // Submit form with updated data
    this.submitFormWithData(this.pendingFormData)
  }

  cancelChanges() {
    console.log('Canceling changes...')

    // Reset pending data
    this.pendingFormData = null

    // Reset form fields to original values
    const curriculumSelect = this.form.querySelector('select[name="learner_info[curriculum_course_option]"]')
    const programmeSelect = this.form.querySelector('select[name="learner_info[programme]"]')
    const hubSelect = this.form.querySelector('select[name="learner_info[hub_id]"]')

    if (curriculumSelect) curriculumSelect.value = this.originalCurriculum
    if (programmeSelect) programmeSelect.value = this.originalProgramme
    if (hubSelect) hubSelect.value = this.originalHubId

    // Close the modal (though data-bs-dismiss already handles this, this ensures consistency)
    this.bootstrapModal.hide()
  }

  submitFormWithData(formData) {
    console.log('Submitting form with data...')

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
      return `${this.currencySymbolValue} 0.00`
    }
    return `${this.currencySymbolValue} ${parseFloat(amount).toLocaleString('pt-PT', { minimumFractionDigits: 2, maximumFractionDigits: 2 })}`
  }
}
