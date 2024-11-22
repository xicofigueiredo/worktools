import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["subject", "topicContainer", "customTopic", "thirdBox"]; // Add customTopic and thirdBox as targets

  connect() {
    const selectedTopic = this.topicContainerTarget.dataset.selectedTopic || "";
    const subjectName = this.subjectTarget.value;

    if (selectedTopic === "Other") {
      // If "Other" is selected, show the text input and third box
      this.showCustomInput(selectedTopic);
      this.showThirdBox();
    } else {
      // If a topic is selected, fetch and populate topics in the dropdown
      this.fetchAndUpdateTopics(subjectName, selectedTopic);
    }
  }

  updateTopics() {
    const subjectName = this.subjectTarget.value;
    const topicSelect = this.topicContainerTarget.querySelector("select");
    const existingTopicName = this.topicContainerTarget.dataset.selectedTopic || "";

    if (subjectName === "Other" || (topicSelect && topicSelect.value === "Other")) {
      // If "Other" is selected, show the custom input box
      this.showCustomInput(existingTopicName);
      this.showThirdBox();

      // Ensure the custom input field is included in the form submission
      if (this.customTopicTarget) {
        this.customTopicTarget.setAttribute("name", this.subjectTarget.name.replace("subject", "topic"));
      }
    } else {
      // Reset to the dropdown and fetch topics
      this.resetToSelect();
      this.fetchAndUpdateTopics(subjectName);
      this.clearCustomTopic(); // Clear the custom topic value
      this.hideThirdBox();
    }
  }


  showCustomInput(existingValue = "") {
    this.topicContainerTarget.innerHTML = `
      <input type="text" name="${this.subjectTarget.name.replace("subject", "topic")}"
             class="form-control" value="${existingValue}" placeholder="Enter custom topic"
             data-selects-target="customTopic">`;
  }

  resetToSelect() {
    this.topicContainerTarget.innerHTML = `
      <select name="${this.subjectTarget.name.replace("subject", "topic")}" class="form-control">
        <option value="">Select a topic</option>
      </select>`;
  }

  clearCustomTopic() {
    if (this.hasCustomTopicTarget) {
      this.customTopicTarget.value = "";
    }
  }

  showThirdBox() {
    if (this.hasThirdBoxTarget) {
      this.thirdBoxTarget.style.display = "block";
    }
  }

  hideThirdBox() {
    if (this.hasThirdBoxTarget) {
      this.thirdBoxTarget.style.display = "none";
    }
  }

  fetchAndUpdateTopics(subjectName, selectedTopic = null) {
    const topicSelect = this.topicContainerTarget.querySelector("select");

    if (subjectName) {
      fetch(`/topics_for_subject?subject_name=${encodeURIComponent(subjectName)}`, {
        method: "GET",
        headers: {
          "X-CSRF-Token": document.querySelector("meta[name='csrf-token']").content,
          "Content-Type": "application/json",
        },
      })
        .then((response) => response.json())
        .then((data) => {
          // Add fetched topics to the dropdown
          data.forEach((topic) => {
            const option = document.createElement("option");
            option.value = topic.name;
            option.text = topic.name;
            if (selectedTopic && topic.name === selectedTopic) {
              option.selected = true;
            }
            topicSelect.appendChild(option);
          });

          // Add "Other" option to the dropdown
          const otherOption = document.createElement("option");
          otherOption.value = "Other";
          otherOption.text = "Other";
          if (selectedTopic === "Other") {
            otherOption.selected = true;
          }
          topicSelect.appendChild(otherOption);
        })
        .catch((error) => console.error("Error:", error));
    }
  }
}
