handlers = [];
const resetHandler = function () {
  document.querySelectorAll('.assessment-request').forEach(function (context) {
    const checkbox = context.querySelector('input[type=checkbox]');
    checkbox.addEventListener('change', (event) => {
      const opacity = checkbox.checked ? 1 : 0.3;
      context.querySelector('.edit-assesment-type').style.opacity = opacity;
    });
    checkbox.dispatchEvent(new Event('change'));
    // ).change()
    // handlers.push(checkbox[0])
    // context.find('select.assessment-types').change( ->
    //   if $(this).val() is 'group_competitor'
    //     context.find('.group-competitor-order').show()
    //     context.find('.single-competitor-order').hide()
    //     context.find('.competitor-order').hide()
    //   else if $(this).val() is 'single_competitor'
    //     context.find('.single-competitor-order').show()
    //     context.find('.group-competitor-order').hide()
    //     context.find('.competitor-order').hide()
    //   else if $(this).val() is 'competitor'
    //     context.find('.competitor-order').show()
    //     context.find('.group-competitor-order').hide()
    //     context.find('.single-competitor-order').hide()
    //   else
    //     context.find('.single-competitor-order').hide()
    //     context.find('.group-competitor-order').hide()
    //     context.find('.competitor-order').hide()
    // ).change()
  });
};

document.addEventListener('turbo:load', resetHandler);
