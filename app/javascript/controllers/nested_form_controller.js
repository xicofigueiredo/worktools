import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = [
    "skillsContainer",
    "communitiesContainer",
    "template",
    "form",
    "submit",
  ];

  connect() {
    this.sprintGoalId = this.element.dataset.sprintGoalId;
    this.communityId = this.element.dataset.communityId;
    this.deletedCommunityIds = [];
    this.deletedSkillsIds = [];
  }

  getCSRFToken() {
    return document
      .querySelector("[name='csrf-token']")
      .getAttribute("content");
  }

  addRow(event) {
    event.preventDefault();
    const kind = event.target.dataset.kind; // 'skills' or 'communities'
    const templates = this.templateTargets.filter(
      (t) => t.dataset.kind === kind
    );

    if (templates.length > 0) {
      const content = templates[0].innerHTML.replace(
        /TEMPLATE_INDEX/g,
        new Date().getTime()
      );
      if (kind === "skills") {
        this.skillsContainerTarget.insertAdjacentHTML("beforeend", content);
      } else if (kind === "communities") {
        this.communitiesContainerTarget.insertAdjacentHTML(
          "beforeend",
          content
        );
      }
    } else {
      console.error("Template for", kind, "not found.");
    }
  }

  removeRow(event) {
    event.preventDefault();
    const button = event.target.closest("button");
    const kind = button.dataset.kind;
    const row = button.closest("tr");

    if (kind === "communities") {
      const communityId = button.dataset.communityId;
      this.deletedCommunityIds.push(communityId);
    } else {
      const skillId = button.dataset.skillId;
      this.deletedSkillsIds.push(skillId);
    }
    if (row) {
      row.remove();
    }
  }

  async submit(event) {
    event.preventDefault();
    const sprintGoalId = event.target.dataset.sprintGoalId;
    const sprintGoalDate = event.target.dataset.sprintGoalDate;
    const deletedCommunityIds = this.deletedCommunityIds;
    const deletedSkillsIds = this.deletedSkillsIds;
    const token = this.getCSRFToken();

    const form = this.formTarget;
    const formData = new FormData(form);

    this.submitTarget.innerHTML =
      '<button class="btn btn-primary" style="border-radius: 10px" disabled>Saving...</button>';

    if (deletedCommunityIds.length > 0 || deletedSkillsIds > 0) {
      try {
        const response = await fetch("/sprint_goals/bulk_destroy", {
          method: "POST",
          headers: {
            "X-CSRF-Token": token,
            "Content-Type": "application/json",
          },
          body: JSON.stringify({
            deleted_communities_ids: deletedCommunityIds,
            deleted_skills_ids: deletedSkillsIds,
          }),
        });

        if (response.ok) {
          console.log(
            "Successfully deleted communities, now submitting the form."
          );
          this.deletedCommunityIds = [];
        } else {
          console.error("Failed to delete communities.");
          return;
        }
      } catch (error) {
        console.error("Error:", error);
        return;
      }
    }

    try {
      const response = await fetch(`/sprint_goals/${sprintGoalId}`, {
        method: "PATCH",
        headers: {
          "X-CSRF-Token": token,
          Accept: "application/json",
        },
        body: formData,
      });

      if (response.ok) {
        console.log("Form submitted successfully.");
        window.location.href = `/sprint_goals?date=${sprintGoalDate}`;
      } else {
        console.error("Failed to submit the form.");
      }
    } catch (error) {
      console.error("Error:", error);
    }
  }
}
