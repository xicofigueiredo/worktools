import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["subject", "topic"]

  connect() {
    console.log("Selects controller connected");
  }

  updateTopics() {
    const subjectName = this.subjectTarget.value;
    const topicSelect = this.topicTarget;

    fetch(`/topics_for_subject?subject_name=${encodeURIComponent(subjectName)}`, {
      method: 'GET',
      headers: {
        'X-CSRF-Token': document.querySelector("meta[name='csrf-token']").getAttribute("content"),
        'Content-Type': 'application/json'
      }
    })
    .then(response => response.json())
    .then(data => {
      topicSelect.innerHTML = '<option value="">Select Topic</option>';
      data.forEach((topic) => {
        const option = document.createElement('option');
        option.value = topic.name;
        option.text = topic.name;
        topicSelect.appendChild(option);
      });
    })
    .catch(error => console.error('Error:', error));
  }
}
