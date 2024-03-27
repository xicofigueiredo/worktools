import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { day: String, time: String }

  connect() {
    console.log(`Slot controller connected for day: ${this.dayValue}, time: ${this.timeValue}`);
  }

  showDropdown(event) {
    event.preventDefault();

    const formattedTime = this.timeValue.replace(':', '-');
    const dropdownsContainerId = `slot-dropdowns-${this.dayValue}-${formattedTime}`;
    console.log(`Looking for element with ID: ${dropdownsContainerId}`);

    const dropdownsContainer = document.getElementById(dropdownsContainerId);
    if (!dropdownsContainer) {
      console.error(`Element with ID ${dropdownsContainerId} not found.`);
      return;
    }

    // Proceed with setting innerHTML or adding elements...
  }
}
