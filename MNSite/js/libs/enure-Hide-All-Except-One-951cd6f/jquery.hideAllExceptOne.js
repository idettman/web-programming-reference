/* http://github.com/enure/Hide-All-Except-One */

(function($){
  $.hideAllExcept = function(tabs,boxes){
    function init() {
      // make it bookmarkable/refreshable. but, no history.
      var hash = window.location.hash;
      (!hash) ? hideShow('#' + $(boxes+':first').attr('id')) : hideShow(window.location.hash);

      // add click handler.
      $(tabs).click(function(e) {
        e.preventDefault();
        var href = $(this).attr('href');
        // add back the hash which is prevented by e.preventDefault()
        window.location.hash = href;
        hideShow(href);
      });
    }
    function hideShow(el) {
      $(boxes).hide();
      $(el).show();

      $(tabs).removeClass('active');
      $('a[href="' + el + '"]').addClass('active');
    }
    init();
  };
})(jQuery);