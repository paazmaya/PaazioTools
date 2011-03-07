var zmax = 0;

$('.draggable').click(function() {
	$(this).siblings('.draggable').each(function() {
		var cur =  $(this).css('zIndex');
		zmax = cur > zmax ? cur : zmax;
	});
	$(this).css('zIndex', zmax + 1);
});

// Or to use functional way
zmax = Math.max(zmax, this.style.zIndex);

// Another aproach
$(this).css('zIndex',
	Math.max.apply(
		null,
		$.map($(this).siblings('.draggable'),
			function(){
				return this.style.zIndex;
			}
		);
	)
);