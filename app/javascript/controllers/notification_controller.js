import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["item", "button"]
  static values = {
    id: String
  }

  markAsRead(event) {
    event.preventDefault()
    this.markNotificationAsRead()
  }

  markAsReadAndNavigate(event) {
    // Don't prevent default here, so the link navigation will work
    this.markNotificationAsRead()
  }

  markNotificationAsRead() {
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
        const buttonTarget = this.element.querySelector('[data-notification-target="button"]')
        if (buttonTarget) {
          buttonTarget.remove()
        }
        // Update the envelope icon
        const iconContainer = this.itemTarget.querySelector('.d-flex')
        if (iconContainer) {
          iconContainer.innerHTML = '<i class="fa-regular fa-envelope-open"></i>'
        }
      } else {
        console.error('Failed to mark notification as read')
      }
    })
    .catch(error => {
      console.error('Error:', error)
    })
  }
}
