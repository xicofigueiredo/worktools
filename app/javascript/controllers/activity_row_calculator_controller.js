import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["hours", "extra", "finalCredits", "creditsHidden", "form"]
  static values = {
    maxCredits: { type: Number, default: 3.5 },
    divisor: { type: Number, default: 8 },
    activityType: { type: String, default: '' },
    activityName: { type: String, default: '' }
  }

  connect() {
    this.calculate()
    this.initialHours = this.hoursTarget.value
    this.initialExtra = this.extraTarget.value
    this.saving = false
    this.pendingJustification = null
  }

  get isSpecialActivity() {
    return ['build_week', 'hub_activities'].includes(this.activityTypeValue)
  }

  calculate() {
    const hours = parseFloat(this.hoursTarget.value) || 0
    const extra = parseFloat(this.extraTarget.value) || 0

    // Calculate base credits: hours / 8, max 3.5
    let baseCredits = 0
    if (hours > 0) {
      baseCredits = Math.min(hours / this.divisorValue, this.maxCreditsValue)
    }

    // Calculate final credits: base credits + extra
    let finalCredits = 0
    if (baseCredits > 0 || extra > 0) {
      finalCredits = baseCredits + extra
    }

    // Update displays
    this.finalCreditsTarget.textContent = finalCredits > 0 ? finalCredits.toFixed(2) : '-'

    // Update hidden field for form submission
    if (this.hasCreditsHiddenTarget) {
      this.creditsHiddenTarget.value = finalCredits > 0 ? finalCredits.toFixed(2) : ''
    }

    // Dispatch event to update warnings in real-time
    document.dispatchEvent(new CustomEvent('activity:weightChanged'))
  }

  async save(event) {
    const currentHours = this.hoursTarget.value
    const currentExtra = this.extraTarget.value
    const previousExtra = parseFloat(this.initialExtra) || 0
    const newExtra = parseFloat(currentExtra) || 0

    if (this.saving) return

    // Check if extra credits were added (was 0, now > 0)
    if (previousExtra === 0 && newExtra > 0 && event?.target === this.extraTarget) {
      // For build_week and hub_activities, auto-set justification (no modal needed)
      if (this.isSpecialActivity) {
        const justification = this.activityNameValue || (this.activityTypeValue === 'build_week' ? 'Build Week' : 'Hub Activities')
        this.addJustificationToForm(justification)
        await this.performSave()
        return
      }

      // For other activities, show modal to get justification
      this.showJustificationModal(newExtra)
      return
    }

    const hasChanges = currentHours !== this.initialHours || currentExtra !== this.initialExtra

    if (hasChanges) {
      await this.performSave()
    }
  }

  showJustificationModal(extraAmount) {
    const modal = document.getElementById('extraJustificationModal')
    if (!modal) {
      // If modal doesn't exist, just save without justification
      this.performSave()
      return
    }

    const amountEl = document.getElementById('extraCreditsAmount')
    const inputEl = document.getElementById('extraJustificationInput')
    const saveBtn = document.getElementById('saveExtraCredits')
    const cancelBtn = document.getElementById('cancelExtraCredits')

    if (amountEl) amountEl.textContent = extraAmount

    // Clear previous input
    if (inputEl) {
      inputEl.value = ''
      inputEl.classList.remove('is-invalid')
    }

    // Store reference to this controller for the modal handlers
    this.pendingJustification = {
      extraAmount,
      inputEl,
      saveBtn,
      cancelBtn
    }

    // Set up event handlers
    const handleSave = () => {
      const justification = inputEl.value.trim()
      if (!justification) {
        inputEl.classList.add('is-invalid')
        return
      }
      inputEl.classList.remove('is-invalid')

      // Add justification to form
      this.addJustificationToForm(justification)

      // Close modal and save
      const bsModal = bootstrap.Modal.getInstance(modal)
      bsModal.hide()
      this.performSave()

      // Clean up
      saveBtn.removeEventListener('click', handleSave)
    }

    const handleCancel = () => {
      // Revert extra to initial value
      this.extraTarget.value = this.initialExtra
      this.calculate()

      // Clean up
      saveBtn.removeEventListener('click', handleSave)
    }

    // Remove old handlers and add new ones
    saveBtn.onclick = handleSave
    cancelBtn.onclick = handleCancel

    // Also handle modal dismiss (X button or clicking outside)
    modal.addEventListener('hidden.bs.modal', () => {
      if (this.extraTarget.value !== this.initialExtra && !this.saving) {
        this.extraTarget.value = this.initialExtra
        this.calculate()
      }
    }, { once: true })

    // Show the modal
    const bsModal = new bootstrap.Modal(modal)
    bsModal.show()
  }

  addJustificationToForm(justification) {
    const form = this.hasFormTarget ? this.formTarget : this.element.querySelector('form')
    if (!form) return

    // Remove existing justification input if present
    const existingInput = form.querySelector('input[name="csc_activity[extra_justification]"]')
    if (existingInput) {
      existingInput.value = justification
    } else {
      // Create a hidden input for justification
      const input = document.createElement('input')
      input.type = 'hidden'
      input.name = 'csc_activity[extra_justification]'
      input.value = justification
      form.appendChild(input)
    }
  }

  async performSave() {
    const currentHours = this.hoursTarget.value
    const currentExtra = this.extraTarget.value

    this.saving = true

    const form = this.hasFormTarget ? this.formTarget : this.element.querySelector('form')
    if (form) {
      const formData = new FormData(form)

      try {
        const response = await fetch(form.action, {
          method: 'PATCH',
          body: formData,
          headers: {
            'Accept': 'text/vnd.turbo-stream.html, text/html, application/xhtml+xml'
          }
        })

        if (response.ok) {
          // Update initial values after successful save
          this.initialHours = currentHours
          this.initialExtra = currentExtra

          // Brief visual feedback
          form.classList.add('bg-success-subtle')
          setTimeout(() => form.classList.remove('bg-success-subtle'), 500)

          // Update tooltip if justification was added
          const justificationInput = form.querySelector('input[name="csc_activity[extra_justification]"]')
          if (justificationInput && justificationInput.value) {
            this.extraTarget.setAttribute('data-bs-toggle', 'tooltip')
            this.extraTarget.setAttribute('title', justificationInput.value)
            // Reinitialize tooltip
            if (typeof bootstrap !== 'undefined' && bootstrap.Tooltip) {
              const existingTooltip = bootstrap.Tooltip.getInstance(this.extraTarget)
              if (existingTooltip) existingTooltip.dispose()
              new bootstrap.Tooltip(this.extraTarget)
            }
          }

          // Dispatch event to update totals
          document.dispatchEvent(new CustomEvent('activity:saved'))
        }
      } catch (error) {
        console.error('Save failed:', error)
      } finally {
        this.saving = false
      }
    }
  }
}
