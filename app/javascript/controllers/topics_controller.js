import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="topics-filter"
export default class extends Controller {
  static targets = ["subject", "topic"]

  connect() {
    console.log("Subject controller connected");
  }

  updateTopics() {
    console.log("updateTopics called");
    const selectedSubject = this.subjectTarget.value;
    const topicSelect = this.topicTarget;
    const subjectId = event.target.value;


    // Clear existing options
    while (topicSelect.firstChild) {
      topicSelect.removeChild(topicSelect.firstChild);
    }

    // Fetch new topics based on selected subject
    fetch(`/weekly_goals/topics_for_subject/${subjectId}`)
      .then(response => response.json())
      .then(topics => {
        topics.forEach(topic => {
          const option = document.createElement('option');
          option.value = topic.id;
          option.text = topic.name;
          topicSelect.appendChild(option);
        });
      });
  }
}
