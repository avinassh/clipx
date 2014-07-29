$(document).ready(function(){
  $('.flash button').click(function(){
    $(this).parents('.flash').remove();
  });
})