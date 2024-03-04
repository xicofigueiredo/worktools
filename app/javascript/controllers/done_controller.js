import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  connect() {
    console.log("Done")
  }

  static targets = ["button"];

  async toggleDone() {
    const response = await fetch(`/user_topics/${this.data.get("topicId")}/toggle_done`, {
      method: "PATCH",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').getAttribute('content')
      }
    });

    if (response.ok) {
      const data = await response.json();
      this.element.innerText = data.done ? "Done" : "Mark as Done";
    } else {
      console.error("Failed to toggle done status.");
    }
  }
}
