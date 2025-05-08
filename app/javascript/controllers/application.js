import { Application } from "@hotwired/stimulus"
import ToggleDoneController from "controllers/toggle_done_controller"
import SelectsController from "controllers/selects_controller"
import NestedFormController from "controllers/nested_form_controller"
import PasswordToggleController from "controllers/password_toggle_controller"
import AutoSaveController from "./auto_save_controller";
import SaveKnowledgeController from "./save_knowledge_controller";
import SaveActivityController from "./save_activity_controller";
import HubAssociationsController from "./hub_associations_controller";
const application = Application.start()

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

Stimulus.register("toggle-done", ToggleDoneController);
Stimulus.register("selects", SelectsController);
Stimulus.register("nested-form", NestedFormController);
Stimulus.register("password-toggle", PasswordToggleController);
Stimulus.register("auto-save", AutoSaveController);
Stimulus.register("save-knowledge", SaveKnowledgeController);
Stimulus.register("save-activity", SaveActivityController);
Stimulus.register("hub-associations", HubAssociationsController);

export { application }
