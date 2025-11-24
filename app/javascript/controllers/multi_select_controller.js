import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["button", "dropdown", "checkbox", "hiddenContainer"];
  static values = {
    name: String,
    placeholder: String
  };

  connect() {
    this.updateButtonText();
    document.addEventListener("click", this.handleOutsideClick.bind(this));
  }

  disconnect() {
    document.removeEventListener("click", this.handleOutsideClick.bind(this));
  }

  toggle(event) {
    event.stopPropagation();
    this.dropdownTarget.classList.toggle("hidden");
  }

  handleOutsideClick(event) {
    if (!this.element.contains(event.target)) {
      this.dropdownTarget.classList.add("hidden");
    }
  }

  checkboxChanged() {
    this.updateButtonText();
    this.updateHiddenInputs();
    this.submitForm();
  }

  updateButtonText() {
    const selected = this.checkboxTargets.filter(cb => cb.checked);
    const buttonText = this.buttonTarget.querySelector(".button-text");

    if (selected.length === 0) {
      buttonText.textContent = this.placeholderValue || "All";
      buttonText.style.color = "#6b7280";
    } else if (selected.length === 1) {
      buttonText.textContent = selected[0].dataset.label;
      buttonText.style.color = "#111827";
    } else {
      buttonText.textContent = `${selected.length} selected`;
      buttonText.style.color = "#111827";
    }
  }

  updateHiddenInputs() {
    // Clear existing hidden inputs
    this.hiddenContainerTarget.innerHTML = "";

    // Add hidden input for each checked checkbox
    const selected = this.checkboxTargets.filter(cb => cb.checked);
    selected.forEach(checkbox => {
      const input = document.createElement("input");
      input.type = "hidden";
      input.name = `${this.nameValue}[]`;
      input.value = checkbox.value;
      this.hiddenContainerTarget.appendChild(input);
    });
  }

  clearAll(event) {
    event.stopPropagation();
    this.checkboxTargets.forEach(cb => cb.checked = false);
    this.updateButtonText();
    this.updateHiddenInputs();
    this.submitForm();
  }

  submitForm() {
    const form = this.element.closest("form");
    if (form) {
      if (typeof form.requestSubmit === "function") {
        form.requestSubmit();
      } else {
        form.submit();
      }
    }
  }
}
