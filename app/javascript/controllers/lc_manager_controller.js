import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["lcList", "removeButton"]

  connect() {
    // Add Turbo stream handler for successful removal
    document.addEventListener("turbo:before-stream-render", (event) => {
      if (event.target.action === "remove") {
        const row = event.target.target.closest("tr")
        if (row) row.remove()
      }
    })
  }

  remove(event) {
    event.preventDefault()

    if (!confirm("Are you sure you want to remove this Learning Coach?")) {
      return
    }

    const button = event.currentTarget
    const reportId = button.dataset.reportId
    const lcId = button.dataset.lcId

    fetch(`/reports/${reportId}/remove_lc`, {
      method: 'POST',
      headers: {
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content,
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({ lc_id: lcId })
    })
    .then(response => response.json())
    .then(data => {
      if (data.success) {
        // Remove the row from the table
        button.closest('tr').remove()
      } else {
        alert(data.error)
      }
    })
    .catch(error => {
      console.error('Error:', error)
      alert('Failed to remove Learning Coach')
    })
  }
}
