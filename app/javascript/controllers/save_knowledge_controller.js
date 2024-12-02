// app/javascript/controllers/save_knowledge_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    // Select all input and textarea fields within the form
    this.inputs = this.element.querySelectorAll("input, textarea")

    // Bind the handleBlur method to maintain the correct context
    this.handleBlurBound = this.handleBlur.bind(this)

    // Attach blur event listeners to each input and textarea
    this.inputs.forEach(input => {
      input.addEventListener("blur", this.handleBlurBound)
    })
  }

  disconnect() {
    // Remove blur event listeners when the controller is disconnected
    this.inputs.forEach(input => {
      input.removeEventListener("blur", this.handleBlurBound)
    })
  }

  handleBlur(event) {
    // Debounce the save to prevent rapid multiple submissions
    if (this.saveTimeout) clearTimeout(this.saveTimeout)

    this.saveTimeout = setTimeout(() => {
      this.submitForm()
    }, 500) // Delay in milliseconds; adjust as needed
  }

  submitForm() {
    const form = this.element
    const url = form.action
    const method = form.method.toUpperCase()

    const formData = new FormData(form)

    fetch(url, {
      method: method,
      body: formData,
      headers: {
        "X-CSRF-Token": document.querySelector("meta[name='csrf-token']").content
      }
    })
    .then(response => response.json())
    .then(data => {
      if (data.status === 'success') {
        this.showSuccess()
      } else {
        this.showError(data.message)
      }
    })
    .catch(error => {
      console.error("Error saving knowledge:", error)
    })
  }

  showSuccess() {
    // Display a success message or visual indicator
    // For simplicity, using alert. You can replace this with a custom notification.
    alert("Knowledge saved successfully.")

    // Optionally, add a CSS class for visual feedback
    this.element.classList.add("is-saved")
    setTimeout(() => {
      this.element.classList.remove("is-saved")
    }, 2000)
  }

  showError(message) {
    // Optionally, add a CSS class for error indication
    this.element.classList.add("is-error")
    setTimeout(() => {
      this.element.classList.remove("is-error")
    }, 2000)
  }
}
