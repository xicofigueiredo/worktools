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
    this.numberOfTimelines = this.data.get("numberOfTimelines");
    this.createdKnowldges = JSON.parse(innitialKnowledgesData);
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

  disableOptions(templateHTML, disableList) {
    const tempDiv = document.createElement("tr");
    tempDiv.innerHTML = templateHTML;

    const selects = tempDiv.querySelectorAll("select");
    selects.forEach((select) => {
      const options = Array.from(select.options);
      options.forEach((option) => {
        if (disableList.includes(option.innerHTML.trim())) {
          option.disabled = true;
        }
      });
    });

    return tempDiv.innerHTML;
  }

  disableOptionsInSubjectCells() {
    const subjectCells = document.querySelectorAll("[data-subject-cell]");

    subjectCells.forEach((cell) => {
      const select = cell.querySelector("select");

      if (select) {
        const options = Array.from(select.options);
        options.forEach((option) => {
          if (this.createdKnowldges.includes(option.innerHTML.trim())) {
            option.disabled = true;
          }
        });
      }
    });
  }

  updateKnowledgeAddBtn() {
    const knowledgeContainer = this.knowledgesContainerTarget;
    const rows = knowledgeContainer.querySelectorAll("tr");
    const rowCount = rows.length;

    const knowledgesAddBtn = document.querySelector("[data-knowledge-add-btn]");

    if (rowCount >= this.numberOfTimelines) {
      knowledgesAddBtn.disabled = true;
    } else {
      knowledgesAddBtn.disabled = false;
    }
  }

  enableOptionsInSubjectCells() {
    const subjectCells = document.querySelectorAll("[data-subject-cell]");

    subjectCells.forEach((cell) => {
      const select = cell.querySelector("select");

      if (select) {
        const options = Array.from(select.options);
        options.forEach((option) => {
          if (this.createdKnowldges.includes(option.innerHTML.trim())) {
            option.disabled = true;
          } else {
            option.removeAttribute("disabled");
          }
        });
      }
    });
  }

  convertExamDate(rawDate) {
    let examDateDisplay = "N/A";

    if (rawDate) {
      const date = new Date(rawDate);
      const month = date.getMonth() + 1;
      const year = date.getFullYear();

      if (month === 5 || month === 6) {
        examDateDisplay = `May/Jun ${year}`;
      } else if (month === 10 || month === 11) {
        examDateDisplay = `Oct/Nov ${year}`;
      } else {
        const options = { year: "numeric", month: "long" };
        examDateDisplay = date.toLocaleDateString("en-US", options);
      }
    }
    return examDateDisplay;
  }

  addRow(event) {
    event.preventDefault();
    const kind = event.target.dataset.kind; // 'skills' or 'communities' or 'knowledges'
    const templates = this.templateTargets.filter(
      (t) => t.dataset.kind === kind
    );

    if (templates.length > 0) {
      let content = templates[0].innerHTML.replace(
        /TEMPLATE_INDEX/g,
        new Date().getTime()
      );

      content = this.disableOptions(content, this.createdKnowldges);

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

    this.updateKnowledgeAddBtn();
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
      const subject = row.querySelector("[data-subject-cell]").innerText;

      this.createdKnowldges = this.createdKnowldges.filter(
        (subjectName) => subjectName !== subject
      );

      this.enableOptionsInSubjectCells();

      const knowledgeId = button.dataset.knowledgeId;
      this.deletedKnowledgeIds.push(knowledgeId);
    }
    if (row) {
      row.remove();
    }

    this.updateKnowledgeAddBtn();
  }

  createKnowledge(event) {
    const selectedValue = event.target.value;
    const [subjectName, examSeason, mock50, mock100, sprintGoal] =
      selectedValue.split("||");

    const convertedExamSeason = this.convertExamDate(examSeason);

    const formattedMock50 = this.formatDate(mock50);
    const formattedMock100 = this.formatDate(mock100);

    const fontSize = "style='font-size: 13px;'";

    const row = event.target.closest("tr");

    this.createdKnowldges.push(subjectName);

    this.disableOptionsInSubjectCells(true);

    this.updateKnowledgeAddBtn();

    row.querySelector('input[name$="[subject_name]"]').value = subjectName;
    row.querySelector('input[name$="[exam_season]"]').value =
      convertedExamSeason;
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
    sprintGoalCell.innerHTML = `<p ${fontSize}>${sprintGoal}</p>`;
    const examSeasonCell = row.querySelector("[data-exam-season-cell]");
    examSeasonCell.innerHTML = `<p ${fontSize}>${convertedExamSeason}</p>`;
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
