// app/javascript/controllers/toggle_done_controller.js
import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["checkbox"]; // Assuming you have 'data-toggle-done-target="checkbox"' on your checkbox

  connect() {
    console.log("connected");
  }

  toggle(event) {
    const checkbox = event.target;
    const userTopicId = checkbox.dataset.userTopicId; // Correctly access the userTopicId
    const timelineId = checkbox.dataset.timelineId;

    console.log("Called toggle with: ", { userTopicId, timelineId });

    fetch(`/user_topics/${userTopicId}/toggle_done`, {
      method: "PATCH",
      headers: {
        "X-CSRF-Token": this.getMetaValue("csrf-token"),
        "Content-Type": "application/json",
        Accept: "application/json",
      },
      body: JSON.stringify({
        done: this.checkboxTarget.checked, // Assuming you want to send the checked state of the checkbox
        timeline_id: timelineId,
      }),
    })
      .then((response) => {
        if (!response.ok) {
          throw new Error("Network response was not ok");
        }
        return response.json();
      })
      .then((data) => {
        console.log(data); // Handle success
      })
      .catch((error) => {
        console.error(
          "There has been a problem with your fetch operation:",
          error
        ); // Handle error
      });
  }

  getMetaValue(name) {
    const element = document.head.querySelector(`meta[name="${name}"]`);
    return element.getAttribute("content");
  }
}
