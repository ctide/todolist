$(document).ready(function() {
  $.get('/todo_list', function(data) {
    data.forEach(function(elem) {
      displayRow(elem);
    });
    $('input.duedate').datepicker().on('changeDate', function(ev) {
      $(this).change();
      $(this).blur();
    });
    $('.tablesorter').tablesorter({ widgets: ['staticRow'], sortList: [[3, 0]], textExtraction: extractData });
  });

  $('tbody').on('click', '.checkmark', function() {
    completed($(this).parents('tr').attr('id'));
  }).on('change', 'input.duedate,input.update-task,select.priority', function() {
    modifyField(this);
  }).on('click', '.valid-row td', function() {
    $('.edit').removeClass('edit');
    $(this).toggleClass('edit');
    $('.datepicker.dropdown-menu').hide();
    $(this).find('input').focus();
    return false;
  }).on('blur', 'input,select', function() {
    $('.datepicker.dropdown-menu').hide();
    $('.edit').toggleClass('edit');
  });

  $('body').click(function() {
    $('.edit').toggleClass('edit');
    $('.datepicker.dropdown-menu').hide();
  });

  $('.new-task').on('change', function() {
    $('.new-row input').attr('disabled', 'true');
    $.post('/entries', { 'entry' : {'task' : $('.new-task').val()} }, function(data) {
      displayRow(data);
      $('.new-row input').val('')
      $('.new-row input').attr('disabled', 'false');
    });
  });
});

function displayRow(data) {
  $new = $('.template').clone();
  $new.attr('id', data.id);
  $('tbody').append($new);
  $new.find('.task .contents').html(data.task);
  $new.find('.task .update-task').val(data.task);
  if (data.due_date) {
    var due_date = formatDate(new Date(data.due_date));
    $new.find('.duedate .contents').html(due_date);
    $new.find('.datepicker').data('date', due_date);
    $new.find('input.duedate').val(due_date);
  }
  if (data.priority) {
    $new.find('.priority select').val(data.priority);
    $new.find('.priority .contents').html(data.priority);
  }
  $('#' + data.id).removeClass('template');
  $new.removeClass('template').addClass('valid-row');
}

function completed(row) {
  $.ajax({
    url :'/entries/' + row,
    type: 'PUT',
    data: { 'entry' : {'completed' : true }}
  }).done(function(data) {
    $('#' + row).fadeOut();
  });
}

function modifyField(field) {
  var row = $(field).parents('tr').attr('id');
  var post = { 'entry' : {} }
  post['entry'][$(field).data('field')] = $(field).val();
  if ($(field).data('field') == 'due_date') {
    post['entry'][$(field).data('field')] = new Date($(field).val());
  }
  $.ajax({
    url: '/entries/' + row,
    type: 'PUT',
    data: post
  }).done(function(data) {
    $(field).siblings('.contents').html($(field).val());
  });
}

function formatDate(date) {
  var due_date = '';
  var month = date.getMonth() + 1;
  if (month < 10) {
    due_date = '0' + month;
  } else {
    due_date = month;
  }
  due_date += "/";
  var day = date.getDate();
  if (day < 10) {
    due_date += "0" + day;
  } else {
    due_date += day;
  }
  due_date += "/" + date.getFullYear();
  return due_date;
}

function extractData(node) {
  if ($(node).hasClass('priority')) {
    switch ($(node).children('.contents').text()) {
      case "New":
        return -1;
      case "High":
        return 0;
      case "Medium":
        return 1;
      case "Low":
        return 2;
      default:
        return 3;
    }
  } else {
    return $(node).children('.contents').text();
  }
}
