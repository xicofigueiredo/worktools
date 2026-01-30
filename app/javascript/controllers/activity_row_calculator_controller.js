import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["hours", "extra", "baseCredits", "finalCredits", "creditsHidden", "form"]
  static values = {
    maxCredits: { type: Number, default: 3.5 },
    divisor: { type: Number, default: 8 }
  }

  connect() {
    this.calculate()
    this.initialHours = this.hoursTarget.value
    this.initialExtra = this.extraTarget.value
    this.saving = false
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
    this.baseCreditsTarget.textContent = baseCredits > 0 ? baseCredits.toFixed(2) : '-'
    this.finalCreditsTarget.textContent = finalCredits > 0 ? finalCredits.toFixed(2) : '-'

    // Update hidden field for form submission
    if (this.hasCreditsHiddenTarget) {
      this.creditsHiddenTarget.value = finalCredits > 0 ? finalCredits.toFixed(2) : ''
    }

    // Dispatch event to update warnings in real-time
    document.dispatchEvent(new CustomEvent('activity:weightChanged'))
  }

  async save(event) {
    // Only save if value has changed and not already saving
    const currentHours = this.hoursTarget.value
    const currentExtra = this.extraTarget.value

    if (this.saving) return

    if (currentHours !== this.initialHours || currentExtra !== this.initialExtra) {
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
}
