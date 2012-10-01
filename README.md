iPhone-Calculator
=================

iPhone Calculator created as homework project for CIS195@UPenn

Some features to note:
	- expression respects order of operations
		- this is done by converting the infix expression into postfix notation and then evalutating the postfix expression using a sudo stack (aka a NSMutableArray).

	- two operators cannot be entered one after another, they must be seperated by an operand

	- an operator cannot be entered as the first value in an expression

	- trying to divide by zero will give you a result of "undefined"

	- calculator respects decimal places and always returns a result with 2 decimal places.

	- If a expression is too long to fit in one of the labels, the font of the label is automatically resized to fit the entire expression.

Extra Credit:

	- (10 pts) Show the entire operation string instead of just the previous number. Make sure this is displayed properly even when the operation string is very long. Think about how you would do that gracefully.

	- (5 pts) Support backspace.
