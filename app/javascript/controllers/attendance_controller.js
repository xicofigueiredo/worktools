import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="attendance"
export default class extends Controller {
  static targets = ["startTime", "endTime", "comments", "absence"];

  connect() {
    this.attendanceId = this.element.dataset.attendanceId;
    this.debounceUpdateComments = this.debounce(this.actualUpdateComments, 600);
  }

  debounce(func, wait) {
    let timeout;
    return (...args) => {
      const later = () => {
        clearTimeout(timeout);
        func.apply(this, args);
      };
      clearTimeout(timeout);
      timeout = setTimeout(later, wait);
    };
  }

  getCSRFToken() {
    return document
      .querySelector("[name='csrf-token']")
      .getAttribute("content");
  }

  resetTimeFields() {
    if (this.hasStartTimeTarget) {
      this.startTimeTarget.value = "";
    }
    if (this.hasEndTimeTarget) {
      this.endTimeTarget.value = "";
    }
  }

  updateStartTime() {
    const startTime = this.startTimeTarget.value;
    const attendanceId = this.attendanceId;

    fetch(`/attendance/${attendanceId}/update_start_time`, {
      method: "PATCH",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": this.getCSRFToken(),
        Accept: "application/json",
      },
      body: JSON.stringify({ attendance: { start_time: startTime } }),
    })
      .then((response) => response.json())
      .then((data) => {
        if (data.status === "success") {
          console.log("Absence updated successfully");
          this.absenceTarget.value = "Present";
        } else {
          console.error("Failed to update absence");
        }
      })
      .catch((error) => {
        console.error("Error updating start time:", error);
      });
  }

  updateEndTime() {
    const endTime = this.endTimeTarget.value;
    const attendanceId = this.attendanceId;

    fetch(`/attendance/${attendanceId}/update_end_time`, {
      method: "PATCH",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": this.getCSRFToken(),
        Accept: "application/json",
      },
      body: JSON.stringify({ attendance: { end_time: endTime } }),
    })
      .then((response) => {
        if (response.ok) {
          console.log("End time updated successfully");
        } else {
          console.error("Failed to update end time");
        }
      })
      .catch((error) => {
        console.error("Error updating end time:", error);
      });
  }

  actualUpdateComments = () => {
    const comments = this.commentsTarget.value;
    const attendanceId = this.attendanceId;

    fetch(`/attendance/${attendanceId}/update_comments`, {
      method: "PATCH",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": this.getCSRFToken(),
        Accept: "application/json",
      },
      body: JSON.stringify({ attendance: { comments: comments } }),
    })
      .then((response) => {
        if (response.ok) {
          console.log("Comments updated successfully");
        } else {
          console.error("Failed to update comments");
        }
      })
      .catch((error) => {
        console.error("Error updating comments:", error);
      });
  };

  updateComments() {
    this.debounceUpdateComments();
  }

  updateAbsence() {
    const absence = this.absenceTarget.value;
    const attendanceId = this.attendanceId;

    fetch(`/attendance/${attendanceId}/update_absence`, {
      method: "PATCH",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": this.getCSRFToken(),
        Accept: "application/json",
      },
      body: JSON.stringify({ absence: absence }),
    })
      .then((response) => response.json())
      .then((data) => {
        if (data.status === "success") {
          console.log("Absence updated successfully");
          if (absence !== "Present") {
            console.log("Doing the ting");
            this.resetTimeFields();
          }
        } else {
          console.error("Failed to update absence");
        }
      })
      .catch((error) => {
        console.error("Error updating absence:", error);
      });
  }
}
