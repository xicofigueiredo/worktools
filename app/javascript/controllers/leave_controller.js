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
    // Exception targets
    "exceptionBtn", "exception", "exceptionReason", "exceptionRequested", "exceptionErrors",
    // Carry-over targets
    "daysFromPrevWrapper", "daysFromPrevCheckbox", "daysFromPrevInput", "daysFromPrevInfo", "daysFromPreviousHidden"
  ]

  static values = {
    advanceDays: Number,
    previewUrl: String
  }

  connect() {
    if (!this.hasAdvanceDaysValue) this.advanceDaysValue = 30 // Default to 30 if not set
    this._disableSubmit(true)
    this._debouncedPreview = debounce(() => this.fetchPreview(), 250)

    // UI Init
    if (this.hasExceptionTarget) this._hide(this.exceptionTarget)
    if (this.hasExceptionBtnTarget) this._hide(this.exceptionBtnTarget)
    if (this.hasDaysFromPrevWrapperTarget) this._hide(this.daysFromPrevWrapperTarget)

    // Listeners
    if (this.hasDaysFromPrevInputTarget) {
      this.daysFromPrevInputTarget.addEventListener('input', (e) => this.updateCarryInput(e))
    }
  }

  // 1. Triggered on Date/Type Change
  validate() {
    this.softErrors = []
    this.hardErrors = []
    this._clearMessage()

    const startVal = this.startTarget.value
    const endVal = this.endTarget.value
    const type = (this.typeTarget.value || "").toLowerCase()

    if (!startVal || !endVal) return

    // Client-side Advance Notice Check (Soft Error)
    if (type === 'holiday') {
      const start = this._parseDate(startVal)
      const daysUntil = this._daysBetween(this._todayLocal(), start)

      if (daysUntil < this.advanceDaysValue) {
        this.softErrors.push(`Requests made with fewer than ${this.advanceDaysValue} days’ notice require an exception.`)
      }
    }

    if (endVal < startVal) {
      this.hardErrors.push("End date must be after start date.")
      this.displayMessages() // Show hard error immediately
    } else {
      this._setMessage("Checking availability...", "info")
      this._debouncedPreview() // Go to server
    }
  }

  // 2. Server Validation
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

      // Store Data for UI
      this.totalDays = data.total_days
      this.daysByYear = data.days_by_year || {}
      this.carrySegments = data.jan_apr_segments || []

      // A) Handle Server "Soft" Errors (Blocked Periods)
      if (data.blocked) {
        if (data.blocked_messages && data.blocked_messages.length > 0) {
          this.softErrors.push(...data.blocked_messages)
        } else {
          this.softErrors.push("Selected period overlaps with a blocked date (Exception required).")
        }
      }

      // B) Handle Server "Hard" Errors (Self Overlap)
      if (data.overlapping_conflict) {
        this.hardErrors.push("You already have a leave request during this period.")
      }

      // C) Update UIs
      this.handleCarryUI()
      this.displayMessages()

    } catch (e) {
      console.error(e)
      this._setMessage("Connection error", "error")
    }
  }

  // 3. Main UI Orchestrator
  displayMessages() {
    const messages = []

    // 3a. Hard Errors (Red, Blocking)
    if (this.hardErrors.length > 0) {
      const html = this.hardErrors.map(e => `<div>${e}</div>`).join("")
      this._setMessage(html, "error")
      this._disableSubmit(true)
      this._hide(this.exceptionBtnTarget)
      return
    }

    // 3b. Soft Errors (Orange, Exception Button)
    const isExceptionMode = this._exceptionShown()
    const hasExceptionReason = this.hasExceptionReasonTarget && this.exceptionReasonTarget.value.trim().length > 0

    if (this.softErrors.length > 0) {
      this.softErrors.forEach(err => messages.push(`<div class="text-orange"><i class="fas fa-exclamation-triangle"></i> ${err}</div>`))

      // Show button to toggle exception
      this._show(this.exceptionBtnTarget)

      // Determine Submit state
      // Allowed if: User has opened exception box AND typed a reason
      const canSubmit = isExceptionMode && hasExceptionReason
      this._disableSubmit(!canSubmit)

      // Sync hidden field for backend
      if (this.hasExceptionErrorsTarget) {
        this.exceptionErrorsTarget.value = JSON.stringify({ user: this.softErrors, approver: this.softErrors })
      }
    } else {
      // No errors -> Normal Submit
      this._hide(this.exceptionBtnTarget)
      this._disableSubmit(false)
      if (this.hasExceptionErrorsTarget) this.exceptionErrorsTarget.value = ""
    }

    // 3c. Info Message (Breakdown of days + Carry Over status)
    const infoHtml = this.buildInfoHtml()
    if (infoHtml) messages.push(`<div class="mt-2 pt-2 border-top">${infoHtml}</div>`)

    this._setMessage(messages.join(""), this.softErrors.length > 0 ? "warning" : "success")
  }

  // 4. Carry Over Logic (Preserved from previous step)
  handleCarryUI() {
    if (!this.hasDaysFromPrevWrapperTarget) return

    if (this.carrySegments.length > 0) {
      const segment = this.carrySegments[0]
      this._show(this.daysFromPrevWrapperTarget)
      this.currentSegment = segment

      this.maxCarry = Math.min(segment.previous_year_carry, segment.eligible_carry_days)
      if (this.hasDaysFromPrevInputTarget) this.daysFromPrevInputTarget.max = this.maxCarry

      if (this.hasDaysFromPrevInfoTarget) {
        this.daysFromPrevInfoTarget.innerText = `Available from ${segment.previous_year}: ${segment.previous_year_carry}. (Max usable now: ${this.maxCarry})`
      }
    } else {
      this._hide(this.daysFromPrevWrapperTarget)
      this.currentSegment = null
      this.resetCarry()
    }
  }

  // 5. Exception Toggle Logic
  showException(e) {
    if (e) e.preventDefault()

    if (this._exceptionShown()) {
      this._hide(this.exceptionTarget)
      if (this.hasExceptionRequestedTarget) this.exceptionRequestedTarget.value = "false"
    } else {
      this._show(this.exceptionTarget)
      if (this.hasExceptionRequestedTarget) this.exceptionRequestedTarget.value = "true"
    }
    this.displayMessages() // Re-eval submit button
  }

  exceptionInput() {
    this.displayMessages() // Re-eval submit button as user types
  }

  // 6. Helper: Build the Info String (2025: X days, 2026: Y days)
  buildInfoHtml() {
    if (!this.totalDays && this.totalDays !== 0) return null

    const carryUsed = parseInt(this.daysFromPreviousHiddenTarget.value) || 0
    let breakdown = { ...this.daysByYear } // shallow copy

    // Adjust visual breakdown based on carry usage
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
        let txt = `<strong>${d} days</strong> in ${y}`
        if (this.currentSegment && carryUsed > 0 && parseInt(y) === this.currentSegment.previous_year) {
          txt += ` <small class="text-muted">(includes ${carryUsed} carried over)</small>`
        }
        parts.push(txt)
      }
    })

    return `<div class="text-dark">Total: <strong>${this.totalDays} working days</strong>.<br>${parts.join(" + ")}</div>`
  }

  // 7. Carry Over Toggles
  toggleUseCarry() {
    const checked = this.daysFromPrevCheckboxTarget.checked
    this.daysFromPrevInputTarget.disabled = !checked
    if(checked) {
      this.daysFromPrevInputTarget.value = this.maxCarry
      this.daysFromPreviousHiddenTarget.value = this.maxCarry
    } else {
      this.resetCarry()
    }
    this.displayMessages() // Update breakdown
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

  // Utilities
  _parseDate(v) { if(!v) return null; return new Date(v) }
  _todayLocal() { const d = new Date(); d.setHours(0,0,0,0); return d }
  _daysBetween(a, b) { return Math.ceil((b - a) / (1000 * 60 * 60 * 24)) }

  _show(el) { if(el) el.style.display = "block" }
  _hide(el) { if(el) el.style.display = "none" }
  _exceptionShown() { return this.hasExceptionTarget && this.exceptionTarget.style.display !== "none" }

  _setMessage(html, type) {
    this.messageTarget.innerHTML = html
    this.messageTarget.className = ""
    this.messageTarget.classList.add(type === "error" ? "text-danger" : (type === "warning" ? "text-dark" : "text-success"))

    // Add orange class for warning specifically if using Bootstrap text-warning isn't dark enough
    if (type === "warning") {
       // Ensure links/text inside are orange
       // The HTML generation handles class="text-orange" for specific lines
    }
  }

  _clearMessage() { this.messageTarget.innerHTML = ""; this.messageTarget.className = "" }
  _disableSubmit(flag) { if(this.hasSubmitTarget) this.submitTarget.disabled = flag }
}
