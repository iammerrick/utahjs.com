(function(){
  // swaps a class name around

  var current = null;

  $('main-nav').addEvent('click', function(event){
    if (event.target == current) return;
    if (current) current.removeClass('current');
    current = $(event.target).addClass('current');
  });

}());
