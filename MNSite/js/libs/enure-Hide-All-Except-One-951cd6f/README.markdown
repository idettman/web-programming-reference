## hide all except one

### Overview

This works like tabs, however you may
style it however you want of course.

The tabs are bookmarkable, however browser
back and forward buttons (history) does not
work.

### How To

Create links as such and place them 
anywhere in your markup:

    <a href="#lorem" class="tab">lorem</a>
    <a href="#ipsum" class="tab">ipsum</a>

Create your 'tab' content:

    <div id="lorem" class="box">
        lorem
    </div>
    <div id="ipsum" class="box">
        ipsum
    </div>

Then call the javascript as such:

    <script>
        jQuery(function($){
            $.hideAllExcept('.tab', '.box');
        });
    </script>

### No Javascript

In the case where javascript is not enabled
the browser will scroll to the target.

### Requirements

Requires jquery (http://jquery.com/) (rev 1465 or above: http://dev.jquery.com/ticket/745)

### URL

http://github.com/enure/Hide-All-Except-One
