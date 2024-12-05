import { Controller } from "@hotwired/stimulus"


export default class extends Controller {
  static targets = ["startDate", "endDate", "error", "submitButton"];

  connect() {
    if (!this.initialized) {
      this.initialized = true;
      this.timelines = this.getTimelines();
      console.log("Timelines loaded:", this.timelines); // Debugging line
      this.startDateTarget.addEventListener("change", this.validateDates.bind(this));
      this.endDateTarget.addEventListener("change", this.validateDates.bind(this));
      this.validateDates(); // Initial validation
    } else {
      console.log("Controller already initialized");
    }
  }

  getTimelines() {
    const timelinesDataElement = document.getElementById('timelines-data');
    if (timelinesDataElement) {
      try {
        return JSON.parse(timelinesDataElement.textContent);
      } catch (error) {
        console.error("Error parsing timelines JSON:", error);
        return [];
      }
    }
    return [];
  }

  validateDates() {
    const startDate = new Date(this.startDateTarget.value);
    const endDate = new Date(this.endDateTarget.value);
    const errorMessages = [];

    // Validation: start_date must be before end_date
    if (startDate >= endDate) {
      errorMessages.push("End date must be after the start date.");
    } else if (endDate - startDate > 1000 * 60 * 60 * 24 * 30 * 5) {
      errorMessages.push("Holiday period cannot be longer than 5 months.");
    }


    // Validation: holiday should not contain any existing timeline period
    this.timelines.forEach(timeline => {
      const timelineStart = new Date(timeline.start);
      const timelineEnd = new Date(timeline.end);

      if (this.containsTimeline(startDate, endDate, timelineStart, timelineEnd)) {
        errorMessages.push(`Holiday period cannot contain the timeline: ${timeline.name}.`);
      }
    });

    this.showErrors(errorMessages);
    this.toggleSubmitButton(errorMessages.length === 0);
  }

  containsTimeline(holidayStart, holidayEnd, timelineStart, timelineEnd) {
    return holidayStart <= timelineStart && holidayEnd >= timelineEnd;
  }

  showErrors(errors) {
    const errorContainer = this.errorTarget;
    errorContainer.innerHTML = ""; // Clear previous errors
    if (errors.length > 0) {
      errorContainer.style.display = 'block'; // Show the error container if there are errors
      const errorList = document.createElement("ul");
      errors.forEach(error => {
        const errorElement = document.createElement("li");
        errorElement.className = "alert alert-danger";
        errorElement.innerText = error;
        errorList.appendChild(errorElement);
      });
      errorContainer.appendChild(errorList);
    } else {
      errorContainer.style.display = 'none'; // Hide the error container if no errors
    }
  }

  toggleSubmitButton(enable) {
    this.submitButtonTarget.disabled = !enable;
  }
}
