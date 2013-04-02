// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require_tree .



$(function() {
  $("#event_shedule").datepicker();

  //$("#calendar_event_date").datepicker("option", "dateFormat", "dd/mm/yy" );
  //$("#calendar_event_date").datepicker({ appendText: "(dd/mm/yy)" });

  $("#event_shedule").datepicker("option", "dateFormat", "yy-mm-dd" );
  //$("#calendar_event_date").datepicker({ appendText: "(yy-mm-dd)" });
});