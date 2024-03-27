import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["subject", "topic"]

  connect() {
    console.log("Selects controller connected");
  }

  updateTopics(event) {
    const subjectId = this.subjectTarget.value;
    const url = `/weekly_goals/topics_for_subject?subject_id=${subjectId}`;

    fetch(url, {
      method: 'GET',
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    })
    .then(response => response.json())
    .then(data => {
      this.clearAndPopulateTopicSelect(data);
    })
    .catch(error => console.error('Error fetching topics:', error));
  }

  clearAndPopulateTopicSelect(topics) {
    const topicSelect = this.topicTarget;
    // Clears existing options except for the first placeholder
    topicSelect.innerHTML = '<option value="">Select Topic</option>';
    // Populates new options
    topics.forEach(topic => {
      const option = new Option(topic.name, topic.id);
      topicSelect.add(option);
    });
  }
}
