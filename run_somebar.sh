#! /bin/sh

my_function() {
somebar -p 9753 &> /dev/null # где "2> /dev/null" - игнорим предупреждения но, пишет что прилитело! (Бывает 1/2/&) https://stackoverflow.com/questions/15678796/suppress-shell-script-error-messages/15678832
}

my_function
