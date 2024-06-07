window.onVisit = function (callback) {
  document.addEventListener('turbo:render', (event) => {
    if (!event.isPreview) callback();
  });
  document.addEventListener('DOMContentLoaded', callback);
};
