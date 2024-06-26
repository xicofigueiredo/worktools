import { Application } from "@hotwired/stimulus"
import ToggleDoneController from "controllers/toggle_done_controller"
import SelectsController from "controllers/selects_controller"
import NestedFormController from "controllers/nested_form_controller"
import PasswordToggleController from "controllers/password_toggle_controller"

const application = Application.start()

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

Stimulus.register("toggle-done", ToggleDoneController);
Stimulus.register("selects", SelectsController);
Stimulus.register("nested-form", NestedFormController);
Stimulus.register("password-toggle", PasswordToggleController);
export { application }
