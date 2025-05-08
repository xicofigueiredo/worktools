import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["hubCheckbox", "mainHubSelect", "hubList"]
  static values = {
    userId: String,
    mainHubId: String
  }

  connect() {
    this.updateMainHubOptions()
  }

  updateMainHubOptions() {
    const selectedHubs = this.hubCheckboxTargets.filter(checkbox => checkbox.checked)
    const selectedHubIds = selectedHubs.map(checkbox => checkbox.value)

    // Update main hub select options
    this.mainHubSelectTarget.innerHTML = '<option value="">Select main hub</option>'
    selectedHubs.forEach(checkbox => {
      const option = document.createElement('option')
      option.value = checkbox.value
      option.textContent = checkbox.closest('.form-check').querySelector('label').textContent
      if (checkbox.value === this.mainHubIdValue) {
        option.selected = true
      }
      this.mainHubSelectTarget.appendChild(option)
    })

    // Show/hide main hub select based on whether any hubs are selected
    this.mainHubSelectTarget.closest('div').style.display = selectedHubs.length > 0 ? 'flex' : 'none'
  }

  async updateAssociations() {
    const selectedHubs = this.hubCheckboxTargets.filter(checkbox => checkbox.checked)
    const selectedHubIds = selectedHubs.map(checkbox => checkbox.value)
    const mainHubId = this.mainHubSelectTarget.value

    try {
      const response = await fetch(`/admin/users/${this.userIdValue}/update_hubs`, {
        method: 'PATCH',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
        },
        body: JSON.stringify({
          hub_ids: selectedHubIds,
          main_hub_id: mainHubId
        })
      })

      if (response.ok) {
        // Update the main hub ID value
        this.mainHubIdValue = mainHubId
        // Refresh the page or frame to update the list
        const frame = document.getElementById("users_list")
        if (frame) { frame.src = frame.src }
      } else {
        console.error('Failed to update hub associations')
      }
    } catch (error) {
      console.error('Error updating hub associations:', error)
    }
  }

  // Event handlers
  hubCheckboxChanged() {
    this.updateMainHubOptions()
    if (this.hubCheckboxTargets.filter(checkbox => checkbox.checked).length !== 1) {
      this.updateAssociations()
    }
  }

  mainHubChanged() {
    this.updateAssociations()
  }
}
