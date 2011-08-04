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
