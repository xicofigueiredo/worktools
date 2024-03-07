import { Application } from "@hotwired/stimulus"
import ToggleDoneController from "controllers/toggle_done_controller"

const application = Application.start()

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

Stimulus.register("toggle-done", ToggleDoneController);
export { application }
