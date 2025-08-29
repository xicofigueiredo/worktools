import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="consent-form"
export default class extends Controller {
  connect() {
    this.handleSubmit = this.handleSubmit.bind(this)
    this.element.addEventListener('submit', this.handleSubmit)

    // Important: Rails generates a hidden input before each checkbox. Target only the checkbox inputs.
    const over = this.element.querySelector('input[type="checkbox"][name="consent[confirmation_over_18]"]')
    const under = this.element.querySelector('input[type="checkbox"][name="consent[confirmation_under_18]"]')
    const learner = this.element.querySelector('input[name="consent[consent_approved_by_learner]"]')
    const guardian = this.element.querySelector('input[name="consent[consent_approved_by_guardian]"]')

    const toggleRequired = () => {
      if (over && over.checked) {
        if (learner) learner.setAttribute('required', 'required')
        if (guardian) guardian.removeAttribute('required')
      } else if (under && under.checked) {
        if (guardian) guardian.setAttribute('required', 'required')
        if (learner) learner.removeAttribute('required')
      } else {
        if (guardian) guardian.removeAttribute('required')
        if (learner) learner.removeAttribute('required')
      }
    }

    if (over) over.addEventListener('change', toggleRequired)
    if (under) under.addEventListener('change', toggleRequired)
    toggleRequired()
  }

  disconnect() {
    this.element.removeEventListener('submit', this.handleSubmit)
  }

  handleSubmit(event) {
    // First leverage native HTML5 validation for required fields
    if (!this.element.checkValidity()) {
      event.preventDefault()
      this.element.reportValidity()
      return
    }

    // Enforce pair rule
    const over = this.element.querySelector('input[type="checkbox"][name="consent[confirmation_over_18]"]')
    const under = this.element.querySelector('input[type="checkbox"][name="consent[confirmation_under_18]"]')
    const learner = this.element.querySelector('input[name="consent[consent_approved_by_learner]"]')
    const guardian = this.element.querySelector('input[name="consent[consent_approved_by_guardian]"]')

    const overPair = over && over.checked && learner && learner.value.trim().length > 0
    const underPair = under && under.checked && guardian && guardian.value.trim().length > 0

    if (!(overPair || underPair)) {
      event.preventDefault()
      if (learner) learner.classList.toggle('is-invalid', !overPair)
      if (guardian) guardian.classList.toggle('is-invalid', !underPair)
      window.alert('Please provide either: (18+ confirmation and learner name) OR (under-18 confirmation and guardian name).')
    }
  }
}
