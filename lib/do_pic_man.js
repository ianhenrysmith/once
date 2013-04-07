// want to clean this up, return a success response.
//  probably have to validate url.
//  have to resize phantom cause it's too smalllll.

var page = require('webpage').create(),
  system = require('system'),
  url, post_id;

url = system.args[1];
post_id = system.args[2];
console.log("taking pic of " + url + "for post " + post_id);

page.viewportSize = { width: 1024, height: 600 };
page.open(url, function () {
  window.setTimeout(function () {
    
    page.clipRect = { top: 0, left: 0, width: 1024, height: 600 };
    page.render('public/uploads/tmp/' + post_id + '_capture.png');
    phantom.exit();
  }, 400);
});

console.log("took pic! good jorb!");