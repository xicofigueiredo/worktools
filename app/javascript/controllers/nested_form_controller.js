import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = [
    "skillsContainer",
    "communitiesContainer",
    "knowledgesContainer",
    "template",
    "form",
    "submit",
  ];

  connect() {
    const innitialKnowledgesData = this.data.get("knowledges");
    this.innitialKnowledges = JSON.parse(innitialKnowledgesData);
    console.log("Innitial Knowledges: ", this.innitialKnowledges);
    this.sprintGoalId = this.element.dataset.sprintGoalId;
    this.communityId = this.element.dataset.communityId;
    this.deletedCommunityIds = [];
    this.deletedSkillsIds = [];
    this.deletedKnowledgeIds = [];
  }

  formatDate(dateString) {
    const date = new Date(dateString);
    const day = String(date.getDate()).padStart(2, "0");
    const month = String(date.getMonth() + 1).padStart(2, "0"); // Months are 0-based
    const year = date.getFullYear();
    return `${day}/${month}/${year}`;
  }

  getCSRFToken() {
    return document
      .querySelector("[name='csrf-token']")
      .getAttribute("content");
  }

  addRow(event) {
    event.preventDefault();
    const kind = event.target.dataset.kind; // 'skills' or 'communities' or 'knowledges'
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
      } else if (kind === "knowledges") {
        this.knowledgesContainerTarget.insertAdjacentHTML("beforeend", content);
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
    } else if (kind === "skills") {
      const skillId = button.dataset.skillId;
      this.deletedSkillsIds.push(skillId);
    } else if (kind === "knowledges") {
      const knowledgeId = button.dataset.knowledgeId;
      this.deletedKnowledgeIds.push(knowledgeId);
    }
    if (row) {
      row.remove();
    }
  }

  createKnowledge(event) {
    const selectedValue = event.target.value;
    const [subjectName, examSeason, mock50, mock100] =
      selectedValue.split("||");

    const formattedMock50 = this.formatDate(mock50);
    const formattedMock100 = this.formatDate(mock100);

    const fontSize = "style='font-size: 13px;'";

    const row = event.target.closest("tr");

    row.querySelector('input[name$="[subject_name]"]').value = subjectName;
    row.querySelector('input[name$="[exam_season]"]').value = "N/A";
    row.querySelector('input[name$="[mock50]"]').value = formattedMock50;
    row.querySelector('input[name$="[mock100]"]').value = formattedMock100;

    row.querySelector('input[name$="[subject_name]"]').disabled = false;
    row.querySelector('input[name$="[exam_season]"]').disabled = false;
    row.querySelector('input[name$="[mock50]"]').disabled = false;
    row.querySelector('input[name$="[mock100]"]').disabled = false;
    row.querySelector('textarea[name$="[difficulties]"]').disabled = false;
    row.querySelector('textarea[name$="[plan]"]').disabled = false;

    const subjectCell = row.querySelector("[data-subject-cell]");
    subjectCell.innerHTML = `<p ${fontSize}>${subjectName}</p>`;

    const sprintGoalCell = row.querySelector("[data-sprint-goal-cell]");
    sprintGoalCell.innerHTML = `<p ${fontSize}>N/A</p>`;

    const examSeasonCell = row.querySelector("[data-exam-season-cell]");
    examSeasonCell.innerHTML = `<p ${fontSize}>N/A</p>`;

    const mock50Cell = row.querySelector("[data-mock50-cell]");
    mock50Cell.innerHTML = `<p ${fontSize}>${formattedMock50}</p>`;

    const mock100Cell = row.querySelector("[data-mock100-cell]");
    mock100Cell.innerHTML = `<p ${fontSize}>${formattedMock100}</p>`;
  }

  async submit(event) {
    event.preventDefault();
    const sprintGoalId = event.target.dataset.sprintGoalId;
    const sprintGoalDate = event.target.dataset.sprintGoalDate;
    const deletedCommunityIds = this.deletedCommunityIds;
    const deletedSkillIds = this.deletedSkillsIds;
    const deletedKnowledgeIds = this.deletedKnowledgeIds;
    const token = this.getCSRFToken();

    const form = this.formTarget;
    const formData = new FormData(form);

    this.submitTarget.innerHTML =
      '<button class="btn btn-primary" style="border-radius: 10px" disabled>Saving...</button>';

    if (
      deletedCommunityIds.length > 0 ||
      deletedSkillIds.length > 0 ||
      deletedKnowledgeIds.length > 0
    ) {
      try {
        const response = await fetch("/sprint_goals/bulk_destroy", {
          method: "POST",
          headers: {
            "X-CSRF-Token": token,
            "Content-Type": "application/json",
          },
          body: JSON.stringify({
            deleted_communities_ids: deletedCommunityIds,
            deleted_skills_ids: deletedSkillIds,
            deleted_knowledges_ids: deletedKnowledgeIds,
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
