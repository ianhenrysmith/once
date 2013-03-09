describe("Once.Views.Posts.BaseView", function() {
  beforeEach(function() {
    view = new Once.Views.Posts.BaseView();
  });
  
  it('should be defined', function() {
    expect(Once.Views.Posts.BaseView).not.toBeNull();
  });
  
  it('can be instantiated', function() {
    expect(view).not.toBeNull();
  });
  
  it("can instantiate PostsHelper", function() {
    expect( view.h() ).toBeDefined;
  });
  
  //# what to test?
  //#   probably need an integration test here
});