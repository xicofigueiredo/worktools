import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["startDate", "endDate", "error", "submitButton"];

  connect() {
    this.holidays = this.getHolidays();
    console.log("Holidays loaded:", this.holidays); // Debugging line
    this.startDateTarget.addEventListener("change", this.validateDates.bind(this));
    this.endDateTarget.addEventListener("change", this.validateDates.bind(this));
    this.validateDates(); // Initial validation
  }

  getHolidays() {
    const holidaysDataElement = document.getElementById('holidays-data');
    if (holidaysDataElement) {
      try {
        return JSON.parse(holidaysDataElement.textContent);
      } catch (error) {
        console.error("Error parsing holidays JSON:", error);
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
    }

    // Validation: timeline should not fall completely within any holiday period
    let isWithinHolidayPeriod = false;
    this.holidays.forEach(holiday => {
      const holidayStart = new Date(holiday.start);
      const holidayEnd = new Date(holiday.end);

      if (this.isWithinHoliday(startDate, endDate, holidayStart, holidayEnd)) {
        errorMessages.push("Timeline dates cannot be completely within a holiday period.");
        isWithinHolidayPeriod = true;
      }
    });

    this.showErrors(errorMessages);
    this.toggleSubmitButton(errorMessages.length === 0 && !isWithinHolidayPeriod);
  }

  isWithinHoliday(startDate, endDate, holidayStart, holidayEnd) {
    return startDate >= holidayStart && endDate <= holidayEnd;
  }

  showErrors(errors) {
    const errorContainer = this.errorTarget;
    errorContainer.innerHTML = ""; // Clear previous errors
    if (errors.length > 0) {
      errors.forEach(error => {
        const errorElement = document.createElement("div");
        errorElement.className = "alert alert-danger";
        errorElement.innerText = error;
        errorContainer.appendChild(errorElement);
      });
      errorContainer.style.display = 'block'; // Show the error container if there are errors
    } else {
      errorContainer.style.display = 'none'; // Hide the error container if no errors
    }
  }

  toggleSubmitButton(enable) {
    this.submitButtonTarget.disabled = !enable;
  }
}
