import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["form"]
  static values = {
    enrollId: Number
  }

  connect() {
    console.log("Paper costs controller connected")
  }

  async save(event) {
    event.preventDefault()
    const formData = new FormData(this.formTarget)

    try {
      const response = await fetch(`/exam_enrolls/${this.enrollIdValue}/update_paper_costs`, {
        method: 'PATCH',
        headers: {
          'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content,
          'Accept': 'application/json'
        },
        body: formData
      })

      const data = await response.json()

      if (response.ok) {
        // Show success message
        const successAlert = document.createElement('div')
        successAlert.className = 'alert alert-success alert-dismissible fade show mt-2'
        successAlert.innerHTML = `
          Papers updated successfully
          <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        `
        this.formTarget.insertAdjacentElement('afterend', successAlert)

        // Auto-dismiss after 3 seconds
        setTimeout(() => {
          successAlert.remove()
        }, 3000)
      } else {
        // Show error message
        const errorAlert = document.createElement('div')
        errorAlert.className = 'alert alert-danger alert-dismissible fade show mt-2'
        errorAlert.innerHTML = `
          ${data.errors.join('<br>')}
          <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        `
        this.formTarget.insertAdjacentElement('afterend', errorAlert)
      }
    } catch (error) {
      console.error('Error saving paper costs:', error)
      // Show error message
      const errorAlert = document.createElement('div')
      errorAlert.className = 'alert alert-danger alert-dismissible fade show mt-2'
      errorAlert.innerHTML = `
        Failed to save paper costs. Please try again.
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
      `
      this.formTarget.insertAdjacentElement('afterend', errorAlert)
    }
  }
}
