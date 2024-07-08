import Sortable from 'sortablejs/modular/sortable.core.esm.js';

const generatePrintList = function () {
  const printList = [];
  document
    .getElementById('sortable-list-elements')
    .querySelectorAll('li')
    .forEach(function (li) {
      printList.push(li.dataset.printId);
    });
  document.getElementById('score_list_print_generator_print_list').value = printList.join('\n');

  const csrfToken = document.head.querySelector('[name~=csrf-token][content]').content;

  const row = document.getElementById('pages-row');
  row.innerHTML = '';
  const location = window.location.toString();
  fetch(location.replace(/\/edit$/, '?preview=1'), {
    headers: {
      'X-CSRF-Token': csrfToken,
      'Content-Type': 'application/json',
    },
    method: 'PATCH',
    credentials: 'same-origin',
    body: JSON.stringify({ score_list_print_generator: { print_list: printList.join('\n') } }),
  })
    .then((res) => res.json())
    .then((json) => {
      row.innerHTML = '';
      for (let i = 0; i < json.pages.length; i++) {
        const col = document.createElement('div');
        col.classList.add('col-md-4');

        const card = document.createElement('div');
        card.classList.add('card');

        const cardHeader = document.createElement('div');
        cardHeader.classList.add('card-header');
        cardHeader.innerText = `Vorschau Seite ${i + 1}`;

        const cardBody = document.createElement('div');
        cardBody.classList.add('card-body');

        const img = document.createElement('img');
        img.classList.add('img-fluid');
        img.src = `data:image/png;base64,${json.pages[i]}`;

        cardBody.append(img);
        card.append(cardHeader);
        card.append(cardBody);
        col.append(card);
        row.append(col);
      }
    });
};

onVisit(function () {
  new Sortable(document.getElementById('sortable-list-elements'), {
    animation: 150,
    group: 'shared',
    ghostClass: 'sortable-ghost',
    chosenClass: 'sortable-chosen',
    dragClass: 'sortable-drag',
    onEnd: generatePrintList,
  });

  new Sortable(document.getElementById('sortable-list-possible-elements'), {
    animation: 150,
    group: 'shared',
    ghostClass: 'sortable-ghost',
    chosenClass: 'sortable-chosen',
    dragClass: 'sortable-drag',
    onEnd: generatePrintList,
  });

  generatePrintList();
});
