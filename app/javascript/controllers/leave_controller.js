import { Controller } from "@hotwired/stimulus"

function debounce(fn, wait = 300) {
  let t
  return (...args) => {
    clearTimeout(t)
    t = setTimeout(() => fn(...args), wait)
  }
}

export default class extends Controller {
  static targets = [
    // Form Validation Targets
    "start", "end", "type",
    "message", "submit",
    // Exception Targets
    "exception", "exceptionReason", "exceptionBtn", "exceptionRequested", "exceptionErrors",
    // Documents Targets
    "documentsWrapper", "documentsLabel", "documentsText",
    // Carry-Over Targets
    "daysFromPrevWrapper", "daysFromPrevCheckbox", "daysFromPrevInput", "daysFromPrevInfo", "daysFromPreviousHidden",
    // Rejection Modal Targets (Manager View)
    "form", "reason"
  ]

  static values = {
    advanceDays: Number,
    previewUrl: String
  }

  connect() {
    // 1. Setup for Leave Request Form (Only if inputs exist)
    if (this.hasStartTarget && this.hasEndTarget) {
      if (!this.hasAdvanceDaysValue) this.advanceDaysValue = 30

      this._disableSubmit(true)
      this._debouncedPreview = debounce(() => this.fetchPreview(), 250)

      // Initial UI Hiding
      if (this.hasExceptionTarget) this._hide(this.exceptionTarget)
      if (this.hasExceptionBtnTarget) this._hide(this.exceptionBtnTarget)
      if (this.hasDaysFromPrevWrapperTarget) this._hide(this.daysFromPrevWrapperTarget)

      this.softErrors = []
      this.hardErrors = []

      // Listeners
      if (this.hasDaysFromPrevInputTarget) {
        this.daysFromPrevInputTarget.addEventListener('input', (e) => this.updateCarryInput(e))
      }

      this._toggleDocumentRequired()
    }
  }

  // --- RESTORED: Rejection Modal Logic (Manager Dashboard) ---
  open(event) {
    event.preventDefault()
    const btn = event.currentTarget
    const url = btn.dataset.rejectUrl

    // Update the action of the modal form to point to the specific leave rejection URL
    if (this.hasFormTarget && url) {
      this.formTarget.action = url
    }

    // Initialize/Show the Bootstrap modal
    const modalEl = document.getElementById('rejectModal')
    if (modalEl) {
      // Ensure Bootstrap is available globally or imported
      const modal = new bootstrap.Modal(modalEl)
      modal.show()
    }
  }

  // --- 1. Client-Side Validation (User Form) ---
  validate() {
    this.softErrors = []
    this.hardErrors = []
    this._clearMessage()

    const startVal = this.startTarget.value
    const endVal = this.endTarget.value
    const type = (this.typeTarget.value || "").toLowerCase()

    this._toggleDocumentField()

    if (!startVal || !endVal) return

    const start = this._parseDate(startVal)
    const end = this._parseDate(endVal)

    // A. Date Logic Checks (Hard Errors)
    if (end < start) {
      this.hardErrors.push("End date must be the same or after the start date")
    }

    // Rough day count for client checks
    const daysCount = Math.floor((end - start) / (1000 * 60 * 60 * 24)) + 1

    // B. Paid Leave Rule (Hard Error)
    if (type.includes('paid') && daysCount < 30) {
      this.hardErrors.push(`Paid leave must be at least 30 consecutive days.`)
    }

    // C. Marriage Leave Rule (Hard Error)
    if (type.includes('marriage') && daysCount > 15) {
      this.hardErrors.push(`Marriage leave cannot exceed 15 consecutive days (selected: ${daysCount}).`)
    }

    // D. Advance Notice Rule (Soft Error)
    if (type === 'holiday') {
      const daysUntilStart = this._daysBetween(this._todayLocal(), start)
      if (daysUntilStart < this.advanceDaysValue) {
        this.softErrors.push(`Requests made with fewer than ${this.advanceDaysValue} days’ notice require a written justification.`)
      }
    }

    if (this.hardErrors.length > 0) {
      this.displayMessages()
    } else {
      this._setMessage("Checking availability...", "info")
      this._debouncedPreview()
    }
  }

  // --- 2. Server Validation ---
  async fetchPreview() {
    const start = this.startTarget.value
    const end = this.endTarget.value
    const type = this.typeTarget.value

    try {
      const resp = await fetch(this.previewUrlValue, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content
        },
        body: JSON.stringify({ start_date: start, end_date: end, leave_type: type })
      })
      const data = await resp.json()

