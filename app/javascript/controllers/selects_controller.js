import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["subject", "topicContainer"];

  connect() {
    console.log("Selects controller connected");
    this.updateTopics();
  }

  updateTopics() {
    const subjectName = this.subjectTarget.value;
    const existingTopicName = this.topicContainerTarget.dataset.selectedTopic;

    if (subjectName === "Other") {
      console.log("Switching to input because Other is selected");
      this.topicContainerTarget.innerHTML = `<input type="text" name="${this.subjectTarget.name.replace(
        "subject",
        "topic"
      )}" class="form-control" value="${
        existingTopicName || ""
      }" placeholder="">`;
    } else {
      this.resetSelect();
      this.fetchAndUpdateTopics(subjectName);
    }
  }

  resetSelect() {
    this.topicContainerTarget.innerHTML = `<select name="${this.subjectTarget.name.replace(
      "subject",
      "topic"
    )}" class="form-control"><option value=""></option></select>`;
  }

  fetchAndUpdateTopics(subjectName) {
    const topicSelect = this.topicContainerTarget.querySelector("select");
    const existingTopicName = this.topicContainerTarget.dataset.selectedTopic;

    if (subjectName) {
      fetch(
        `/topics_for_subject?subject_name=${encodeURIComponent(subjectName)}`,
        {
          method: "GET",
          headers: {
            "X-CSRF-Token": document
              .querySelector("meta[name='csrf-token']")
              .getAttribute("content"),
            "Content-Type": "application/json",
          },
        }
      )
        .then((response) => response.json())
        .then((data) => {
          data.forEach((topic) => {
            const option = document.createElement("option");
            option.value = topic.name;
            option.text = topic.name;
            if (topic.name === existingTopicName) {
              option.selected = true; // Mark the option as selected if it matches the existing topic name
            }
            topicSelect.appendChild(option);
          });
        })
        .catch((error) => console.error("Error:", error));
    }
  }
}
