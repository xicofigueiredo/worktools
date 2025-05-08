import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["item", "button"]
  static values = {
    id: String
  }

  markAsRead(event) {
    event.preventDefault()

    fetch(`/notifications/${this.idValue}/mark_as_read`, {
      method: 'PATCH',
      headers: {
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content,
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      },
      credentials: 'same-origin'
    })
    .then(response => {
      if (response.ok) {
        this.itemTarget.classList.add('resolved')
        this.buttonTarget.remove()
        // Update the envelope icon
        const iconContainer = this.itemTarget.querySelector('.d-flex')
        iconContainer.innerHTML = '<i class="fa-regular fa-envelope-open"></i>'
      } else {
        console.error('Failed to mark notification as read')
      }
    })
    .catch(error => {
      console.error('Error:', error)
    })
  }
}
