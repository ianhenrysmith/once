var casper = require('casper').create();

casper.start('http://localhost:9191/', function() {
  // casper.viewport(1280, 800);
  
  // should clear test user posts here
  
  this.click('.sign_in_btn');
});

casper.then(function() {
  this.fill("form#new_user", {
    "user[email]": "hazdrubal@carth.age",
    "user[password]": "elephants"
  }, true);
});

casper.then(function() {
  this.click("#create_btn");
});

casper.then(function() {
  // create text post
  this.fill("#new-post", {
    "title": "Scipio Africanus? More like 'Scipio Africantus'",
    "content": 'Scipio couldnt even find the Ebro with two hands.',
    "description": 'Baecula was total BS. Bad officiating.'
  });
  
  this.click(".submit_create_post");
  
});

casper.then(function() {
  // this.captureSelector('smoo.png', 'body');
  
  // inspect new post
  this.test.assertTextExists("Scipio Africanus? More like 'Scipio Africantus'", "page has title");
  this.test.assertTextExists('Scipio couldnt even find the Ebro with two hands.', "page has content");
  this.test.assertTextExists('Baecula was total BS. Bad officiating.', "page has description");
  this.click(".like_btn")

});

casper.then(function() {
  this.test.assertTextExists('LIKED', "like created");
})

// click 'edit'
// make edit
// go to posts index next
// click 'my posts'
// make sure page displays user
// make sure edited text is there
// go to 'You' tab
// make sure post is in recent posts and likes

casper.run(function() {
  this.exit();
});