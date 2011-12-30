
var markWord = {
	
	/**
	 * Find the given word and wrap them in span.
	 * Use the returned "rel" to remove the added spans.
	 */
	findWord: function(word) {
		var rel = 'word-' + $.now();
		$('article p:contains("' + word + '")').each(function () {
			markWord.replaceHtml($(this), word, '<span rel="' + rel + '">' + word + '</span>');
		});
		return rel;
	},

	/**
	 * Replace the html of the given element(s).
	 * https://developer.mozilla.org/en/JavaScript/Reference/Global_Objects/String/replace
	 */
	replaceHtml: function($elem, search, replace) {
		if ($elem.children().length > 0) {
			$elem.children().each(function() {
				markWord.replaceHtml($(this), search, replace);
			});
		}
		else {
			$elem.html($elem.text().replace(search, replace));
		}
	},

	/**
	 * Remove all spans that have the given rel.
	 * But not their content, only the wrapping span.
	 */
	removeSpans: function(rel) {
		// unwrap
		$('span[rel="' + rel + '"]').replaceWith($('span[rel="' + rel + '"]').contents());
	},

	/**
	 * Draw a path between the given two DOM elements
	 */
	drawPath: function(dom1, dom2) {
		
	}
	
	
};
