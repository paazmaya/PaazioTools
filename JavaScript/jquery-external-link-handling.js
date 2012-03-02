$("a[@href^='http']").attr('target','_blank');


$(document).ready(function() {
  $('#extlinks a').filter(function() {
 return this.hostname && this.hostname !== location.hostname;
  }).after(' <img src="/images/external.png" alt="external link"/>');
});


$('a[href^="http://"]')
  .attr({
    target: "_blank", 
    title: "Opens in a new window"
  })
  .append(' [^]');


// Creating custom :external selector
$.expr[':'].external = function(obj){
    return !obj.href.match(/^mailto\:/)
            && (obj.hostname != location.hostname);
};

// Add 'external' CSS class to all external links
$('a:external').addClass('external');



/*
**  jquery.extlink.js -- jQuery plugin for external link annotation
**  Copyright (c) 2007-2008 Ralf S. Engelschall <rse@engelschall.com> 
**  Licensed under GPL <http://www.gnu.org/licenses/gpl.txt>
**
**  $LastChangedDate$
**  $LastChangedRevision$
*/
(function($) {
    $.fn.extend({
        extlink: function (color, prefix) {
            if (typeof color === "undefined")
                color = "grey";
            if (typeof prefix === "undefined")
                prefix = "";
            var url_prefix = String(document.location)
                .replace(/^(https?:\/\/[^:\/]+).*$/, "$1")
                .replace(/^((site)?file:\/\/.+\/)[^\/]+$/, "$1")
                .replace(/(\\.)/g, "\\$1");
            var host_name = String(document.location)
                .replace(/^/, "X")
                .replace(/^X(https?|ftp):\/\/([^:\/]+).*$/, "$1")
                .replace(/^X.*$/, "")
                .replace(/(\\.)/g, "\\$1");
            $("a", this).filter(function (i) {
                var href = $(this).attr("href");
                if (href == null)
                    return false;
                return (
                       href.match(RegExp(
                           "^(" + url_prefix + ".*" +
                           (host_name != "" ? ("|" + "(https?|ftp)://" + host_name + "([/:].*)?") : "") +
                           "|" + "((https?|ftp):)?/[^/].*" +
                           ")$"
                       )) == null
                    && href.match(RegExp("^(https?|ftp)://.+")) != null
                );
            }).each(function () {
                $(this)
                    .css("backgroundImage",    "url('" + prefix + "jquery.extlink.d/extlink-" + color + ".gif')")
                    .css("backgroundRepeat",   "no-repeat")
                    .css("backgroundPosition", "right center")
                    .css("padding-right",      "11px");
            });
        }
    });
})(jQuery);
