import { Application } from "@hotwired/stimulus"
import ToggleDoneController from "controllers/toggle_done_controller"
import TopicsController from "controllers/topics_controller"

const application = Application.start()

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

Stimulus.register("toggle-done", ToggleDoneController);
Stimulus.register("topics", TopicsController)
export { application }
