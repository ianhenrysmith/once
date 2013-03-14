var casper = require('casper').create({});

casper.start('http://localhost:9191/', function() {
  casper.viewport(1280, 800);
  console.log("don't forget to start server on port 9191")
  this.click('.sign_in_btn');
});

casper.evaluate(function() {
  // should clear test user posts here
  
  // THIS DOESNT WORK YET
  //  maybe should have a link you can visit that clears test posts
  sendAJAX("/ajax/send_action", 'POST', {class: "Post", resource_action: "clear_test_posts"}, false);
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
  this.click("#like_btn")
});

casper.then(function() {
  this.test.assertTextExists('LIKED', "like created");
  this.click("#edit_btn");
})

casper.then(function() {
  // make edit
  this.fill("#edit-post", {
    "title": "Elephants are big",
    "content": 'They can really stomp around',
    "description": 'I like them a lot.'
  });
  
  this.click(".submit_edit_post");
});

casper.then(function() {
  // inspect edited post
  // maybe should visit post url to ensure that I'm not testing index
  this.test.assertTextExists("Elephants are big", "edited page has title");
  this.test.assertTextExists('They can really stomp around', "edited page has content");
  this.test.assertTextExists('I like them a lot.', "edited page has description");
  this.test.assertTextExists('LIKED', "edited post still has like");
  this.click("#close_btn");
});

casper.then(function() {
  // inspect posts index
  // should test that page doesn't have post show panel
  this.test.assertTextExists("Elephants are big", "index page has title");
  this.test.assertTextExists('They can really stomp around', "index page has content");
  this.test.assertTextExists('I like them a lot.', "index page has description");
  
  this.test.assertEval(function() {
    casper.test.info($("#post_pane"));
    casper.test.info($("#post_pane").length);

    return $("#post_pane").width() == 0;
  }, 'post show panel is closed');
  // this.test.assertTextDoesntExist('LIKED', "post show panel is closed, ergo like btn isnt visible");
});


// go to posts index next
// click 'my posts'
// make sure page displays user
// go to 'You' tab
// make sure post is in recent posts and likes

casper.run(function() {
  this.exit();
});