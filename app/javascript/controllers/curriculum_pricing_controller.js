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

  validateRequiredFields() {
    const errors = []

    // Get DOM elements
    const programmeSelect = this.form.querySelector('select[name="learner_info[programme]"]')
    const hubSelect = this.form.querySelector('select[name="learner_info[hub_id]"]')
    const curriculumSelect = this.form.querySelector('select[name="learner_info[curriculum_course_option]"]')
    const gradeSelect = this.form.querySelector('select[name="learner_info[grade_year]"]')
    const lcHidden = this.form.querySelector('input[name="learner_info[learning_coach_id]"]')
    const lcDisplayInput = this.form.querySelector('#learning-coach-display')
    const changeBtn = this.form.querySelector('#change-coach-btn')

    // Get values directly from elements
    const programme = programmeSelect ? programmeSelect.value : ''
    const hubId = hubSelect ? hubSelect.value : ''
    const curriculum = curriculumSelect ? curriculumSelect.value : ''
    const gradeYear = gradeSelect ? gradeSelect.value : ''
    const learningCoachId = lcHidden ? lcHidden.value : ''

    // Clear previous errors
    this.clearAllErrors()

    // Validate programme
    if (programmeSelect && !programmeSelect.disabled && !programme) {
      errors.push({ field: programmeSelect, message: 'Please select a programme.' })
    }

    // Validate hub
    if (hubSelect && !hubSelect.disabled && !hubId) {
      errors.push({ field: hubSelect, message: 'Please select a hub.' })
    }

    // Validate curriculum
    if (curriculumSelect && !curriculumSelect.disabled && !curriculum) {
      errors.push({ field: curriculumSelect, message: 'Please select a curriculum/course option.' })
    }

    // Validate grade/year
    if (gradeSelect && !gradeSelect.disabled && !gradeYear) {
      errors.push({ field: gradeSelect, message: 'Please select a Grade/Year.' })
    }

    // Validate learning coach (only if programme is Online and editable)
    if (programme === 'Online') {
      if (changeBtn && !changeBtn.disabled && !learningCoachId) {
        errors.push({ field: lcDisplayInput, message: 'Please assign a Learning Coach.', isLearningCoach: true })
      }
    }

    // Display errors if any
    if (errors.length > 0) {
      errors.forEach(error => {
        this.showError(error.field, error.message, error.isLearningCoach)
      })

      // Scroll to first error
      const firstError = this.form.querySelector('.is-invalid')
      if (firstError) {
        firstError.scrollIntoView({ behavior: 'smooth', block: 'center' })
      }

      return false
    }

    return true
  }

  showError(element, message, isLearningCoach = false) {
    if (!element) return

    // For learning coach field, we need special handling since it's an input group
    if (isLearningCoach) {
      // The structure is: div.mb-3.col-md-6 > label + div.input-group > input + button
      // We need to find the parent div.mb-3 to append the error message
      const lcFieldContainer = element.closest('.mb-3')
      if (!lcFieldContainer) {
        console.error('Could not find Learning Coach field container')
        return
      }

      // Remove any existing error message first
      const existingError = lcFieldContainer.querySelector('.invalid-feedback')
      if (existingError) existingError.remove()

      // Create and append new error message
      const errorMsg = document.createElement('div')
      errorMsg.className = 'invalid-feedback'
      errorMsg.style.display = 'block'
      errorMsg.textContent = message
      lcFieldContainer.appendChild(errorMsg)

      // Add invalid class to the input
      element.classList.add('is-invalid')

      // Also highlight the button
      const inputGroup = element.parentElement
      const button = inputGroup.querySelector('button')
      if (button) {
        button.classList.add('btn-danger')
        button.classList.remove('btn-primary')
      }
    } else {
      let errorMsg = element.parentElement.querySelector('.invalid-feedback')
      if (!errorMsg) {
        errorMsg = document.createElement('div')
        errorMsg.className = 'invalid-feedback'
        errorMsg.style.display = 'block'
        element.parentElement.appendChild(errorMsg)
      }
      errorMsg.textContent = message
      element.classList.add('is-invalid')
    }
  }

  clearError(element) {
    if (!element) return

    element.classList.remove('is-invalid')

    // Check if this is the learning coach display input by checking if parent is input-group
    const inputGroup = element.parentElement
    if (inputGroup && inputGroup.classList.contains('input-group')) {
      // Find the container div.mb-3
      const lcFieldContainer = element.closest('.mb-3')
      if (lcFieldContainer) {
        const errorMsg = lcFieldContainer.querySelector('.invalid-feedback')
        if (errorMsg) errorMsg.remove()
      }

      // Reset button styling
      const button = inputGroup.querySelector('button')
      if (button && button.classList.contains('btn-danger')) {
        button.classList.remove('btn-danger')
        button.classList.add('btn-primary')
      }
    } else {
      const errorMsg = element.parentElement.querySelector('.invalid-feedback')
      if (errorMsg) errorMsg.remove()
    }
  }

  clearAllErrors() {
    const invalidElements = this.form.querySelectorAll('.is-invalid')
    invalidElements.forEach(element => {
      element.classList.remove('is-invalid')
    })
    const errorMessages = this.form.querySelectorAll('.invalid-feedback')
    errorMessages.forEach(msg => msg.remove())
  }

  async   handleSubmit(event) {
    event.preventDefault()
    event.stopPropagation()

    // First, validate required fields using DOM values
    if (!this.validateRequiredFields()) {
      console.log('Form validation failed, aborting submission')
      return
    }

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
    // If field not in formData (null), treat as no change since not visible/editable
    const curriculumChanged = newCurriculum !== null && newCurriculum !== this.originalCurriculum
    const programmeChanged = newProgramme !== null && newProgramme !== this.originalProgramme
    const hubChanged = newHubId !== null && newHubId != this.originalHubId // Use != for type coercion

    if (curriculumChanged || programmeChanged || hubChanged) {
      console.log('Pricing-relevant change detected')
      // Store form data for later submission
      this.pendingFormData = formData
      // Store new values for comparison in modal
      this.newCurriculum = newCurriculum
      this.newProgramme = newProgramme
      this.newHubId = newHubId
      // Check if pricing is affected
      this.checkPricingImpact(newCurriculum, newProgramme, newHubId)
    } else {
      console.log('No pricing-relevant changes, submitting normally')
      // No relevant change, submit normally
      this.form.submit()
    }
  }

  async checkPricingImpact(newCurriculum, newProgramme, newHubId) {
    // Skip if any param is null/blank
    if (!newCurriculum || !newProgramme || !newHubId) {
      console.log('Skipping pricing check due to missing params')
      this.form.submit()
      return
    }

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
      // Allow submission on error
      this.form.submit()
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

    // Store the new currency symbol
    this.newCurrencySymbol = data.new_currency_symbol

    // Set old values
    oldMonthly.textContent = this.formatCurrency(data.current_pricing.monthly_fee, this.currencySymbolValue)
    oldAdmission.textContent = this.formatCurrency(data.current_pricing.admission_fee, this.currencySymbolValue)
    oldRenewal.textContent = this.formatCurrency(data.current_pricing.renewal_fee, this.currencySymbolValue)

    // Set new fees
    this.newMonthlyFee = data.new_pricing.monthly_fee || 0;
    this.newAdmissionFee = data.new_pricing.admission_fee || 0;
    this.newRenewalFee = data.new_pricing.renewal_fee || 0;

    // Set new values in display
    newMonthly.textContent = this.formatCurrency(data.new_pricing.monthly_fee, this.newCurrencySymbol)
    newAdmission.textContent = this.formatCurrency(data.new_pricing.admission_fee, this.newCurrencySymbol)
    newRenewal.textContent = this.formatCurrency(data.new_pricing.renewal_fee, this.newCurrencySymbol)

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

    // Store the response for old values
    this.lastPricingResponse = data;

    // Calculate initial billables
    this.calculateBillables()

    // Add event listeners for confirm and cancel buttons
    const applyNewBtn = document.querySelector('#pricing-apply-new-btn');
    const keepPreviousBtn = document.querySelector('#pricing-keep-previous-btn');
    const cancelBtn = document.querySelector('#pricing-cancel-btn');

    // Remove any existing listeners to prevent duplicates
    applyNewBtn.removeEventListener('click', this.boundApplyNew);
    keepPreviousBtn.removeEventListener('click', this.boundKeepPrevious);
    cancelBtn.removeEventListener('click', this.boundCancelChanges);

    // Bind methods to preserve 'this' context
    this.boundApplyNew = this.confirmChanges.bind(this, false);  // false = apply new
    this.boundKeepPrevious = this.confirmChanges.bind(this, true);  // true = keep previous
    this.boundCancelChanges = this.cancelChanges.bind(this);

    applyNewBtn.addEventListener('click', this.boundApplyNew);
    keepPreviousBtn.addEventListener('click', this.boundKeepPrevious);
    cancelBtn.addEventListener('click', this.boundCancelChanges);

    // Show modal
    this.bootstrapModal = new bootstrap.Modal(modal)
    this.bootstrapModal.show()

    // Clean up listeners when modal is hidden
    modal.addEventListener('hidden.bs.modal', () => {
      applyNewBtn.removeEventListener('click', this.boundApplyNew);
      keepPreviousBtn.removeEventListener('click', this.boundKeepPrevious);
      cancelBtn.removeEventListener('click', this.boundCancelChanges);
    }, { once: true });
  }

  calculateBillables() {
    // Calculate billable monthly fee
    const monthlyFee = parseFloat(this.newMonthlyFee) || 0;
    const discountMf = parseFloat(this.modalDiscountMfInput?.value || 0);
    const scholarship = parseFloat(this.modalScholarshipInput?.value || 0);
    const discountPercentMf = (discountMf + scholarship) / 100;
    const billableMf = Math.max(0, monthlyFee * (1 - discountPercentMf));
    document.getElementById('billable-mf').textContent = this.formatCurrency(billableMf, this.newCurrencySymbol);

    // Calculate billable admission fee
    const admissionFee = parseFloat(this.newAdmissionFee) || 0;
    const discountAf = parseFloat(this.modalDiscountAfInput?.value || 0);
    const discountPercentAf = discountAf / 100;
    const billableAf = Math.max(0, admissionFee * (1 - discountPercentAf));
    document.getElementById('billable-af').textContent = this.formatCurrency(billableAf, this.newCurrencySymbol);

    // Calculate billable renewal fee
    const renewalFee = parseFloat(this.newRenewalFee) || 0;
    const discountRf = parseFloat(this.modalDiscountRfInput?.value || 0);
    const discountPercentRf = discountRf / 100;
    const billableRf = Math.max(0, renewalFee * (1 - discountPercentRf));
    document.getElementById('billable-rf').textContent = this.formatCurrency(billableRf, this.newCurrencySymbol);
  }

  confirmChanges(isKeepPrevious) {
    console.log(`Confirming changes - Keep previous: ${isKeepPrevious}`);

    if (!isKeepPrevious) {
      const monthlyFee = this.newMonthlyFee;
      const admissionFee = this.newAdmissionFee;
      const renewalFee = this.newRenewalFee;
      const discountMf = this.modalDiscountMfInput.value;
      const scholarship = this.modalScholarshipInput.value;
      const discountAf = this.modalDiscountAfInput.value;
      const discountRf = this.modalDiscountRfInput.value;

      const billableMf = monthlyFee * (1 - (parseFloat(discountMf) + parseFloat(scholarship)) / 100);
      const billableAf = admissionFee * (1 - parseFloat(discountAf) / 100);
      const billableRf = renewalFee * (1 - parseFloat(discountRf) / 100);

      this.pendingFormData.set('learner_info[learner_finance_attributes][monthly_fee]', monthlyFee);
      this.pendingFormData.set('learner_info[learner_finance_attributes][admission_fee]', admissionFee);
      this.pendingFormData.set('learner_info[learner_finance_attributes][renewal_fee]', renewalFee);
      this.pendingFormData.set('learner_info[learner_finance_attributes][discount_mf]', discountMf);
      this.pendingFormData.set('learner_info[learner_finance_attributes][scholarship]', scholarship);
      this.pendingFormData.set('learner_info[learner_finance_attributes][discount_af]', discountAf);
      this.pendingFormData.set('learner_info[learner_finance_attributes][discount_rf]', discountRf);
      this.pendingFormData.set('learner_info[learner_finance_attributes][billable_mf]', billableMf.toFixed(2));
      this.pendingFormData.set('learner_info[learner_finance_attributes][billable_af]', billableAf.toFixed(2));
      this.pendingFormData.set('learner_info[learner_finance_attributes][billable_rf]', billableRf.toFixed(2));
    } else {
      // Keep previous pricing: Do NOT set any finance fields (Rails will not overwrite existing records)
      console.log('Keeping previous finances – no changes to learner_finance_attributes');
    }

    // Always include the finance ID if it exists (to update the existing record without changing fees)
    const financeId = document.querySelector('input[name="learner_info[learner_finance_attributes][id]"]')?.value;
    if (financeId) {
      this.pendingFormData.set('learner_info[learner_finance_attributes][id]', financeId);
    }

    // Close the modal
    this.bootstrapModal.hide();

    // Submit the form with the (un)modified data
    this.submitFormWithData(this.pendingFormData);
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

  formatCurrency(amount, symbol = this.currencySymbolValue) {
    if (amount === null || amount === undefined || amount === '') {
      return `${symbol} 0.00`
    }
    return `${symbol} ${parseFloat(amount).toLocaleString('pt-PT', { minimumFractionDigits: 2, maximumFractionDigits: 2 })}`
  }
}
