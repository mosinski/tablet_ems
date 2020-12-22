function logOut() {
  showRootMenu();
  $('html, body').css('display', 'none');
  $.post('http://tablet_ems/NUIFocusOff', JSON.stringify({}));
}

function exit() {
  $('html, body').css('display', 'none');
  $.post('http://tablet_ems/NUIFocusOff', JSON.stringify({}));
}
