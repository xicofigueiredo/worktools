// app/javascript/controllers/cancel_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["modalForm", "reason", "exceptionRequested"]
  static values = {
    leaveId: Number,      // optional, overridden from clicked button
    startDate: String,    // optional
    leaveStatus: String   // added: pending / approved / etc
  }

  // entry point when user clicks X
  start(event) {
    event.preventDefault()

    // prefer values from the clicked element (dataset) to controller-scoped values
    const el = event.currentTarget
    const leaveId = el.dataset.cancelLeaveIdValue || this.leaveIdValue
    const startDateStr = el.dataset.cancelStartDateValue || this.startDateValue
    const status = el.dataset.cancelLeaveStatusValue || this.leaveStatusValue

    if (!leaveId) {
      console.error("Cancel: leave id missing")
      return
    }

    const actionUrl = `/leaves/${leaveId}/cancel`

    // If leave is pending - immediate cancellation after confirmation (no modal)
    if (status && status.toLowerCase() === 'pending') {
      if (confirm("Cancel this pending request? This will cancel it immediately.")) {
        this._submitSimpleForm(actionUrl, { exception_requested: false })
      }
      return
    }

    // For non-pending (e.g. approved) proceed with existing approved logic
    if (!startDateStr) {
      // fallback - just confirm and submit (safe)
      if (confirm("Request cancellation?")) {
        this._submitSimpleForm(actionUrl, { exception_requested: false })
      }
      return
    }

    // compute days until start (local)
    const start = new Date(startDateStr + "T00:00:00")
    const now = new Date()
    const today = new Date(now.getFullYear(), now.getMonth(), now.getDate())
    const daysUntilStart = Math.ceil((start - today) / (1000 * 60 * 60 * 24))

    if (daysUntilStart >= 16) {
      // >=16 days: confirm and submit without justification (controller still creates CancellationConfirmation)
      if (confirm("Request cancellation? This will notify your managers for review. Your leave days will be reinstated only if a manager approves the cancellation.")) {
        this._submitSimpleForm(actionUrl, { exception_requested: false })
      }
    } else {
      // <16 days: open modal to require justification
      this._openModalForReason(actionUrl, daysUntilStart)
    }
  }

  _openModalForReason(actionUrl, daysUntilStart) {
    if (this.hasModalFormTarget) {
      this.modalFormTarget.action = actionUrl
      if (this.hasExceptionRequestedTarget) {
        this.exceptionRequestedTarget.value = "true"
      }
      const infoEl = document.getElementById("cancelModalInfo")
      if (infoEl) {
        infoEl.textContent = `Cancellations made within ${daysUntilStart} day(s) of the start date require a written justification. This will be reviewed and shared directly with your managers, who may or may not approve it.`
      }
      if (this.hasReasonTarget) this.reasonTarget.value = ""
      if (typeof bootstrap !== 'undefined' && bootstrap.Modal) {
        const modalEl = document.getElementById("cancelModal")
        const bsModal = bootstrap.Modal.getOrCreateInstance(modalEl)
        bsModal.show()
      } else {
        // fallback prompt
        const reason = prompt("Enter justification for cancellation (required):")
        if (reason && reason.trim().length > 0) {
          this._submitSimpleForm(actionUrl, { exception_requested: true, exception_reason: reason.trim() })
        } else {
          alert("Justification is required to request a cancellation within 16 days.")
        }
      }
    } else {
      console.error("Cancel modal form target not found")
    }
  }

  // helper to create a temporary form and submit it
  _submitSimpleForm(url, params = {}) {
    const form = document.createElement("form")
    form.method = "post"
    form.action = url

    // CSRF token
    const tokenEl = document.querySelector('meta[name="csrf-token"]')
    if (tokenEl) {
      const token = tokenEl.content
      const csrfInput = document.createElement("input")
      csrfInput.type = "hidden"
      csrfInput.name = "authenticity_token"
      csrfInput.value = token
      form.appendChild(csrfInput)
    }

    // append params
    Object.entries(params).forEach(([k, v]) => {
      const inp = document.createElement("input")
      inp.type = "hidden"
      inp.name = k
      inp.value = v
      form.appendChild(inp)
    })

    document.body.appendChild(form)
    form.submit()
  }
}
