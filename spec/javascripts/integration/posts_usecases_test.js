var casper = require('casper').create();

casper.start('http://localhost:9191/', function() {
  this.click('.sign_in_btn');
});

casper.then(function() {
  this.fill("form#new_user", {
    "user[email]": "elrond.hubbard@science.man",
    "user[password]": "spaaace",
  }, true);
})