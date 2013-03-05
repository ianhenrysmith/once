describe("Once.Helpers.PostsHelper", function() {
  beforeEach(function() {
    view = new Once.Views.Posts.BaseView();
  });
  
  it('should be defined', function() {
    expect(Once.Views.Posts.BaseView).not.toBeNull();
  });
  
  it('can be instantiated', function() {
    expect(view).not.toBeNull();
  });
  
  //# what to test?
  //#   probably need an integration test here
});