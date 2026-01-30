import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["totalHours", "totalCredits", "weightWarning"]

  connect() {
    // Store bound function references for proper cleanup
    this.boundRecalculate = this.recalculate.bind(this)

    // Listen for custom event from activity row controllers
    document.addEventListener('activity:saved', this.boundRecalculate)
    // Also listen for input changes to update totals and warnings in real-time
    document.addEventListener('activity:weightChanged', this.boundRecalculate)
    // Initial check
    this.recalculate()
  }

  disconnect() {
    document.removeEventListener('activity:saved', this.boundRecalculate)
    document.removeEventListener('activity:weightChanged', this.boundRecalculate)
  }

  recalculate() {
    // Find all visible activity rows (not hidden activities)
    const visibleRows = document.querySelectorAll('tr[data-controller="activity-row-calculator"]:not([data-hidden="true"])')

    let totalHours = 0
    let totalCredits = 0

    visibleRows.forEach(row => {
      const hoursInput = row.querySelector('[data-activity-row-calculator-target="hours"]')
      const creditsHidden = row.querySelector('[data-activity-row-calculator-target="creditsHidden"]')

      if (hoursInput) {
        totalHours += parseFloat(hoursInput.value) || 0
      }
      if (creditsHidden && creditsHidden.value) {
        totalCredits += parseFloat(creditsHidden.value) || 0
      }
    })

    if (this.hasTotalHoursTarget) {
      this.totalHoursTarget.textContent = totalHours
    }
    if (this.hasTotalCreditsTarget) {
      this.totalCreditsTarget.textContent = totalCredits.toFixed(2)
    }

    this.checkBaseCredits()
  }

  checkBaseCredits() {
    // Find all visible activity rows (not hidden)
    const visibleRows = document.querySelectorAll('tr[data-controller="activity-row-calculator"]:not([data-hidden="true"])')

    // Group base credits by activity type
    const baseCreditsByType = {}
    const maxBaseCreditsPerCategory = 3.5

    visibleRows.forEach(row => {
      const activityType = row.dataset.activityType
      if (!activityType) return

      const hoursInput = row.querySelector('[data-activity-row-calculator-target="hours"]')
      const hours = parseFloat(hoursInput?.value) || 0

      // Calculate base credits: hours / 8, max 3.5
      const baseCredits = hours > 0 ? Math.min(hours / 8, 3.5) : 0

      if (!baseCreditsByType[activityType]) {
        baseCreditsByType[activityType] = 0
      }
      baseCreditsByType[activityType] += baseCredits
    })

    // Check each category and build warnings
    const warnings = []
    const categories = Object.keys(baseCreditsByType)

    categories.forEach(type => {
      const total = baseCreditsByType[type]
      if (total > maxBaseCreditsPerCategory) {
        const excess = (total - maxBaseCreditsPerCategory).toFixed(2)
        warnings.push(`<strong>${type}</strong>: ${total.toFixed(2)} base credits (max ${maxBaseCreditsPerCategory}, ${excess} over)`)
      }
    })

    // Display warnings
    if (this.hasWeightWarningTarget) {
      if (warnings.length > 0) {
        this.weightWarningTarget.innerHTML = `
          <div class="alert alert-warning mb-0 py-2">
            <i class="fa-solid fa-triangle-exclamation me-2"></i>
            <strong>Base Credits Warning:</strong> ${warnings.join(' | ')}
          </div>
        `
        this.weightWarningTarget.style.display = 'block'
      } else {
        this.weightWarningTarget.style.display = 'none'
      }
    }
  }
}
