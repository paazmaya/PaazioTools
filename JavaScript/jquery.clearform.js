/**
 * Few small plugins which are build based on a research in the Internet.
 */
(function ($) {
	/**
	 * http://www.learningjquery.com/2007/08/clearing-form-data
	 */
	$.fn.clearForm = function () {
		return this.each(function () {
			var type = this.type, tag = this.tagName.toLowerCase();
			if (tag == 'form') {
				return $(':input',this).clearForm();
			}
			if (type == 'text' || type == 'password' || tag == 'textarea') {
				this.value = '';
			}
			else if (type == 'checkbox' || type == 'radio') {
				this.checked = false;
			}
			else if (tag == 'select') {
				this.selectedIndex = -1;
			}
		});
	};
})(jQuery);
