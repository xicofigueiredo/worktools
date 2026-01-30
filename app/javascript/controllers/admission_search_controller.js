import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = [
    // Search & Filter
    "form", "filterSummary",
    "searchInput", "searchClear",
    "statusSelect", "statusClear",
    "curriculumSelect", "curriculumClear",
    "gradeSelect", "gradeClear",
    "programmeSelect", "programmeClear",
    "hubSelect", "hubClear",
    "ageMin", "ageMax", "ageDisplay",

    // Bulk Email
    "bulkEmailModal", "bulkEmailForm", "emailResultContainer", "bulkEmailSelectAll",
    "emailListTextarea", "emailCount", "generateEmailsBtn", "copyBtn",

    // Export Modal
    "exportModal", "exportModalContent",

    // HubSpot
    "fetchHubspotBtn", "hubspotMessageModal", "hubspotMessageText"
  ];

  connect() {
    this.searchTimeout = null;
    this.hubspotMessageTimeout = null;
    this._updateClearForAll();

    this.clickOutsideHandler = this.handleClickOutside.bind(this);
    document.addEventListener('click', this.clickOutsideHandler);

    this.keydownHandler = this.handleKeydown.bind(this);
    document.addEventListener('keydown', this.keydownHandler);
  }

  disconnect() {
    document.removeEventListener('click', this.clickOutsideHandler);
    document.removeEventListener('keydown', this.keydownHandler);
  }

  // ==============================================================================
  // 1. MAIN SEARCH & FILTER LOGIC
  // ==============================================================================

  searchInput() {
    this._updateClearForAll();
    clearTimeout(this.searchTimeout);
    this.searchTimeout = setTimeout(() => {
      this._requestSubmit();
    }, 200);
  }

  submit() {
    this._updateClearForAll();
    this._requestSubmit();
  }

  updateAgeDisplay() {
    const min = parseInt(this.ageMinTarget.value);
    const max = parseInt(this.ageMaxTarget.value);
    if (min > max) {
      this.ageMinTarget.value = max;
      this.ageMaxTarget.value = min;
    }
    this.ageDisplayTarget.innerText = `${this.ageMinTarget.value} - ${this.ageMaxTarget.value}`;
    this.searchInput();
  }

  clearSearch(event) { event.preventDefault(); this.searchInputTarget.value = ""; this._updateClearForAll(); this._requestSubmit(); }
  clearStatus(event) { this._clearFilter(event, this.statusSelectTarget); }
  clearCurriculum(event) { this._clearFilter(event, this.curriculumSelectTarget); }
  clearGrade(event) { this._clearFilter(event, this.gradeSelectTarget); }
  clearProgramme(event) { if (this.hasProgrammeSelectTarget) this._clearFilter(event, this.programmeSelectTarget); }
  clearHub(event) { if (this.hasHubSelectTarget) this._clearFilter(event, this.hubSelectTarget); }

  _clearFilter(event, target) {
    event.preventDefault();
    target.value = "";
    this._updateClearForAll();
    this._requestSubmit();
  }

  // ==============================================================================
  // 2. DROPDOWN UI ENHANCEMENTS
  // ==============================================================================

  filterDropdown(event) {
    const input = event.target;
    const filter = input.value.toUpperCase();
    const container = input.closest('[data-multi-select-target="dropdown"]');

    const items = container.querySelectorAll('.dropdown-item');
    items.forEach(item => {
      const text = item.textContent || item.innerText;
      item.style.display = text.toUpperCase().indexOf(filter) > -1 ? "" : "none";
    });

    const groups = container.querySelectorAll('.dropdown-group');
    groups.forEach(group => {
      const visibleItems = group.querySelectorAll('.dropdown-item:not([style*="display: none"])');
      group.style.display = visibleItems.length === 0 ? "none" : "";
    });
  }

  toggleCountryGroup(event) {
    const isChecked = event.target.checked;
    const groupDiv = event.target.closest('.dropdown-group');

    const checkboxes = groupDiv.querySelectorAll('.dropdown-item input[type="checkbox"]');

    checkboxes.forEach(cb => {
      cb.checked = isChecked;
      cb.dispatchEvent(new Event('change', { bubbles: true }));
    });
  }

  // ==============================================================================
  // 3. BULK EMAIL LOGIC
  // ==============================================================================

  openBulkEmail(event) {
    event.preventDefault();
    this.bulkEmailModalTarget.style.display = 'block';
    document.body.style.overflow = 'hidden';

    // Reset UI
    this.emailResultContainerTarget.style.display = 'none';
    this.emailListTextareaTarget.value = '';
    this.generateEmailsBtnTarget.disabled = false;
    this.generateEmailsBtnTarget.innerText = 'Generate List';

    // Update Summary Text (reads from form)
    this._updateBulkEmailSummary();

    // Update Select All Checkbox State (reads from checkboxes)
    this.checkBulkEmailSelectAll();
  }

  closeBulkEmail(event) {
    if (event) event.preventDefault();
    this.bulkEmailModalTarget.style.display = 'none';
    document.body.style.overflow = '';
  }

  // Toggle "Select All" inside the Bulk Email modal
  toggleBulkEmailAll(event) {
    const isChecked = event.target.checked;
    const checkboxes = this.bulkEmailFormTarget.querySelectorAll('.bulk-email-checkbox');
    checkboxes.forEach(cb => cb.checked = isChecked);
  }

  // Updates Master when children change
  checkBulkEmailSelectAll(event) {
    const checkboxes = Array.from(this.bulkEmailFormTarget.querySelectorAll('.bulk-email-checkbox'));
    const allChecked = checkboxes.every(cb => cb.checked);

    if (this.hasBulkEmailSelectAllTarget) {
      this.bulkEmailSelectAllTarget.checked = allChecked;
    }
  }

  // Displays active filters in the modal so user knows what they are targeting
  _updateBulkEmailSummary() {
    // Safety check: if targets aren't found, stop silently or show error
    if (!this.hasFilterSummaryTarget || !this.hasFormTarget) return;

    const formData = new FormData(this.formTarget);
    let parts = [];

    // 1. Capture Search
    const search = formData.get('search');
    if (search && search.trim() !== '') parts.push(`Search: "${search}"`);

    // 2. Capture Multi-selects (Status, Hub, etc.)
    // Helper to get comma-separated values
    const getValues = (name) => {
      // Rails adds [] to multi-select names (e.g., status[])
      const values = formData.getAll(name).filter(v => v.trim() !== '');
      return values.length > 0 ? values.join(', ') : null;
    };

    const status = getValues('status[]');
    if (status) parts.push(`Status: ${status}`);

    const hub = getValues('hub[]');
    if (hub) parts.push(`Hub: ${hub}`);

    const prog = getValues('programme[]');
    if (prog) parts.push(`Prog: ${prog}`);

    const curr = getValues('curriculum[]');
    if (curr) parts.push(`Curr: ${curr}`);

    const grade = getValues('grade_year[]');
    if (grade) parts.push(`Grade: ${grade}`);

    // 3. Capture Age
    const ageMin = formData.get('age_min');
    const ageMax = formData.get('age_max');
    // Only show if different from default range (assuming 0-50 based on your file)
    if ((ageMin && ageMin !== '0') || (ageMax && ageMax !== '50')) {
       parts.push(`Age: ${ageMin} - ${ageMax}`);
    }

    // 4. Update the Text
    if (parts.length === 0) {
      this.filterSummaryTarget.textContent = "No active filters (Selecting from ALL active learners)";
      this.filterSummaryTarget.style.color = "#888";
    } else {
      this.filterSummaryTarget.innerHTML = parts.join('<br>');
      this.filterSummaryTarget.style.color = "#0d6efd";
    }
  }

  generateBulkEmails(event) {
    event.preventDefault();

    const btn = this.generateEmailsBtnTarget;
    const originalText = btn.innerText;
    btn.disabled = true;
    btn.innerText = 'Generating...';

    // 1. Get Filters from Main Form
    if (!this.hasFormTarget) {
        alert("Error: Could not find filter form.");
        btn.disabled = false;
        btn.innerText = originalText;
        return;
    }
    const mainFormData = new FormData(this.formTarget);

    // 2. Get Options from Email Form
    const bulkFormData = new FormData(this.bulkEmailFormTarget);

    // 3. Merge
    const params = new URLSearchParams();

    for (const [key, value] of mainFormData.entries()) {
      if (value.trim() !== '') params.append(key, value);
    }
    for (const [key, value] of bulkFormData.entries()) {
      params.append(key, value);
    }

    const url = `/admissions/generate_bulk_emails?${params.toString()}`;

    fetch(url, {
      method: 'POST',
      headers: {
        'Accept': 'application/json',
        'X-CSRF-Token': this._getCsrfToken()
      }
    })
    .then(response => response.json())
    .then(data => {
      this.emailResultContainerTarget.style.display = 'block';
      this.emailCountTarget.innerText = data.count;
      this.emailListTextareaTarget.value = data.emails;
    })
    .catch(error => {
      console.error('Error:', error);
      alert('Failed to generate emails.');
    })
    .finally(() => {
      btn.disabled = false;
      btn.innerText = originalText;
    });
  }

  copyToClipboard(event) {
    event.preventDefault();
    const copyText = this.emailListTextareaTarget;
    copyText.select();
    copyText.setSelectionRange(0, 99999);
    navigator.clipboard.writeText(copyText.value).then(() => {
      const btn = this.copyBtnTarget;
      const originalHtml = btn.innerHTML;
      btn.innerHTML = '<i class="fa fa-check"></i> Copied!';
      btn.style.background = '#d4edda';
      btn.style.color = '#155724';
      setTimeout(() => {
        btn.innerHTML = originalHtml;
        btn.style.background = '#f8f9fa';
        btn.style.color = 'inherit';
      }, 2000);
    });
  }

  // ==============================================================================
  // 4. EXPORT MODAL LOGIC (New Interactions)
  // ==============================================================================

  openExport(event) {
    event.preventDefault();
    this.exportModalTarget.style.display = 'block';
    document.body.style.overflow = 'hidden';

    const params = new URLSearchParams(window.location.search);
    const exportUrl = `/admissions/export?${params.toString()}`;

    fetch(exportUrl, {
      headers: { 'Accept': 'text/html', 'X-Requested-With': 'XMLHttpRequest' }
    })
    .then(response => response.text())
    .then(html => {
      this.exportModalContentTarget.innerHTML = html;
    })
    .catch(error => {
      this.exportModalContentTarget.innerHTML =
        '<div style="padding: 40px; text-align: center;"><p style="color: #dc3545;">Error loading export form.</p></div>';
    });
  }

  closeExport(event) {
    if (event) event.preventDefault();
    this.exportModalTarget.style.display = 'none';
    document.body.style.overflow = '';
  }

  submitExport(event) {
    event.preventDefault();
    const form = document.getElementById('exportForm');
    const checkedBoxes = form.querySelectorAll('input[name="fields[]"]:checked');

    if (checkedBoxes.length === 0) {
      alert('Please select at least one field to export');
      return;
    }

    form.submit();
    setTimeout(() => this.closeExport(), 500);
  }

  // Helper: Toggle checkboxes in Export Modal for Filters (Status, Hub, etc)
  toggleExportFilterCategory(event) {
    event.preventDefault();
    const category = event.target.dataset.category;
    const checkboxes = this.exportModalContentTarget.querySelectorAll(`input[data-filter-category="${category}"]`);

    // Logic: if all checked, uncheck all. Otherwise check all.
    const allChecked = Array.from(checkboxes).every(cb => cb.checked);
    checkboxes.forEach(cb => cb.checked = !allChecked);
  }

  // Helper: Select all Field checkboxes (Columns)
  exportSelectAllFields(event) {
    event.preventDefault();
    const checkboxes = this.exportModalContentTarget.querySelectorAll('.field-checkbox');
    checkboxes.forEach(cb => cb.checked = true);
  }

  exportDeselectAllFields(event) {
    event.preventDefault();
    const checkboxes = this.exportModalContentTarget.querySelectorAll('.field-checkbox');
    checkboxes.forEach(cb => cb.checked = false);
  }

  // Helper: Select Fields by Category Group
  exportSelectCategory(event) {
    event.preventDefault();
    const categoryId = event.target.dataset.category;
    const checkboxes = this.exportModalContentTarget.querySelectorAll(`.field-checkbox[data-category="${categoryId}"]`);
    checkboxes.forEach(cb => cb.checked = true);
  }

  exportDeselectCategory(event) {
    event.preventDefault();
    const categoryId = event.target.dataset.category;
    const checkboxes = this.exportModalContentTarget.querySelectorAll(`.field-checkbox[data-category="${categoryId}"]`);
    checkboxes.forEach(cb => cb.checked = false);
  }

  // ==============================================================================
  // 5. UTILITIES / HELPERS
  // ==============================================================================

  fetchFromHubspot(event) {
    if (event) event.preventDefault();
    const url = '/admissions/fetch_from_hubspot';
    this._disableFetchBtn(true);
    const btn = this.fetchHubspotBtnTarget;
    const originalHtml = btn.innerHTML;
    btn.innerHTML = '<span class="spinner-border" role="status" aria-hidden="true" style="width:16px;height:16px;display:inline-block;border-radius:50%;border:2px solid rgba(255,255,255,0.3);border-top-color:white;margin-right:8px;"></span> Syncing...';

    fetch(url, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json', 'Accept': 'application/json', 'X-CSRF-Token': this._getCsrfToken() },
      body: JSON.stringify({})
    })
    .then(response => response.json().then(body => ({ status: response.status, body: body })))
    .then(({ status, body }) => {
      if (status >= 200 && status < 300 && body && body.success) {
        this._showHubspotMessage(body.message || 'Sync completed.');
        this._refreshLearnerInfosFrame();
      } else {
        this._showHubspotMessage('Error: ' + ((body && (body.error || body.message)) || 'Unknown error'));
      }
    })
    .catch(err => {
      this._showHubspotMessage('Error communicating with server.');
    })
    .finally(() => {
      this._disableFetchBtn(false);
      btn.innerHTML = originalHtml;
    });
  }

  _showHubspotMessage(text) {
    clearTimeout(this.hubspotMessageTimeout);
    this.hubspotMessageTextTarget.textContent = text;
    this.hubspotMessageModalTarget.style.display = 'block';
    this.hubspotMessageTimeout = setTimeout(() => this.closeHubspotMessage(), 5000);
  }

  closeHubspotMessage(event) {
    if (event) event.preventDefault();
    clearTimeout(this.hubspotMessageTimeout);
    if (this.hasHubspotMessageModalTarget) this.hubspotMessageModalTarget.style.display = 'none';
  }

  _disableFetchBtn(disabled) {
    if (!this.hasFetchHubspotBtnTarget) return;
    const btn = this.fetchHubspotBtnTarget;
    btn.disabled = disabled;
    btn.style.opacity = disabled ? 0.6 : 1;
    btn.style.cursor = disabled ? 'not-allowed' : 'pointer';
  }

  _refreshLearnerInfosFrame() {
    try {
      const url = window.location.pathname + window.location.search;
      fetch(url, { headers: { 'Accept': 'text/html' } })
        .then(r => r.ok ? r.text() : Promise.reject())
        .then(html => {
          const doc = new DOMParser().parseFromString(html, 'text/html');
          const newFrame = doc.querySelector('turbo-frame#learner_infos');
          const currentFrame = document.querySelector('turbo-frame#learner_infos');
          if (newFrame && currentFrame) currentFrame.innerHTML = newFrame.innerHTML;
          else window.location.reload();
        })
        .catch(() => window.location.reload());
    } catch (e) { window.location.reload(); }
  }

  handleClickOutside(event) {
    if (this.hasExportModalTarget && event.target === this.exportModalTarget) this.closeExport();
    if (this.hasBulkEmailModalTarget && event.target === this.bulkEmailModalTarget) this.closeBulkEmail();
  }

  handleKeydown(event) {
    if (event.key === 'Escape') {
      if (this.hasExportModalTarget && this.exportModalTarget.style.display === 'block') this.closeExport();
      if (this.hasBulkEmailModalTarget && this.bulkEmailModalTarget.style.display === 'block') this.closeBulkEmail();
    }
  }

  _requestSubmit() {
    typeof this.element.requestSubmit === "function" ? this.element.requestSubmit() : this.element.submit();
  }

  _updateClearForAll() {
    if (this.hasSearchInputTarget && this.hasSearchClearTarget) this._updateClear(this.searchInputTarget, this.searchClearTarget);
    if (this.hasStatusSelectTarget && this.hasStatusClearTarget) this._updateClear(this.statusSelectTarget, this.statusClearTarget);
    if (this.hasCurriculumSelectTarget && this.hasCurriculumClearTarget) this._updateClear(this.curriculumSelectTarget, this.curriculumClearTarget);
    if (this.hasGradeSelectTarget && this.hasGradeClearTarget) this._updateClear(this.gradeSelectTarget, this.gradeClearTarget);
    if (this.hasProgrammeSelectTarget && this.hasProgrammeClearTarget) this._updateClear(this.programmeSelectTarget, this.programmeClearTarget);
    if (this.hasHubSelectTarget && this.hasHubClearTarget) this._updateClear(this.hubSelectTarget, this.hubClearTarget);
  }

  _updateClear(fieldEl, clearButtonEl) {
    let hasValue = false;
    if (fieldEl.tagName === "SELECT") {
      hasValue = fieldEl.multiple
        ? Array.from(fieldEl.selectedOptions).some(opt => opt.value && opt.value.trim() !== "")
        : (fieldEl.value != null && String(fieldEl.value).trim() !== "");
    } else {
      hasValue = String(fieldEl.value).trim().length > 0;
    }
    clearButtonEl.style.display = hasValue ? "inline" : "none";
  }

  _getCsrfToken() {
    const el = document.querySelector('meta[name="csrf-token"]');
    return el ? el.content : '';
  }
}
