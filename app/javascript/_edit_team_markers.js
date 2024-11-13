const quickTeamMarkerChange = function () {
  document.querySelectorAll('.quick-team-marker-change-link').forEach(function (btn) {
    btn.addEventListener('click', (event) => {
      event.preventDefault();

      const modal = document.createElement('div');
      modal.classList.add('feusport-modal');
      modal.style.display = 'block';
      const modalContent = document.createElement('div');
      modalContent.classList.add('feusport-modal-content');
      modal.appendChild(modalContent);

      modalContent.innerText = 'spinning';

      document.querySelector('body').appendChild(modal);

      const csrfToken = document.head.querySelector('[name~=csrf-token][content]').content;
      fetch(btn.dataset.url, {
        headers: {
          'X-CSRF-Token': csrfToken,
          'Content-Type': 'application/json',
          'X-Requested-With': 'XMLHttpRequest',
        },
        method: 'GET',
        credentials: 'same-origin',
      })
        .then((res) => res.json())
        .then((json) => {
          modalContent.innerHTML = json.content;
          resetHandler();
        });
    });
  });
};

onVisit(quickTeamMarkerChange);
