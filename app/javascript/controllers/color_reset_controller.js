import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["colorPicker"];

  reset() {
    this.colorPickerTarget.value = "#F4F4F4";
  }
}
