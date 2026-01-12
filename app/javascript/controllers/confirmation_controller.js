import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["modal"]

  openRejectModal(event) {
    const url = event.currentTarget.dataset.url
    const form = document.getElementById('rejectionForm')
    const modalElement = document.getElementById('sharedRejectModal')
    const modal = bootstrap.Modal.getOrCreateInstance(modalElement)

    form.action = url
    modal.show()
  }

  closeModal() {
    const modalElement = document.getElementById('sharedRejectModal')
    const modal = bootstrap.Modal.getInstance(modalElement)
    if (modal) {
      modal.hide()
    }
  }
}
