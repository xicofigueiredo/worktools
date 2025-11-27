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
    "programmeClear",
    "hubSelect",
    "hubClear"
  ];

  connect() {
    this.searchTimeout = null;
    this._updateClearForAll();
  }

  // Dynamic search with minimal debounce (200ms) for smooth typing
  searchInput() {
    this._updateClearForAll();

    clearTimeout(this.searchTimeout);
    this.searchTimeout = setTimeout(() => {
      this._requestSubmit();
    }, 200); // Very short debounce - feels instant but prevents excessive requests
  }

  // Instant submit for dropdowns (no debounce needed)
  submit() {
    this._updateClearForAll();
    this._requestSubmit();
  }

  clearSearch(event) {
    event.preventDefault();
    this.searchInputTarget.value = "";
    this._updateClearForAll();
    this._requestSubmit();
  }

  clearStatus(event) {
    event.preventDefault();
    this.statusSelectTarget.value = "";
    this._updateClearForAll();
    this._requestSubmit();
  }

  clearCurriculum(event) {
    event.preventDefault();
    this.curriculumSelectTarget.value = "";
    this._updateClearForAll();
    this._requestSubmit();
  }

  clearGrade(event) {
    event.preventDefault();
    this.gradeSelectTarget.value = "";
    this._updateClearForAll();
    this._requestSubmit();
  }

  clearProgramme(event) {
    event.preventDefault();
    if (this.hasProgrammeSelectTarget) {
      this.programmeSelectTarget.value = "";
    }
    this._updateClearForAll();
    this._requestSubmit();
  }

  clearHub(event) {
    event.preventDefault();
    if (this.hasHubSelectTarget) {
      this.hubSelectTarget.value = "";
    }
    this._updateClearForAll();
    this._requestSubmit();
  }

  // Private helpers ------------------------------------------------

  _requestSubmit() {
    if (typeof this.element.requestSubmit === "function") {
      this.element.requestSubmit();
    } else {
      this.element.submit();
    }
  }

  _updateClearForAll() {
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

    if (this.hasHubSelectTarget && this.hasHubClearTarget) {
      this._updateClear(this.hubSelectTarget, this.hubClearTarget);
    }
  }

  _updateClear(fieldEl, clearButtonEl) {
    let hasValue = false;

    if (fieldEl.tagName === "SELECT") {
      if (fieldEl.multiple) {
        // For multi-select, check if any options are selected
        hasValue = Array.from(fieldEl.selectedOptions).some(opt => opt.value && opt.value.trim() !== "");
      } else {
        hasValue = (fieldEl.value != null && String(fieldEl.value).trim() !== "");
      }
    } else {
      hasValue = String(fieldEl.value).trim().length > 0;
    }

    clearButtonEl.style.display = hasValue ? "inline" : "none";
  }
}
