// app/javascript/controllers/auto_save_controller.js
import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  save(event) {
    const field = event.target;
    const form = field.closest("form");
    const url = form.action;

    // Prepare the data to be sent, only including the specific field
    const formData = new FormData();
    formData.append(field.name, field.value);

    // Use Fetch API to send the data asynchronously
    fetch(url, {
      method: "PATCH",
      body: formData,
      headers: {
        "X-CSRF-Token": document.querySelector("[name='csrf-token']").content
      }
    })
    .then(response => {
      if (!response.ok) {
        throw new Error("Network response was not ok");
      }
      return response.json();
    })
    .then(data => {
      console.log("Field updated successfully", data);
    })
    .catch(error => {
      console.error("Error updating field:", error);
    });
  }
}
