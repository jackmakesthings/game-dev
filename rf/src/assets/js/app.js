$(document).foundation();

var node = document.querySelector('.type');
var node2 = document.querySelector('.img-overlay');

var contents = node.textContent.split('');
var contents2 = "DR. WHATEVER".split('');
var running = true;

node.innerText = "";

function loop(node, contents) {
	if (contents.length < 1 || !running) {
		running = false;
		return;
	}

	node.innerHTML += contents[0];
	contents.shift();
	setTimeout(function() { loop(node, contents); }, 70);
}

function clear(node) {
	running = false;
	node.innerHTML = "";
}

function reset(node, new_text) {
	clear(node)
	contents = new_text.split('');
	running = true;
	loop(node, contents);
}

var lines = ["Testing. Testing.", "Is this thing on?", "Oh - good."];
var _lines = [].concat(lines);

$(document).on('keypress', function(e) {
	console.log(e);
	e.preventDefault();
	if(e.key == 'x') {
		clear(node);
	}

	if (e.key == 'a') {
		if (_lines.length > 0) {
			reset(node,_lines[0]);
			_lines.shift();
		}
		else {
			clear(node);
			_lines = [].concat(lines);
		}
	}
});

// loop(node2, contents2);

var Typewriter = (function() {
	'use strict';

	var running = false;

	function clear(node) {
		running = false;
		node.innerHTML = "";
	}

	function reset(node, new_text) {
		clear(node)
		contents = new_text.split('');
		running = true;
		loop(node, contents);
	}

	function advance_line(node, lines) {
		if (lines.length > 0) {
			reset(node,lines[0]);
			lines.shift();
		}
	}

	function loop(node, contents) {
		if (contents.length < 1 || !running) {
			running = false;
			return;
		}

		node.innerHTML += contents[0];
		contents.shift();
		setTimeout(function() { loop(node, contents); }, 70);
	}


	function setup(el, lines) {
		running = true;
		var $el = document.querySelector(el);
		loop($el, lines[0].split(''));
	}

	return {
		loop:loop,
		setup: setup,
		advance_line: advance_line
	};
}());
