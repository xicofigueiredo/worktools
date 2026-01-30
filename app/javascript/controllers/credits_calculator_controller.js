import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["hours", "credits", "creditsDisplay", "weight", "finalCreditsDisplay"]
  static values = {
    maxCredits: { type: Number, default: 1.5 },
    divisor: { type: Number, default: 8 }
  }

  connect() {
    this.calculate()
    this.calculateFinalCredits()
  }

  calculate() {
    const hours = parseFloat(this.hoursTarget.value) || 0

    if (hours <= 0 || isNaN(hours)) {
      this.creditsDisplayTarget.value = '-'
      if (this.hasCreditsTarget) {
        this.creditsTarget.value = ''
      }
      this.calculateFinalCredits()
      return
    }

    let credits = hours / this.divisorValue
    credits = Math.min(credits, this.maxCreditsValue)

    const formattedCredits = credits.toFixed(2)
    this.creditsDisplayTarget.value = formattedCredits

    if (this.hasCreditsTarget) {
      this.creditsTarget.value = formattedCredits
    }

    this.calculateFinalCredits()
  }

  calculateFinalCredits() {
    const credits = parseFloat(this.creditsDisplayTarget.value) || 0
    const weight = parseFloat(this.weightTarget.value) || 0

    if (credits <= 0 || isNaN(credits) || weight <= 0 || isNaN(weight)) {
      this.finalCreditsDisplayTarget.value = '-'
      if (this.hasCreditsTarget) {
        this.creditsTarget.value = ''
      }
      return
    }

    // Weight is a percentage, so divide by 100 to get multiplier
    const multiplier = weight / 100
    const finalCredits = credits * multiplier

    this.finalCreditsDisplayTarget.value = finalCredits.toFixed(2)

    // Save final credits to the hidden field (this is what gets persisted to DB)
    if (this.hasCreditsTarget) {
      this.creditsTarget.value = finalCredits.toFixed(2)
    }
  }

  handlePaste(event) {
    // Wait for paste to complete before calculating
    setTimeout(() => {
      this.calculate()
      this.calculateFinalCredits()
    }, 10)
  }
}
