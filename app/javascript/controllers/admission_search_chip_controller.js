import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  clearSearch(event) {
    event.preventDefault();
    this._clearFilter('search');
  }

  clearStatus(event) {
    event.preventDefault();
    this._clearFilter('status');
  }

  clearHub(event) {
    event.preventDefault();
    this._clearFilter('hub');
  }

  clearProgramme(event) {
    event.preventDefault();
    this._clearFilter('programme');
  }

  clearCurriculum(event) {
    event.preventDefault();
    this._clearFilter('curriculum');
  }

  clearGrade(event) {
    event.preventDefault();
    this._clearFilter('grade_year');
  }

  _clearFilter(filterName) {
    // Find the form outside the turbo frame
    const form = document.querySelector('form[data-controller="admission-search"]');
    if (!form) return;

    // Find the input/select by name
    const input = form.querySelector(`[name="${filterName}"]`);
    if (!input) return;

    // Clear the value
    input.value = "";

    // Update the clear buttons visibility immediately via the search controller
    const searchController = this.application.getControllerForElementAndIdentifier(form, "admission-search");
    if (searchController && typeof searchController._updateClearForAll === "function") {
      searchController._updateClearForAll();
    }

    // Trigger the form submission
    if (typeof form.requestSubmit === "function") {
      form.requestSubmit();
    } else {
      form.submit();
    }
  }
}
