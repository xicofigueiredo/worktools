import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = [
    "searchInput",
    "statusSelect",
    "curriculumSelect",
    "gradeSelect",
    "searchClear",
    "statusClear",
    "curriculumClear",
    "gradeClear",
    "programmeSelect",
    "programmeClear"
  ];

  connect() {
    this.timeout = null;
    // initial toggle based on current form values
    this._updateClearForAll();

    // optional: observe input changes that might not fire events (rare)
    // not necessary in most cases; left out for simplicity
    // debug
    // console.log("admission_search controller connected");
  }

  submit() {
    // update clear buttons immediately so UI feels responsive
    this._updateClearForAll();

    clearTimeout(this.timeout);
    this.timeout = setTimeout(() => {
      this._requestSubmit();
    }, 500);
  }

  clearSearch(event) {
    event.preventDefault();
    this.searchInputTarget.value = "";
    this._updateClearForAll();
    this._submitNow();
  }

  clearStatus(event) {
    event.preventDefault();
    this.statusSelectTarget.value = "";
    this._updateClearForAll();
    this._submitNow();
  }

  clearCurriculum(event) {
    event.preventDefault();
    this.curriculumSelectTarget.value = "";
    this._updateClearForAll();
    this._submitNow();
  }

  clearGrade(event) {
    event.preventDefault();
    this.gradeSelectTarget.value = "";
    this._updateClearForAll();
    this._submitNow();
  }

  clearProgramme(event) {
    event.preventDefault();
    if (this.hasProgrammeSelectTarget) {
      this.programmeSelectTarget.value = "";
    }
    this._updateClearForAll();
    this._submitNow();
  }

  // helpers ------------------------------------------------

  _requestSubmit() {
    if (typeof this.element.requestSubmit === "function") {
      this.element.requestSubmit();
    } else {
      this.element.submit();
    }
  }

  _submitNow() {
    // immediate submit used after clearing a filter
    this._requestSubmit();
  }

  _updateClearForAll() {
    // safely update each clear button if target exists
    if (this.hasSearchInputTarget && this.hasSearchClearTarget) {
      this._updateClear(this.searchInputTarget, this.searchClearTarget);
    }

    if (this.hasStatusSelectTarget && this.hasStatusClearTarget) {
      this._updateClear(this.statusSelectTarget, this.statusClearTarget);
    }

    if (this.hasCurriculumSelectTarget && this.hasCurriculumClearTarget) {
      this._updateClear(this.curriculumSelectTarget, this.curriculumClearTarget);
    }

    if (this.hasGradeSelectTarget && this.hasGradeClearTarget) {
      this._updateClear(this.gradeSelectTarget, this.gradeClearTarget);
    }

    if (this.hasProgrammeSelectTarget && this.hasProgrammeClearTarget) {
      this._updateClear(this.programmeSelectTarget, this.programmeClearTarget);
    }
  }

  _updateClear(fieldEl, clearButtonEl) {
    // Show clear button only when field has a non-empty value
    let hasValue = false;

    if (fieldEl.tagName === "SELECT") {
      hasValue = (fieldEl.value != null && String(fieldEl.value).trim() !== "");
    } else if (fieldEl.tagName === "INPUT" || fieldEl.tagName === "TEXTAREA") {
      hasValue = String(fieldEl.value).trim().length > 0;
    } else {
      hasValue = String(fieldEl.value).trim().length > 0;
    }

    clearButtonEl.style.display = hasValue ? "inline" : "none";
  }
}
