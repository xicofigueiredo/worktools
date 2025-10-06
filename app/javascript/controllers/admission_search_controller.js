import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["searchInput", "statusSelect", "curriculumSelect", "gradeSelect"];

  connect() {
    this.timeout = null;
    // Debug help
    // console.log("admission_search controller connected");
  }

  submit() {
    clearTimeout(this.timeout);
    this.timeout = setTimeout(() => {
      this._requestSubmit();
    }, 300);
  }

  clearSearch(event) {
    event.preventDefault();
    this.searchInputTarget.value = "";
    this._submitNow();
  }

  clearStatus(event) {
    event.preventDefault();
    this.statusSelectTarget.value = "";
    this._submitNow();
  }

  clearCurriculum(event) {
    event.preventDefault();
    this.curriculumSelectTarget.value = "";
    this._submitNow();
  }

  clearGrade(event) {
    event.preventDefault();
    this.gradeSelectTarget.value = "";
    this._submitNow();
  }

  // helpers
  _requestSubmit() {
    if (typeof this.element.requestSubmit === "function") {
      this.element.requestSubmit();
    } else {
      this.element.submit();
    }
  }

  _submitNow() {
    this._requestSubmit();
  }
}
