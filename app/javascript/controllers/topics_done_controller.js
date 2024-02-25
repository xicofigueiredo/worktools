import { Controller } from "stimulus"

// Connects to data-controller="topics-done"
export default class extends Controller {
  connect() {
    console.log("Hello, Stimulus!", this.element)
  }
}
