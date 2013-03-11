var casper = require('casper').create();

casper.start('http://localhost:9191/', function() {
  // clear test user here...
  this.test.assertTextExists('OnceThis is for the things you love.', 'page body contains summary text');
  this.click('.registration_btn');
});

casper.then(function() {
  // create new user
  this.test.assertTextExists('Sign up', 'page body contains "sign up"');
  this.fill("form#new_user", {
    "user[email]": "elrond.hubbard@science.man",
    "user[password]": "spaaace",
    "user[password_confirmation]": "spaaace"
  }, true);
});

casper.then(function() {
  // sign out
  this.test.assertTextExists('Sign out', 'page body contains sign out link');
  this.click('.sign_out_btn');
});

casper.then(function() {
  this.test.assertTextExists('OnceThis is for the things you love.', 'page body contains summary text');
  this.click('.sign_in_btn');
});

casper.then(function() {
  // sign in
  this.fill("form#new_user", {
    "user[email]": "elrond.hubbard@science.man",
    "user[password]": "spaaace",
  }, true);
});

casper.run(function() {
  this.test.assertTextExists('Sign out', 'page body contains sign out link');
  this.exit();
});
