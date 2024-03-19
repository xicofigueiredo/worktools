import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["skillsContainer", "communitiesContainer", "template"]

  addRow(event) {
    event.preventDefault();
    const kind = event.target.dataset.kind; // 'skills' or 'communities'
    const templates = this.templateTargets.filter(t => t.dataset.kind === kind);

    if (templates.length > 0) {
      const content = templates[0].innerHTML.replace(/TEMPLATE_INDEX/g, new Date().getTime());
      if (kind === 'skills') {
        this.skillsContainerTarget.insertAdjacentHTML("beforeend", content);
      } else if (kind === 'communities') {
        this.communitiesContainerTarget.insertAdjacentHTML("beforeend", content);
      }
    } else {
      console.error("Template for", kind, "not found.");
    }
  }


}
