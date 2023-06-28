// Entry point for the build script in your package.json
import * as bootstrap from "bootstrap"
import "@hotwired/turbo-rails"
import EasyMDE from 'easymde';

document.addEventListener("turbo:load", () => {
  document.querySelectorAll('textarea.easymde-required').forEach(textarea => {
    var editor = new EasyMDE({
      element: textarea,
      autoDownloadFontAwesome: false,
      spellChecker: false,
      status: false,
      toolbar: ["bold", "italic", "heading-3", "|", "unordered-list", "ordered-list", "link", "|",
        {
            name: "tabelle",
            action: EasyMDE.drawTable,
            className: "fa fa-table",
            title: "Tabelle einfügen",
        }, "horizontal-rule", "|", "preview", "side-by-side", "fullscreen", "guide"]
    });
  });
});