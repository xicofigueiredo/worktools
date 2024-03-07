// app/javascript/controllers/subject_selection_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["subject", "topic"]

  connect() {
    console.log("Subject selection controller connected");
  }

  updateTopics(event) {
    const subjectId = this.subjectTarget.value;
    const token = document.querySelector("[name='csrf-token']").content;

    fetch(`/subjects/${subjectId}/topics`, {
      method: "GET",
      headers: {
        "X-CSRF-Token": token,
        "Content-Type": "application/json",
        "Accept": "application/json"
      }
    })
    .then(response => {
      if (!response.ok) {
        throw new Error('Network response was not ok');
      }
      return response.json();
    })
    .then(data => {
      this.populateTopics(data);
    })
    .catch(error => {
      console.error('There has been a problem with your fetch operation:', error);
    });
  }

  populateTopics(data) {
    this.topicTarget.innerHTML = '<option value="">Select Topic</option>'; // Reset topic dropdown
    data.forEach((topic) => {
      const option = document.createElement('option');
      option.value = topic.id;
      option.text = topic.name;
      this.topicTarget.appendChild(option);
    });
  }
}
