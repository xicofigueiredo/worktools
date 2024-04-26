import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["subject", "topic"]

  connect() {
    console.log("Selects controller connected");
    if (this.subjectTarget.value) {
      this.updateTopics(true);
    }
  }

  updateTopics(preserveSelectedTopic = false) {
    const subjectName = this.subjectTarget.value;
    const topicSelect = this.topicTarget;
    const currentTopic = preserveSelectedTopic ? topicSelect.value : null;

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
      // Restore the previously selected topic, if applicable
      if (currentTopic) {
        topicSelect.value = currentTopic;
        if (topicSelect.value !== currentTopic) {
          // Handle the case where the previous topic is no longer valid for the selected subject
          console.warn("Previously selected topic is not valid for the new subject.");
        }
      }
    })
    .catch(error => console.error('Error:', error));
  }
}
