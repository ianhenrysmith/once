// want to clean this up, return a success response.
//  probably have to validate url.
//  have to resize phantom cause it's too smalllll.

var page = require('webpage').create(),
    system = require('system'),
    url, post_id;

url = system.args[1];
post_id = system.args[2];
console.log("taking pic of " + url + "for post " + post_id);

page.open(url, function () {
    page.render('public/uploads/tmp/' + post_id + '_capture.png');
    phantom.exit();
});

console.log("took pic! good jorb!");