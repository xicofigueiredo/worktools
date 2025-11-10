import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["activitiesContainer", "template", "form"];

  connect() {
    this.deletedActivityIds = [];
  }

  addRow(event) {
    event.preventDefault();
    const template = this.templateTarget;

    if (template) {
      let content = template.innerHTML.replace(
        /TEMPLATE_INDEX/g,
        new Date().getTime()
      );

      this.activitiesContainerTarget.insertAdjacentHTML("beforeend", content);
    } else {
      console.error("Template not found.");
    }
  }

  removeRow(event) {
    event.preventDefault();
    const button = event.target.closest("button");
    const row = button.closest("tr");

    if (row) {
      const activityId = button.dataset.activityId;
      if (activityId) {
        this.deletedActivityIds.push(activityId);
        // Mark the row for destruction
        const destroyField = row.querySelector('input[name*="[_destroy]"]');
        if (destroyField) {
          destroyField.value = "true";
        }
        // Hide the row instead of removing it, so the _destroy field is still submitted
        row.style.display = "none";
      } else {
        // For new rows (no ID), just remove them since they're not in the database yet
        row.remove();
      }
    }
  }
}
