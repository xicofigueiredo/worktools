import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["password", "icon"]

  toggle(event) {
    const icon = event.currentTarget;
    const password = icon.previousElementSibling.querySelector('input'); // Assuming the input is right before the icon

    if (password.type === "password") {
      password.type = "text";
      icon.classList.remove('fa-eye');
      icon.classList.add('fa-eye-slash');
    } else {
      password.type = "password";
      icon.classList.add('fa-eye');
      icon.classList.remove('fa-eye-slash');
    }
  }
}
