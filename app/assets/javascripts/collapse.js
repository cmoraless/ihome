$(function() {
	$.fn.cycle.transitions.scrollHorzTouch = function($cont, $slides, opts) {
	$cont.css('overflow','hidden').width();
	opts.before.push(function(curr, next, opts, fwd) {

        if (opts.rev)
        fwd = !fwd;

        positionNext = $(next).position();
        positionCurr = $(curr).position();

        $.fn.cycle.commonReset(curr,next,opts);
        if( ( positionNext.left > 0 && fwd ) || ( positionNext.left <  0 && !fwd ) )
        {
            opts.cssBefore.left = positionNext.left;
        }
        else
        {
            opts.cssBefore.left = fwd ? (next.cycleW-1) : (1-next.cycleW);
        }
        if( ( positionCurr.left > 0 && fwd ) || ( positionCurr.left <  0 && !fwd ) )
        {
                     opts.animOut.left = positionCurr.left;
        }
        else
        {
                opts.animOut.left = fwd ? -curr.cycleW : curr.cycleW;
        }

	});
	opts.cssFirst.left = 0;
	opts.cssBefore.top = 0;
	opts.animIn.left = 0;
	opts.animOut.top = 0;
};
     var currenSlide = null;
     var slideNumber = 0;
     var currentLeft = 0;
     var leftStart = 0;
     var sliderExpr;
     var slideFlag = false;

 $('#rotating-item-wrapper').cycle({
        fx:     'scrollHorzTouch',
        timeout: 0,
        pager:  '#nav',
        speedIn:   400,
        speedOut:   400,
        slideExpr: 'img',
        next:   '#nextBt',
        prev:   '#prevBt',
        before: beforeSlide,
        after: afterSlide,
        startingSlide: 0


    });



$('#rotating-item-wrapper').swipe({ swipeMoving: function( pageX ){

        if( slideFlag ) return;

        var newLeft = currentLeft-pageX;

        currenSlide.css('left', newLeft+'px'  );

        var $slides = $( sliderExpr, $('#rotating-item-wrapper') );
        var scrollSlide;

        nextSlideLeft =   newLeft > 0 ? newLeft - currenSlide.width(): newLeft+currenSlide.width();
        flag = newLeft > 0 ? -1: 1;
        scrollSlide  = slideNumber + flag;
        if( scrollSlide < 0 || scrollSlide > ($slides.length - 1 ) )
        {
            scrollSlide = scrollSlide < 0 ? $slides.length - 1 : 0;
        }

         $slides.eq( scrollSlide ).css('left',nextSlideLeft + 'px' );
         $slides.eq( scrollSlide ).show();
    },
    swipeLeft: function(){$('#rotating-item-wrapper').cycle('next');},
    swipeRight: function(){ $('#rotating-item-wrapper').cycle('prev'); }


    });


// Call this function before the slide start
function beforeSlide( curr, next , opt )
{
     sliderExpr = opt.slideExpr;
     slideFlag = true;
}

// Call this function after the slide start
function afterSlide(curr, next , opt )
{
    currenSlide =  $(next);
    slideNumber = opt.currSlide;
    currentLeft = $(next).position().left;
    slideFlag = false;
}

});
