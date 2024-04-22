import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="modals"
export default class extends Controller {
  connect() {}
  close(e) {
    e.preventDefault();
    const modal = document.getElementById("modal");
    modal.innerHTML = "";

    // Remove src attribute from the modal
    modal.removeAttribute("src");

    // Remove complete attribute
    modal.removeAttribute("complete");
  }
}
