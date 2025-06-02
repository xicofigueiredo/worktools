window.initializeCategoryMultiselects = function() {
  document.querySelectorAll('.category-multiselect').forEach(function(select) {
    if (select.tomselect) {
      select.tomselect.destroy();
    }
    new TomSelect(select, {
      plugins: ['remove_button'],
      persist: false,
      create: false,
      maxItems: null,
      render: {
        item: function(data, escape) {
          return `<div class="badge bg-primary me-1 mb-1">${escape(data.text)}</div>`;
        },
        optgroup: function(data, escape) {
          return `<div class="ts-optgroup"><div class="ts-optgroup-header" style="font-weight:bold;">${escape(data.label)}</div><div class="ts-optgroup-options"></div></div>`;
        }
      }
    });
  });
}
