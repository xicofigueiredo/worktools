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
    "message", "exception", "exceptionReason",
    "exceptionBtn", "submit", "exceptionRequested", "exceptionErrors",
    "documentsWrapper", "form", "reason",
    // carry-over targets
    "daysFromPrevWrapper", "daysFromPrevCheckbox", "daysFromPrevInput", "daysFromPrevInfo", "daysFromPreviousHidden"
  ]

  static values = {
    advanceDays: Number,
    previewUrl: String,
    confirmationId: Number
  }

  connect() {
    if (!this.hasAdvanceDaysValue) this.advanceDaysValue = 20
    if (this.hasExceptionTarget) this._hide(this.exceptionTarget)
    this._disableSubmit(true)
    this._debouncedPreview = debounce(() => this.fetchPreview(), 250)
    this.softErrors = []
    this.hardErrors = []
    this.totalDays = 0
    this.daysByYear = {}
    this.janMarSegments = []
    this.selectedJanMarSegment = null
    this.remainingEntitlements = {}
    this.eligibleCarryDays = 0
    this.previousCarryAvailable = 0
    this.leaveYear = null

    if (this.hasStartTarget && this.hasEndTarget && this.hasTypeTarget) {
      this.validate()
    } else {
      this._toggleDocumentField()
    }

    if (this.hasExceptionErrorsTarget && this.element) {
      this.element.addEventListener('submit', (ev) => {
        try {
          if (!this.hasExceptionErrorsTarget) return
          const userMsgs = Array.isArray(this.softErrors) ? this.softErrors.slice() : []
          const approverMsgs = userMsgs.map((msg) => {
            if (/book holidays .* days in advance/i.test(msg) || /fewer than .* days’ notice/i.test(msg)) {
              return `Didn't ask for holidays with ${this.advanceDaysValue} days of advance`
            }
            return msg
          })
          const payload = { user: userMsgs, approver: approverMsgs }
          this.exceptionErrorsTarget.value = JSON.stringify(payload)
        } catch (e) {
          console.error("Error writing exception errors to hidden field:", e)
        }
      })
    }

    // init carry UI hidden
    if (this.hasDaysFromPrevWrapperTarget) {
      this._hide(this.daysFromPrevWrapperTarget)
      if (this.hasDaysFromPrevInputTarget) {
        this.daysFromPrevInputTarget.disabled = true
        this.daysFromPrevInputTarget.value = 0
      }
      if (this.hasDaysFromPreviousHiddenTarget) {
        this.daysFromPreviousHiddenTarget.value = 0
      }
      if (this.hasDaysFromPrevCheckboxTarget) {
        this.daysFromPrevCheckboxTarget.checked = false
      }
    }
  }

  validate() {
    this._clearMessage()

    const start = this._parseDate(this.startTarget?.value)
    const end   = this._parseDate(this.endTarget?.value)
    const type  = (this.typeTarget?.value || "holiday").toLowerCase()

    this.hardErrors = []
    this.softErrors = []

    // compute advance-warning and persist it on the controller so preview won't wipe it out
    this.advanceWarningMessage = null
    if (type === "holiday" && start) {
      const daysUntilStart = this._daysBetween(this._todayLocal(), start)
      if (daysUntilStart < this.advanceDaysValue) {
        this.advanceWarningMessage = `Vacation requests made with fewer than ${this.advanceDaysValue} days’ notice require a written justification. This justification will be reviewed and shared directly with your managers, who may approve or reject the request.`
        // also add it to softErrors for immediate rendering
        this.softErrors.push(this.advanceWarningMessage)
      }
    }

    if (start && end && end < start) {
      this.hardErrors.push("End date must be the same or after the start date")
    }

    if (start && end && this.hardErrors.length === 0) {
      // show current errors (including the advance warning we just added) immediately,
      // then fetch preview (debounced). This avoids temporarily removing the message.
      this.displayMessages()
      this._setMessage("Checking dates...", "info")
      this._disableSubmit(true)
      this._debouncedPreview()
    } else {
      this.displayMessages()
    }

    this._toggleDocumentField()
  }

  open(event) {
    event.preventDefault()
    const btn = event.currentTarget
    const url = btn.dataset.rejectUrl

    if (this.hasFormTarget && url) {
      this.formTarget.action = url
    }

    const modalEl = document.getElementById('rejectModal')
    if (modalEl) {
      this._rejectModal = new bootstrap.Modal(modalEl)
      this._rejectModal.show()
    }
  }

  showException(event) {
    if (event && event.preventDefault) event.preventDefault()

    // If exception block is currently visible => hide it and clear requested flag
    if (this._exceptionShown()) {
      this._hide(this.exceptionTarget)
      if (this.hasExceptionRequestedTarget) this.exceptionRequestedTarget.value = "false"
      // if user cleared reason, keep exception reason value as-is (server will validate)
    } else {
      // Show the exception UI and mark exception requested
      if (this.hasExceptionTarget) this._show(this.exceptionTarget)
      if (this.hasExceptionRequestedTarget) this.exceptionRequestedTarget.value = "true"

      // focus the reason textarea when available
      if (this.hasExceptionReasonTarget) {
        try { this.exceptionReasonTarget.focus() } catch (e) { /* ignore */ }
      }
    }

    // update messages / button visibility
    this.displayMessages()
  }

  exceptionInput() { this.displayMessages() }

  async fetchPreview() {
    const start = this.startTarget?.value
    const end   = this.endTarget?.value
    const type  = this.typeTarget?.value

    if (!start || !end) return

    const token = document.querySelector('meta[name="csrf-token"]')?.content
    try {
      const resp = await fetch(this.previewUrlValue, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-Token": token
        },
        body: JSON.stringify({ start_date: start, end_date: end, leave_type: type })
      })

      const json = await resp.json()
      if (!resp.ok) {
        const msg = (json && json.error) ? json.error : `Preview failed (${resp.status})`
        this.hardErrors.push(msg)
        this.displayMessages()
        return
      }

      // load values
      this.totalDays = Number(json.total_days || 0)
      this.daysByYear = json.days_by_year || {}
      this.janMarSegments = json.jan_mar_segments || []
      this.remainingEntitlements = json.entitlements_by_year || {}
      this.leaveYear = this._parseDate(start) ? this._parseDate(start).getFullYear() : null

      // select first applicable Jan-Mar segment that has carry available
      this.selectedJanMarSegment = null
      for (const seg of this.janMarSegments) {
        if (Number(seg.previous_year_carry || 0) > 0) { this.selectedJanMarSegment = seg; break }
      }

      this.previousCarryAvailable = this.selectedJanMarSegment ? Number(this.selectedJanMarSegment.previous_year_carry || 0) : 0
      this.eligibleCarryDays = this.selectedJanMarSegment ? Number(this.selectedJanMarSegment.eligible_carry_days || 0) : 0

      // prepare soft-errors from server payload (keeps same behaviour)
      this.softErrors = []

      // Re-add client-side advance-warning if present (keeps it persistent)
      if (this.advanceWarningMessage) {
        this.softErrors.push(this.advanceWarningMessage)
      }

      // Prefer server-provided advance warning if present (optional, but doesn't hurt)
      // If your backend returns json.advance_warning_message you can use it; otherwise this is safe.
      if (json.advance_warning_message) {
        // avoid duplicate if server message equals client message
        if (!this.softErrors.includes(json.advance_warning_message)) {
          this.softErrors.push(json.advance_warning_message)
        }
      } else {
        // fallback server-side check not present — we already added client-side message above
        // no-op
      }
      if (json.exceeds) {
        const entSum = Object.values(this.remainingEntitlements).reduce((a,b)=>a+Number(b||0),0)
        const sumPrevCarry = (this.janMarSegments || []).reduce((s,seg) => s + Number(seg.previous_year_carry || 0), 0)
        const available = entSum + sumPrevCarry
        const yearList = Object.keys(this.daysByYear).map(k => Number(k)).sort()
        const splitMsg = yearList.length > 1 ? ` (${yearList.map(y => `${this.daysByYear[y] || 0} in ${y}`).join(', ')})` : ''
        this.softErrors.push(`You only have ${available} days left to take ${type}s${splitMsg} (carry-over may be available for Jan–Mar segments).`)
      }
      if (Array.isArray(json.blocked_messages)) this.softErrors.push(...(json.blocked_messages || []))
      if (Array.isArray(json.overlapping_messages)) this.softErrors.push(...(json.overlapping_messages || []))
      this.hardErrors = []
      if (json.overlapping_self) this.hardErrors.push(json.overlapping_self_message)

      // carry UI handling: show when applicable; hide and CLEAR when not
      if (this.hasDaysFromPrevWrapperTarget) {
        if (this.selectedJanMarSegment && this.previousCarryAvailable > 0 && this.eligibleCarryDays > 0) {
          this._show(this.daysFromPrevWrapperTarget)
          if (this.hasDaysFromPrevInfoTarget) {
            this.daysFromPrevInfoTarget.innerText = `For Jan–Mar ${this.selectedJanMarSegment.year} you have ${this.previousCarryAvailable} carry days available from ${this.selectedJanMarSegment.previous_year}. Up to ${this.eligibleCarryDays} day(s) in this request fall into Jan–Mar ${this.selectedJanMarSegment.year}. Choose how many to use (0 to ${Math.min(this.previousCarryAvailable, this.eligibleCarryDays)}).`
          }
          if (this.hasDaysFromPrevInputTarget) {
            this.daysFromPrevInputTarget.min = 0
            this.daysFromPrevInputTarget.max = Math.min(this.previousCarryAvailable, this.eligibleCarryDays)
            this.daysFromPrevInputTarget.value = 0
            this.daysFromPrevInputTarget.disabled = true
          }
          if (this.hasDaysFromPreviousHiddenTarget) this.daysFromPreviousHiddenTarget.value = 0
          if (this.hasDaysFromPrevCheckboxTarget) this.daysFromPrevCheckboxTarget.checked = false

          // autosuggest only for Jan–Mar shortfall of selected segment
          const neededInJanMar = Number(this.selectedJanMarSegment.eligible_carry_days || 0)
          const entitlementForThatYear = Number(this.remainingEntitlements[this.selectedJanMarSegment.year] || 0)
          const janMarShortfall = Math.max(0, neededInJanMar - entitlementForThatYear)
          if (janMarShortfall > 0) {
            const suggested = Math.min(this.previousCarryAvailable, this.eligibleCarryDays, janMarShortfall)
            const chosen = Math.max(0, Math.min(Number(this.daysFromPrevInputTarget.max || 0), suggested))
            this.daysFromPrevCheckboxTarget.checked = true
            this.daysFromPrevInputTarget.disabled = false
            this.daysFromPrevInputTarget.value = chosen
            this.daysFromPreviousHiddenTarget.value = chosen
          }
        } else {
          // HIDE and CLEAR everything related to carry — ensure checkbox is unchecked too
          this._hide(this.daysFromPrevWrapperTarget)
          if (this.hasDaysFromPrevInputTarget) {
            this.daysFromPrevInputTarget.value = 0
            this.daysFromPrevInputTarget.disabled = true
          }
          if (this.hasDaysFromPreviousHiddenTarget) {
            this.daysFromPreviousHiddenTarget.value = 0
          }
          if (this.hasDaysFromPrevCheckboxTarget) {
            this.daysFromPrevCheckboxTarget.checked = false
          }
        }
      }

      this.displayMessages()
    } catch (err) {
      console.error("Preview fetch error:", err)
      this.hardErrors.push("Could not validate dates right now. Try again.")
      this.displayMessages()
    }
  }

  toggleUseCarry() {
    if (!this.hasDaysFromPrevCheckboxTarget || !this.hasDaysFromPrevInputTarget || !this.hasDaysFromPreviousHiddenTarget) return
    const checked = this.daysFromPrevCheckboxTarget.checked
    this.daysFromPrevInputTarget.disabled = !checked
    if (!checked) {
      this.daysFromPrevInputTarget.value = 0
      this.daysFromPreviousHiddenTarget.value = 0
    } else {
      const max = Number(this.daysFromPrevInputTarget.max || 0)
      this.daysFromPrevInputTarget.value = max
      this.daysFromPreviousHiddenTarget.value = max
    }
    this.displayMessages()
  }

  daysFromPrevInputTargetConnected(target) {
    target.addEventListener('input', (ev) => {
      let v = Number(ev.target.value || 0)
      const max = Number(ev.target.max || 0)
      const min = Number(ev.target.min || 0)
      v = Math.max(min, Math.min(max, v))
      ev.target.value = v
      this.daysFromPreviousHiddenTarget.value = v
      this.displayMessages()
    })
  }

  // === allocation & message builder (removed the extra clarifying parenthesis line) ===
  displayMessages() {
    const bypassed = this._exceptionShown() && this._hasExceptionReason()
    const effectiveSoftErrors = bypassed ? [] : this.softErrors

    const allMessages = []
    if (this.hardErrors.length > 0) {
      allMessages.push(...this.hardErrors.map(msg => `<span class="text-danger">${msg}</span>`))
    }
    if (this.softErrors.length > 0) {
      allMessages.push(...this.softErrors.map(msg => `<span class="text-orange">${msg}</span>`))
    }

    // Determine whether both start and end are present.
    // Prefer hidden ISO fields if your controller uses them, otherwise fall back to visible inputs.
    const startVal = this.hasStartHiddenTarget ? (this.startHiddenTarget.value || "").toString().trim()
                    : (this.hasStartTarget ? (this.startTarget.value || "").toString().trim() : "")
    const endVal   = this.hasEndHiddenTarget   ? (this.endHiddenTarget.value || "").toString().trim()
                    : (this.hasEndTarget ? (this.endTarget.value || "").toString().trim() : "")

    const datesFilled = startVal.length > 0 && endVal.length > 0

    // Build allocation map and apply selected carry only if both dates are present
    const infos = []
    if (datesFilled) {
      const allocation = {}
      Object.keys(this.daysByYear || {}).forEach(k => { allocation[Number(k)] = Number(this.daysByYear[k] || 0) })
      const carrySelected = this.hasDaysFromPreviousHiddenTarget ? Number(this.daysFromPreviousHiddenTarget.value || 0) : 0

      if (carrySelected > 0 && this.selectedJanMarSegment) {
        const segYear = Number(this.selectedJanMarSegment.year)
        const prevYear = Number(this.selectedJanMarSegment.previous_year)
        if (allocation[prevYear] == null) allocation[prevYear] = 0
        if (allocation[segYear] == null) allocation[segYear] = 0
        const carry = Math.min(carrySelected, allocation[segYear] + carrySelected)
        allocation[prevYear] = (allocation[prevYear] || 0) + carry
        allocation[segYear] = Math.max(0, (allocation[segYear] || 0) - carry)
      }

      const yearKeys = Object.keys(allocation).map(k => Number(k)).sort((a,b)=>a-b)

      if (yearKeys.length === 0 && this.totalDays > 0) {
        infos.push(`This will take ${this.totalDays} day(s) in the selected range.`)
      } else if (yearKeys.length === 1) {
        infos.push(`This will take ${allocation[yearKeys[0]]} day(s) of your entitlement for ${yearKeys[0]}.`)
      } else if (yearKeys.length > 1) {
        const parts = []
        for (const y of yearKeys) parts.push(`${allocation[y]} day(s) from ${y}`)
        infos.push(`This will take ${parts.join(' and ')}.`)
      }
    }

    if (infos.length > 0) {
      allMessages.push(...infos.map(msg => `<span class="text-dark">${msg}</span>`))
    }

    if (allMessages.length > 0) {
      this._setMessage(allMessages.join("<br>"), "mixed")
    } else {
      this._clearMessage()
    }

    if (this.softErrors.length > 0) {
      this._showExceptionBtn()
    } else {
      this._hideExceptionBtn()
    }

    const canSubmit = this.hardErrors.length === 0 && (bypassed || effectiveSoftErrors.length === 0)
    this._disableSubmit(!canSubmit)
  }

  // helpers...
  _parseDate(v) { if (!v) return null; const d = new Date(v + "T00:00:00"); return isNaN(d.getTime()) ? null : d }
  _todayLocal() { const n = new Date(); return new Date(n.getFullYear(), n.getMonth(), n.getDate()) }
  _daysBetween(a, b) { return Math.ceil((b - a) / (1000 * 60 * 60 * 24)) }

  _hide(el) { if (el) el.style.display = "none" }
  _show(el) { if (el) el.style.display = "block" }
  _setMessage(html, type="info") {
    if (!this.hasMessageTarget) return;
    this.messageTarget.innerHTML = html;
    this.messageTarget.className = "";
    if (type !== "mixed") {
      this.messageTarget.classList.add(type === "error" ? "text-danger" : "text-info")
    }
  }
  _clearMessage() { if (!this.hasMessageTarget) return; this.messageTarget.innerHTML = ""; this.messageTarget.className = "" }
  _disableSubmit(flag) { if (this.hasSubmitTarget) this.submitTarget.disabled = !!flag }
  _exceptionShown() { return this.hasExceptionTarget && this.exceptionTarget.style.display !== "none" }
  _hasExceptionReason() { return this.hasExceptionReasonTarget && this.exceptionReasonTarget.value.trim().length > 0 }
  _showExceptionBtn() { if (this.hasExceptionBtnTarget) this.exceptionBtnTarget.style.display = "inline-block" }
  _hideExceptionBtn() { if (this.hasExceptionBtnTarget) this.exceptionBtnTarget.style.display = "none" }
  _toggleDocumentField() {
    if (this.hasDocumentsWrapperTarget) {
      const type = (this.typeTarget?.value || "").toLowerCase()
      if (type === "sick" || type === "sick leave") {
        this.documentsWrapperTarget.style.display = "block"
      } else {
        this.documentsWrapperTarget.style.display = "none"
      }
    } else {
      const docWrapper = document.querySelector('[data-leave-target="documentsWrapper"]')
      if (!docWrapper) return
      const typeEl = this.typeTarget || document.querySelector('[data-leave-target="type"]')
      const type = (typeEl?.value || "").toLowerCase()
      docWrapper.style.display = (type === "sick" || type === "sick leave") ? "block" : 'none'
    }
  }
}
