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
    "start", "end", "type",
    "message", "submit",
    "exception", "exceptionReason", "exceptionBtn", "exceptionRequested", "exceptionErrors",
    "documentsWrapper", "documentsLabel", "documentsText",
    "daysFromPrevWrapper", "daysFromPrevCheckbox", "daysFromPrevInput", "daysFromPrevInfo", "daysFromPreviousHidden",
    "form", "reason"
  ]

  static values = {
    advanceDays: Number,
    previewUrl: String,
    userBirthdate: String // Defined to receive birthdate from view
  }

  connect() {
    if (this.hasStartTarget && this.hasEndTarget) {
      if (!this.hasAdvanceDaysValue) this.advanceDaysValue = 30

      this._disableSubmit(true)
      this._debouncedPreview = debounce(() => this.fetchPreview(), 250)

      if (this.hasExceptionTarget) this._hide(this.exceptionTarget)
      if (this.hasExceptionBtnTarget) this._hide(this.exceptionBtnTarget)
      if (this.hasDaysFromPrevWrapperTarget) this._hide(this.daysFromPrevWrapperTarget)

      this.softErrors = []
      this.hardErrors = []

      if (this.hasDaysFromPrevInputTarget) {
        this.daysFromPrevInputTarget.addEventListener('input', (e) => this.updateCarryInput(e))
      }

      this._toggleDocumentRequired()
    }
  }

  // --- Manager Dashboard: Open Reject Modal ---
  open(event) {
    event.preventDefault()
    const btn = event.currentTarget
    const url = btn.dataset.rejectUrl
    if (this.hasFormTarget && url) this.formTarget.action = url

    const modalEl = document.getElementById('rejectModal')
    if (modalEl && typeof bootstrap !== 'undefined') {
      const modal = new bootstrap.Modal(modalEl)
      modal.show()
    }
  }

  // --- Main Validation Logic ---
  validate() {
    this.softErrors = []
    this.hardErrors = []
    this._clearMessage()

    let startVal = this.startTarget.value
    let endVal = this.endTarget.value
    const type = (this.typeTarget.value || "").toLowerCase()

    // -----------------------------------------------------------
    // 1. BIRTHDAY LOGIC (Auto-Select & Lock)
    // -----------------------------------------------------------
    if (type === 'birthday') {
      const birthdateStr = this.userBirthdateValue

      // Lock inputs so user cannot change them manually
      this.startTarget.readOnly = true
      this.endTarget.readOnly = true
      this.startTarget.classList.add("bg-light")
      this.endTarget.classList.add("bg-light")

      if (!birthdateStr) {
        this.hardErrors.push("Birthdate is missing from your profile. Please contact HR.")
        this.displayMessages()
        return
      } else {
        // Calculate Next Birthday
        const today = new Date()
        today.setHours(0,0,0,0)

        const [y, m, d] = birthdateStr.split('-').map(Number)
        let nextBday = new Date(today.getFullYear(), m - 1, d)

        // If birthday has passed this year, use next year
        if (nextBday.getTime() < today.getTime()) {
          nextBday.setFullYear(today.getFullYear() + 1)
        }

        // Format to YYYY-MM-DD
        const year = nextBday.getFullYear()
        const month = String(nextBday.getMonth() + 1).padStart(2, '0')
        const day = String(nextBday.getDate()).padStart(2, '0')
        const formatted = `${year}-${month}-${day}`

        // Auto-fill inputs
        this.startTarget.value = formatted
        this.endTarget.value = formatted

        // Update local vars
        startVal = formatted
        endVal = formatted
      }
    } else {
      // Unlock inputs for other types
      this.startTarget.readOnly = false
      this.endTarget.readOnly = false
      this.startTarget.classList.remove("bg-light")
      this.endTarget.classList.remove("bg-light")
    }

    this._toggleDocumentField()

    // -----------------------------------------------------------
    // 2. CHECK EMPTY DATES
    // -----------------------------------------------------------
    if (!startVal || !endVal) return

    const start = this._parseDate(startVal)
    const end = this._parseDate(endVal)

    // -----------------------------------------------------------
    // 3. HARD VALIDATIONS (Client Side)
    // -----------------------------------------------------------
    if (end < start) {
      this.hardErrors.push("End date must be the same or after the start date")
    }

    const daysCount = Math.floor((end - start) / (1000 * 60 * 60 * 24)) + 1

    if (type.includes('paid') && daysCount < 30) {
      this.hardErrors.push(`Paid leave must be at least 30 consecutive days.`)
    }

    if (type.includes('marriage') && daysCount > 15) {
      this.hardErrors.push(`Marriage leave cannot exceed 15 consecutive days.`)
    }

    // -----------------------------------------------------------
    // 4. SOFT VALIDATIONS (Advance Notice)
    // -----------------------------------------------------------
    if (type === 'holiday') {
      const daysUntilStart = this._daysBetween(this._todayLocal(), start)
      if (daysUntilStart < this.advanceDaysValue) {
        this.softErrors.push(`Requests made with fewer than ${this.advanceDaysValue} days’ notice require a written justification.`)
      }
    }

    // -----------------------------------------------------------
    // 5. DECISION
    // -----------------------------------------------------------
    if (this.hardErrors.length > 0) {
      this.displayMessages()
    } else {
      this._setMessage("Checking availability...", "info")
      this._debouncedPreview()
    }
  }

  // --- Server Preview ---
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

      // High Duration Warning (Safety Check)
      if (this.totalDays > 40) {
        this.softErrors.push(`⚠️ <strong>High day count detected (${this.totalDays} days).</strong><br>Please check your <strong>End Date</strong> year.`)
      }

      // Server Flags
      if (data.blocked) {
        if (data.blocked_messages && data.blocked_messages.length > 0) {
          this.softErrors.push(...data.blocked_messages)
        } else {
          this.softErrors.push("Selected period overlaps with a blocked period.")
        }
      }

      if (data.overlapping_conflict) {
        if (type === 'birthday') {
          this.hardErrors.push("You already scheduled your next birthday leave. Please wait for it to pass to schedule the next one.")
        }
        else if (data.overlapping_conflict_messages && data.overlapping_conflict_messages.length > 0) {
          this.hardErrors.push(...data.overlapping_conflict_messages)
        } else {
          this.hardErrors.push("You already have a request for this period.")
        }
      }

      if (data.exceeds) {
        this.softErrors.push("You do not have enough days in your entitlement.")
      }

      this.handleCarryUI()
      this.displayMessages()

    } catch (e) {
      console.error(e)
      this._setMessage("Validation error. Please try again.", "error")
    }
  }

  // --- Display Messages ---
  displayMessages() {
    const messages = []

    if (this.hardErrors.length > 0) {
      this.hardErrors.forEach(msg => messages.push(`<div class="text-danger fw-bold"><i class="fas fa-times-circle"></i> ${msg}</div>`))
      this._setMessage(messages.join(""), "error")
      this._disableSubmit(true)
      this._hide(this.exceptionBtnTarget)
      return
    }

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

  // --- Carry Over ---
  handleCarryUI() {
    if (!this.hasDaysFromPrevWrapperTarget) return

    if (this.carrySegments.length > 0) {
      const segment = this.carrySegments[0]
      this._show(this.daysFromPrevWrapperTarget)
      this.currentSegment = segment
      this.maxCarry = Math.min(segment.previous_year_carry, segment.eligible_carry_days)
      if (this.hasDaysFromPrevInputTarget) this.daysFromPrevInputTarget.max = this.maxCarry
      if (this.hasDaysFromPrevInfoTarget) {
        this.daysFromPrevInfoTarget.innerHTML = `Available from ${segment.previous_year}: <strong>${segment.previous_year_carry}</strong>. (Max usable: ${this.maxCarry})`
      }
    } else {
      this._hide(this.daysFromPrevWrapperTarget)
      this.currentSegment = null
      this.resetCarry()
    }
  }

  buildInfoHtml() {
    if (this.totalDays === undefined || this.totalDays === null) return null

    const type = (this.typeTarget.value || "").toLowerCase()
    if (type === 'birthday') {
       const start = this.startTarget.value
       if (!start) return null
       const [y, m, d] = start.split('-')
       return `You are scheduling your birthday leave for: <strong>${d}/${m}/${y}</strong> and this will <strong>not</strong> take days from your ${y} entitlement.`
    }

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
          txt += ` <small class="text-muted">(includes ${carryUsed} carry-over)</small>`
        }
        parts.push(txt)
      }
    })
    return `Total: <strong>${this.totalDays} days</strong>.<br>Usage: ${parts.join(" + ")}`
  }

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

  exceptionInput() { this.displayMessages() }

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
