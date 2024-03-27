import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["subject", "topic"]

  connect() {
    console.log("Selects controller connected");
  }

    updateTopics(event) {
      // Retrieves the selected subject ID
      const subjectId = this.subjectTarget.value;
      // Construct the URL for the fetch request
      const url = `/weekly_goals/topics_for_subject?subject_id=${subjectId}`;

      fetch(url, {
        headers: {
          'Accept': 'application/json',
        },
      })
      .then(response => response.json())
      .then(data => {
        // Assuming the JSON response is directly an array; if not, adjust this line accordingly.
        console.log(data); // Add this to log the actual structure of `data`
        this.clearAndPopulateTopicSelect(data.topics);
        this.populateTopics(data.topics);
      })
      .catch(error => console.error('Error fetching topics:', error));
    }

    // Helper method to clear existing options and populate new ones
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
