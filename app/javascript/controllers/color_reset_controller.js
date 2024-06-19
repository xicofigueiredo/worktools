import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["colorPicker"];

  connect() {
    console.log("Im connected dog");
  }

  reset() {
    this.colorPickerTarget.value = "#F4F4F4";
  }
}
