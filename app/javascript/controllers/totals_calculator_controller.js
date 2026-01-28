import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["totalHours", "totalCredits"]

  connect() {
    // Listen for custom event from activity row controllers
    document.addEventListener('activity:saved', this.recalculate.bind(this))
  }

  disconnect() {
    document.removeEventListener('activity:saved', this.recalculate.bind(this))
  }

  recalculate() {
    // Find all visible activity rows (not hidden activities)
    const visibleRows = document.querySelectorAll('tr[data-controller="activity-row-calculator"]:not(.table-secondary)')

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
  }
}
