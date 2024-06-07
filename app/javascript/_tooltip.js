onVisit(function () {
  let div = null;

  document.querySelectorAll('span.balloon').forEach(function (b) {
    let showForce = false;

    const show = function (force) {
      if (force) showForce = true;
      if (div !== null) {
        div.remove();
        div = null;
      }

      div = document.createElement('div');
      div.classList.add('balloon-tip');
      div.innerHTML = b.dataset.balloonContent;
      document.querySelector('body').append(div);
      const rect = b.getBoundingClientRect();
      div.style.left = `${rect.x + window.pageXOffset - 100}px`;
      div.style.top = `${rect.y + window.pageYOffset + 30}px`;
      console.log(div);
    };

    const hide = function (force) {
      if (showForce && !force) return;
      if (showForce) showForce = false;
      if (div !== null) div.remove();
    };

    const toggle = function () {
      if (showForce) hide(true);
      else show(true);
    };
    b.addEventListener('mouseover', () => show(false));
    b.addEventListener('mouseout', () => hide(false));
    b.addEventListener('click', toggle);
  });
});
