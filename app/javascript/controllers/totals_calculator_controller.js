import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["totalHours", "totalCredits", "weightWarning"]

  connect() {
    // Listen for custom event from activity row controllers
    document.addEventListener('activity:saved', this.recalculate.bind(this))
    // Also listen for input changes to update warnings in real-time
    document.addEventListener('activity:weightChanged', this.checkWeights.bind(this))
    // Initial check
    this.recalculate()
    this.checkWeights()
  }

  disconnect() {
    document.removeEventListener('activity:saved', this.recalculate.bind(this))
    document.removeEventListener('activity:weightChanged', this.checkWeights.bind(this))
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

    this.checkWeights()
  }

  checkWeights() {
    // Find all visible activity rows (not hidden)
    const visibleRows = document.querySelectorAll('tr[data-controller="activity-row-calculator"]:not([data-hidden="true"])')

    // Group weights by activity type
    const weightsByType = {}
    const typeCount = new Set()

    visibleRows.forEach(row => {
      const activityType = row.dataset.activityType
      if (!activityType) return

      typeCount.add(activityType)

      const weightInput = row.querySelector('[data-activity-row-calculator-target="weight"]')
      const weight = parseFloat(weightInput?.value) || 0

      if (!weightsByType[activityType]) {
        weightsByType[activityType] = 0
      }
      weightsByType[activityType] += weight
    })

    // Determine expected total: 100 per category, or 200 if only one category
    const categories = Object.keys(weightsByType)
    const isSingleCategory = categories.length === 1
    const expectedTotal = isSingleCategory ? 200 : 100

    // Check each category and build warnings
    const warnings = []

    categories.forEach(type => {
      const total = weightsByType[type]
      if (total !== expectedTotal) {
        const diff = expectedTotal - total
        const status = diff > 0 ? `${diff}% short` : `${Math.abs(diff)}% over`
        warnings.push(`<strong>${type}</strong>: ${total}% (should be ${expectedTotal}%, ${status})`)
      }
    })

    // Display warnings
    if (this.hasWeightWarningTarget) {
      if (warnings.length > 0) {
        this.weightWarningTarget.innerHTML = `
          <div class="alert alert-warning mb-0 py-2">
            <i class="fa-solid fa-triangle-exclamation me-2"></i>
            <strong>Weight Warning:</strong> ${warnings.join(' | ')}
            ${isSingleCategory ? '<br><small class="text-muted">Note: Single category detected - total should be 200%</small>' : ''}
          </div>
        `
        this.weightWarningTarget.style.display = 'block'
      } else {
        this.weightWarningTarget.style.display = 'none'
      }
    }
  }
}
