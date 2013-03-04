describe("Once.Models.Post", function() {
  beforeEach(function() {
    post = new Once.Models.Post({
      content: "Nuh uh.",
      title: "Dikembe Mutombo"
    });
  });
  
  it('should be defined', function() {
    expect(Once.Models.Post).toBeDefined();
  });
  
  it('can be instantiated', function() {
    expect(post).not.toBeNull();
  });
  
  it("should have text as default type", function() {
    expect(post.get("type")).toEqual("text");
  });

  it("should have a title and content", function() {
    expect(post.get("title")).toEqual("Dikembe Mutombo");
    expect(post.get("content")).toEqual("Nuh uh.");
  });
});