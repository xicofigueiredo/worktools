import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = [
    "startDate",
    "endDate",
    "error",
    "submitButton",
    "subject",
    "examDate",
  ];

  connect() {
    this.holidays = this.getHolidays();
    console.log("Holidays loaded:", this.holidays); // Debugging line
    this.startDateTarget.addEventListener("change", this.validateDates.bind(this));
    this.endDateTarget.addEventListener("change", this.validateDates.bind(this));

    // Load all exam dates from a data attribute in the view
    this.allExamDates = JSON.parse(this.element.dataset.timelineFormExamDates);

    // Add listener for subject selection change
    this.subjectTarget.addEventListener("change", this.filterExamDates.bind(this));

    this.validateDates(); // Initial validation
  }

  getHolidays() {
    const holidaysDataElement = document.getElementById("holidays-data");
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

  filterExamDates() {
    const selectedSubjectId = parseInt(this.subjectTarget.value, 10);

    // Filter the exam dates based on the selected subject
    const filteredExamDates = this.allExamDates.filter(
      (examDate) => examDate.subject_id === selectedSubjectId
    );

    // Clear and repopulate the exam date dropdown
    this.examDateTarget.innerHTML = "<option value=''>Select an exam date</option>";
    filteredExamDates.forEach((examDate) => {
      const option = document.createElement("option");
      option.value = examDate.id;
      option.textContent = examDate.name; // Adjust if your JSON has a different field for name
      if (parseInt(this.examDateTarget.dataset.selectedId) === examDate.id) {
        option.selected = true; // Pre-select if it matches the timeline's exam_date_id
      }
      this.examDateTarget.appendChild(option);
    });
  }

  validateDates() {
    const startDate = new Date(this.startDateTarget.value);
    const endDate = new Date(this.endDateTarget.value);
    const selectedExamId = parseInt(this.examDateTarget.value, 10);
    const errorMessages = [];

    const examDate = this.allExamDates.find((exam) => exam.id === selectedExamId);

    if (examDate) {
      const month = examDate.month;
      const year = examDate.year;

      const expectedEndDate = this.getExpectedEndDate(month, year);
      if (endDate.getTime() > expectedEndDate.getTime()) {
        errorMessages.push(
          `For the selected exam session, the end date must be on or before ${expectedEndDate.toLocaleDateString()}.`
        );
      }
    }


    if (startDate >= endDate) {
      errorMessages.push("End date must be after the start date.");
    }

    let isWithinHolidayPeriod = false;
    this.holidays.forEach((holiday) => {
      const holidayStart = new Date(holiday.start);
      const holidayEnd = new Date(holiday.end);

      if (this.isWithinHoliday(startDate, endDate, holidayStart, holidayEnd)) {
        errorMessages.push(
          "Timeline dates cannot be completely within a holiday period."
        );
        isWithinHolidayPeriod = true;
      }
    });

    this.showErrors(errorMessages);
    this.toggleSubmitButton(errorMessages.length === 0 && !isWithinHolidayPeriod);
  }

  getExpectedEndDate(examMonth, year) {
    // Define expected end dates for each exam session
    const dates = {
      5: new Date(year, 1, 28), // May/June -> February 28
      6: new Date(year, 1, 28), // May/June -> February 28
      10: new Date(year, 6, 28), // October/November -> July 28
      11: new Date(year, 6, 28), // October/November -> July 28
      1: new Date(year, 9, 28), // January -> October 28
    };

    return dates[examMonth] || new Date(); // Default to current date if no match
  }

  isWithinHoliday(startDate, endDate, holidayStart, holidayEnd) {
    return startDate >= holidayStart && endDate <= holidayEnd;
  }

  showErrors(errors) {
    const errorContainer = this.errorTarget;
    errorContainer.innerHTML = ""; // Clear previous errors
    if (errors.length > 0) {
      errors.forEach((error) => {
        const errorElement = document.createElement("div");
        errorElement.className = "alert alert-danger";
        errorElement.innerText = error;
        errorContainer.appendChild(errorElement);
      });
      errorContainer.style.display = "block"; // Show the error container if there are errors
    } else {
      errorContainer.style.display = "none"; // Hide the error container if no errors
    }
  }

  toggleSubmitButton(enable) {
    this.submitButtonTarget.disabled = !enable;
  }
}
