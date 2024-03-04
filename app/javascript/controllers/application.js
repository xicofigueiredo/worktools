import { Application } from "@hotwired/stimulus"
import   DoneController from "controllers/done_controller"

const application = Application.start()

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

Stimulus.register("done", DoneController)
export { application }
