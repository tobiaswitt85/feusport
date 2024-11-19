onVisit(function () {
  const arrowLeft = document.createElement('div');
  arrowLeft.classList.add('arrow', 'left');
  arrowLeft.innerText = '←';
  const arrowRight = document.createElement('div');
  arrowRight.classList.add('arrow', 'right');
  arrowRight.innerText = '→';

  const container = document.querySelector('.page-tabs .nav-pills');
  if (!container) return;

  container.addEventListener('scroll', function () {
    if (container.scrollLeft > 0) {
      container.append(arrowLeft);
    } else {
      arrowLeft.remove();
    }

    if (container.scrollLeft < container.scrollWidth - container.clientWidth) {
      container.append(arrowRight);
    } else {
      arrowRight.remove();
    }
  });

  container.dispatchEvent(new Event('scroll'));
});
