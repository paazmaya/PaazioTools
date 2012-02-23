/* http://www.stoimen.com/blog/2010/02/17/clickoutside-jquery-plugin/ */
(function(jQuery) {
   jQuery.fn.clickoutside = function(callback) {
      var outside = 1, self = $(this);
      self.cb = callback;
      this.click(function() {
         outside = 0;
      });
      $(document).click(function() {
         outside && self.cb();
         outside = 1;
      });
      return $(this);
   }
})(jQuery);