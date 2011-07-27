--- 
title: First
author: Ryan Florence
date: Thu Jul 21 23:33:00 -0600 2011
---

It's difficult to talk about modular code in JavaScript without somebody saying "Yeah, but JavaScript doesn't have classes."  For kicks, I looked up how wikipedia defines a class:

> A Class is a template for an object, a user-defined datatype that contains variables, properties, and methods. A class defines the abstract characteristics of a thing (object), including its characteristics (its attributes, fields or properties) and the things it can do (behaviors) or methods, operations or features). One might say that a class is a blueprint or factory that describes the nature of something. ... Classes provide modularity and structure in an object-oriented computer program. ... Also, the code for a class should be relatively self-contained (generally using encapsulation). <cite>-[wikipedia](http://en.wikipedia.org/wiki/Object-oriented_programming#Class)</cite>

A MooTools class is exactly that--__welcome to JavaScript with `Class`__.

The sooner you master Class, the sooner you'll write maintainable, extensible JavaScript.  After MooTools Core establishes a few things, nearly every other addition to the framework is a class.  Let's dig in:

A MooTools Class
----------------

### Example 1 - [View this on jsFiddle](http://jsfiddle.net/rpflorence/YQXNr/)

	var ClassNameSwapper = new Class({
	  
	  current: null,
	
	  initialize: function(element){
	    this.element = document.id(element);
	    this.attach();
	  },
	
	  attach: function(){
	    var self = this;
	    this.element.addEvent('click', function(event){
	      self.setCurrentTo(event.target);
	    });
	  },
	
	  setCurrentTo: function(target){
	    if (target == this.current) return;
	    if (this.current) this.current.removeClass('current');
	    this.current = $(target).addClass('current');
	  }
	
	});
	
	// usage
	var nav = new ClassNameSwapper('main-nav');

The Class constructor is a function that takes an object, or template, as its only argument and returns another function.  It's an API abstraction designed to simplify the use of JavaScript's prototypal inheritance.  Perhaps we could call it a "generator": it generates enhanced constructor functions.  In the context of MooTools, we call them classes, and the objects they create, instances.

This class does nothing more than move the `current` css class name around. It has the `current` property and then three methods: `initialize`, `attach`, and `setCurrentTo`.  When you create a new `ClassNameSwapper` instance the `initialize` function is called automatically.

`initialize` stores the parent element and then calls `attach`, which simply adds a click event listener to the element and passes on the target element that received the click to the `setCurrentTo` method, which then does some checking and eventually swaps the current class around.  Similar code outside of a class could certainly be shorter and might look like this:

### Example 2

	(function(){
	  // swaps a class name around
	
	  var current = null;

	  $('main-nav').addEvent('click', function(event){
	    if (event.target == current) return;
	    if (current) current.removeClass('current');
	    current = $(event.target).addClass('current');
	  });

	}());

Classes lead to modular, testable, reusable code
------------------------------------------------

Contrasting Example 1 with Example 2, we find many differences:

1. **The logic is separate from the implementation**
2. **We can quickly comprehend its purpose by scanning the name of the class and its methods.**
3. **We can reuse it anywhere, in this application or others.**
4. **We have an object we can work with anywhere on the page.**
5. **We can test it outside of the application.**
6. **We can extend it, and reuse more code.**

### The logic is out of the application code

I view JavaScript code in two categories: logic and implementation (sometimes I'll refer to implementation as "application code.")  It's important to keep the business logic of a script separate from the application code for many reasons: testability, modularity and reusability are the first that come to mind.  Littering business logic throughout your application code destroys all three of these goals and creates a brittle application.  MooTools classes, by design, encourage this separation.

### We can quickly comprehend its purpose by scanning the name of the class and its methods

With well structured classes, and descriptive method and property names, there's little need to comment.  Of course, strange looking code should get a quick comment, but stuff like `// swaps a class name around` is completely unnecessary.

### We can reuse Example 1 anywhere, in this application or others

If we need to do this again on this page, or another, or even an entirely different project, it's as simple as:

	new ClassNameSwapper('other-nav');
	new ClassNameSwapper('other-nav2');

In Example 2 we'd have to copy and paste that code over and over.  Gross.

### We have an object we can work with anywhere on the page

Note the `setCurrentTo` method.  When we create a new instance of a class it's just an object. We can manage the state of that object by calling its methods.

	var nav = new ClassNameSwapper('main-nav');
	
	// change the "current" item manually
	// maybe in a keyboard event, or after an AJAX request
	nav.setCurrentTo(someElement);

In Example 2, we'd need all sorts of new code to get something like this to work.

### We can test it outside of the application.

`ClassNameSwapper` doesn't care about our application.  We can whip up some automated / interactive tests pretty easily.  

[View this on jsFiddle](http://jsfiddle.net/rpflorence/tSJpV/)

	var fixture = $('fixture'),
	    child = $('child'),
	    child2 = $('child2'),
	    nav = new ClassNameSwapper(fixture);

	// simulate a click on the child element
	fixture.fireEvent.apply(fixture, ['click', { target: child }]);
	console.log(
	    child.hasClass('current') ? 'passed' : 'failed',
	    '=> ClassNameSwapper should add current class to clicked element'
	);

	nav.setCurrentTo(child2);
	console.log(
	    child2.hasClass('current') ? 'passed' : 'failed',
	    '=> `setCurrentTo(child2)` should add "current" class to elements'
	);
	console.log(
	    child.hasClass('current') ? 'failed' : 'passed',
	    '=> `child` should not have current class after child2 is set as current'
	);

Results in the log:

	passed => ClassNameSwapper should add current class to clicked element
	passed => `setCurrentTo(child2)` should add "current" class to elements
	passed => `child` should not have current class after child2 is set as current

Note that testing our code, in Example 2, is completely impossible.

### We can extend it, and reuse code

If on this project, or some other project, we needed a class swapper that also responded to hover events we don't have to touch the original class, we can just extend it.

[View this on jsFiddle](http://jsfiddle.net/rpflorence/HmNZK/)

First, we write these tests to see if hovering the child elements adds and removes the `hover` class:

	// simulate a mouseover/out on the child element
	fixture.fireEvent.apply(fixture, ['mouseover', { target: child }]);
	console.log(
	  child.hasClass('hover') ? 'passed' : 'failed',
	  '=> ClassNameSwapper.Hover should add hover class to mouseover-ed element'
	);
	fixture.fireEvent.apply(fixture, ['mouseout', { target: child }]);
	console.log(
	  child.hasClass('hover') ? 'failed' : 'passed',
	  '=> ClassNameSwapper.Hover should remove hover class on mouseout'
	);

Then we write code until all the tests pass.

	ClassNameSwapper.Hover = new Class({

	  Extends: ClassNameSwapper,

	  attach: function(){
	    this.parent();
	    var self = this;
	    this.element.addEvents({
	      mouseover: function(event){
	        if (event.target != self.element) self.setHoverTo(event.target);
	      },
	      mouseout: function(event){
	        if (event.target != self.element) self.removeHoverFrom(event.target);
	      }
	    });
	  },

	  setHoverTo: function(target){
	    this.lastHovered = $(target).addClass('hover');
	  },

	  removeHoverFrom: function(target){
	    $(target).removeClass('hover');
	  }

	});

Two things going on up there.  First, line 3 has what's called a "mutator" named `Extends`.  This tells `Class` to make `ClassNameSwapper` the prototype of `ClassNameSwapper.Hover`, allowing us to reuse everything from the parent class.

Second, note the call to `this.parent()` in line 6.  This makes a call to the parent's attach method.  This allows us to add functionality to a method while still reusing the original code.

Now imagine we had used the code in Example 2 for this simple widget, to add this new functionality in a few places would be tedious and error-prone.  But with `Class`, it's simple, we just find the instances of `ClassNameSwapper` that we want to enhance and replace them.

	// var nav = new ClassNameSwapper('main-nav');
	var nav = new ClassNameSwapper.Hover('main-nav');

Or, if you're really 1337, extend `ClassNameSwapper` onto itself and change none of your application code.
