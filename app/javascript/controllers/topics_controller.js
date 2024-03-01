import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="topics"
export default class extends Controller {

  static targets = ["checkbox"];
  connect() {  }
}
