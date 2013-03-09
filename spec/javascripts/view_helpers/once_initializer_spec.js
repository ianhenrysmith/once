describe("Once.Initializer", function() {
  beforeEach(function() {
    init = new Once.Initializer();
    user = {
      id: "777",
      name: "Admiral Ackbar",
      asset_url: "http://ianhenrysmith.com/smoo.png"
    };
  });
  
  it('can be instantiated', function() {
    expect(init).not.toBeNull();
  });
  
  it("sets current_user", function() {
    init.set_current_user(user);
    
    expect(Once.CurrentUser).not.toBeNull();
    expect(Once.CurrentUser.id).toBe("777");
    expect(Once.CurrentUser.name).toBe("Admiral Ackbar");
    expect(Once.CurrentUser.asset_url).toBe("http://ianhenrysmith.com/smoo.png");
  });
});