      if (data.error) {
        this.hardErrors.push(data.error)
        this.displayMessages()
        return
      }

      this.totalDays = data.total_days
      this.daysByYear = data.days_by_year || {}
      this.carrySegments = data.jan_apr_segments || []

      // E. Blocked Periods (Soft Error)
      if (data.blocked) {
        if (data.blocked_messages && data.blocked_messages.length > 0) {
          this.softErrors.push(...data.blocked_messages)
        } else {
          this.softErrors.push("Selected period overlaps with a blocked period.")
        }
      }

      // F. Overlapping Conflict (Hard Error)
      if (data.overlapping_conflict) {
        if (data.overlapping_conflict_messages && data.overlapping_conflict_messages.length > 0) {
          this.hardErrors.push(...data.overlapping_conflict_messages)
        } else {
          this.hardErrors.push("You already have a request for this period.")
        }
      }

      // G. Entitlement Exceeded (Soft Error)
      if (data.exceeds) {
        this.softErrors.push("You do not have enough days in your entitlement for this request.")
      }

      this.handleCarryUI()
      this.displayMessages()

    } catch (e) {
      console.error(e)
      this._setMessage("Validation error. Please try again.", "error")
    }
  }

  // --- 3. UI Display Logic ---
  displayMessages() {
    const messages = []

    // 1. Hard Errors (Blocking)
    if (this.hardErrors.length > 0) {
      this.hardErrors.forEach(msg => messages.push(`<div class="text-danger fw-bold"><i class="fas fa-times-circle"></i> ${msg}</div>`))
      this._setMessage(messages.join(""), "error")
      this._disableSubmit(true)
      this._hide(this.exceptionBtnTarget)
      return
    }

    // 2. Soft Errors (Exception Required)
    if (this.softErrors.length > 0) {
      this.softErrors.forEach(msg => messages.push(`<div class="text-orange"><i class="fas fa-exclamation-triangle"></i> ${msg}</div>`))

      this._show(this.exceptionBtnTarget)

      const exceptionOpen = this._exceptionShown()
      const reasonProvided = this.hasExceptionReasonTarget && this.exceptionReasonTarget.value.trim().length > 0

      if (exceptionOpen && reasonProvided) {
        this._disableSubmit(false)
      } else {
        this._disableSubmit(true)
      }

      if (this.hasExceptionErrorsTarget) {
        this.exceptionErrorsTarget.value = JSON.stringify({ user: this.softErrors, approver: this.softErrors })
      }
    } else {
      this._hide(this.exceptionBtnTarget)
      this._disableSubmit(false)
      if (this.hasExceptionErrorsTarget) this.exceptionErrorsTarget.value = ""
    }

    // 3. Info Message
    const infoHtml = this.buildInfoHtml()
    if (infoHtml) {
      messages.push(`<div class="mt-2 pt-2 border-top text-dark">${infoHtml}</div>`)
    }

    if (this.softErrors.length > 0) {
      this._setMessage(messages.join(""), "mixed")
    } else {
      this._setMessage(messages.join(""), "success")
    }
  }

  // --- 4. Carry Over Logic ---
  handleCarryUI() {
    if (!this.hasDaysFromPrevWrapperTarget) return

    if (this.carrySegments.length > 0) {
      const segment = this.carrySegments[0]
      this._show(this.daysFromPrevWrapperTarget)
      this.currentSegment = segment

      this.maxCarry = Math.min(segment.previous_year_carry, segment.eligible_carry_days)

      if (this.hasDaysFromPrevInputTarget) this.daysFromPrevInputTarget.max = this.maxCarry
      if (this.hasDaysFromPrevInfoTarget) {
        this.daysFromPrevInfoTarget.innerHTML = `Available from ${segment.previous_year}: <strong>${segment.previous_year_carry}</strong>. (Max usable for this date range: ${this.maxCarry})`
      }
    } else {
      this._hide(this.daysFromPrevWrapperTarget)
      this.currentSegment = null
      this.resetCarry()
    }
  }

  buildInfoHtml() {
    if (this.totalDays === undefined || this.totalDays === null) return null

    const carryUsed = parseInt(this.daysFromPreviousHiddenTarget.value) || 0
    let breakdown = { ...this.daysByYear }

    if (this.currentSegment && carryUsed > 0) {
      const tYear = this.currentSegment.year
      const sYear = this.currentSegment.previous_year

      if (breakdown[tYear]) breakdown[tYear] -= carryUsed
      if (!breakdown[sYear]) breakdown[sYear] = 0
      breakdown[sYear] += carryUsed
    }

    let parts = []
    Object.keys(breakdown).sort().forEach(y => {
      const d = breakdown[y]
      if (d > 0) {
        let txt = `<strong>${d} days</strong> from ${y}`
        if (this.currentSegment && carryUsed > 0 && parseInt(y) === this.currentSegment.previous_year) {
          txt += ` <small class="text-muted">(includes ${carryUsed} carry-over used)</small>`
        }
        parts.push(txt)
      }
    })

    return `Total: <strong>${this.totalDays} days</strong>.<br>Usage: ${parts.join(" + ")}`
  }

  // --- 5. Toggles & Inputs ---
  toggleUseCarry() {
    const checked = this.daysFromPrevCheckboxTarget.checked
    this.daysFromPrevInputTarget.disabled = !checked
    if(checked) {
      this.daysFromPrevInputTarget.value = this.maxCarry
      this.daysFromPreviousHiddenTarget.value = this.maxCarry
    } else {
      this.resetCarry()
    }
    this.displayMessages()
  }

  updateCarryInput(e) {
    let val = parseInt(e.target.value) || 0
    if(val > this.maxCarry) val = this.maxCarry
    if(val < 0) val = 0
    e.target.value = val
    this.daysFromPreviousHiddenTarget.value = val
    this.displayMessages()
  }

  resetCarry() {
    if(this.hasDaysFromPrevInputTarget) {
      this.daysFromPrevInputTarget.value = 0
      this.daysFromPrevInputTarget.disabled = true
    }
    if(this.hasDaysFromPrevCheckboxTarget) this.daysFromPrevCheckboxTarget.checked = false
    if(this.hasDaysFromPreviousHiddenTarget) this.daysFromPreviousHiddenTarget.value = 0
  }

  showException(e) {
    if (e) e.preventDefault()
    if (this._exceptionShown()) {
      this._hide(this.exceptionTarget)
      if (this.hasExceptionRequestedTarget) this.exceptionRequestedTarget.value = "false"
    } else {
      this._show(this.exceptionTarget)
      if (this.hasExceptionRequestedTarget) this.exceptionRequestedTarget.value = "true"
      if (this.hasExceptionReasonTarget) this.exceptionReasonTarget.focus()
    }
    this.displayMessages()
  }

  exceptionInput() {
    this.displayMessages()
  }

  _toggleDocumentField() {
    if (this.hasDocumentsWrapperTarget) {
      const type = (this.typeTarget.value || "").toLowerCase()
      const showDocs = type.includes('sick') || type.includes('marriage') || type.includes('parental')

      if (showDocs) {
        this._show(this.documentsWrapperTarget)
        if (this.hasDocumentsLabelTarget) {
          if (type.includes('sick')) this.documentsLabelTarget.textContent = 'Medical documents'
          else if (type.includes('marriage')) this.documentsLabelTarget.textContent = 'Marriage documents'
          else if (type.includes('parental')) this.documentsLabelTarget.textContent = 'Parental documents'
        }
        this._toggleDocumentRequired()
      } else {
        this._hide(this.documentsWrapperTarget)
        this._toggleDocumentRequired()
      }
    }
  }

  _toggleDocumentRequired() {
    const fileInput = this.element.querySelector('input[type="file"][name*="documents"]')
    const type = (this.typeTarget?.value || "").toLowerCase()
    const required = type.includes('sick') || type.includes('marriage') || type.includes('parental')
    if (fileInput) {
      if (required) fileInput.setAttribute('required', 'required')
      else fileInput.removeAttribute('required')
    }
  }

  _parseDate(v) { if(!v) return null; return new Date(v) }
  _todayLocal() { const d = new Date(); d.setHours(0,0,0,0); return d }
  _daysBetween(a, b) { return Math.ceil((b - a) / (1000 * 60 * 60 * 24)) }

  _show(el) { if(el) el.style.display = "block" }
  _hide(el) { if(el) el.style.display = "none" }

  _setMessage(html, type) {
    this.messageTarget.innerHTML = html
    this.messageTarget.className = ""
    if (type !== "mixed") {
      this.messageTarget.classList.add(type === "error" ? "text-danger" : "text-success")
    }
  }
  _clearMessage() { this.messageTarget.innerHTML = ""; this.messageTarget.className = "" }
  _disableSubmit(flag) { if(this.hasSubmitTarget) this.submitTarget.disabled = flag }
  _exceptionShown() { return this.hasExceptionTarget && this.exceptionTarget.style.display !== "none" }
}
