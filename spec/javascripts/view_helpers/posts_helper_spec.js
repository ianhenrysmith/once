describe("Once.Helpers.PostsHelper", function() {
  beforeEach(function() {
    helper = new Once.Helpers.PostsHelper();
    post = new Once.Models.Post({
      content: "No, no, no.",
      title: "Deke"
    });
  });
  
  it('can be instantiated', function() {
    expect(helper).not.toBeNull();
  });
  
  describe("preview", function() {
    it("text", function() {
      preview = helper.preview(post.toJSON());

      expect(preview).not.toBeNull();        
      expect(preview.match("<div class='inline_block'>").length).toEqual(1);
      expect(preview.match(post.get("content")).length).toEqual(1);
      expect(preview.match("</div>").length).toEqual(1);
    });
    
    it("a link", function() {
      post.set("type", "link");
      preview = helper.preview(post.toJSON());
      
      expect(preview).not.toBeNull();
      expect(preview.match("<div class='inline_block'>").length).toEqual(1);
      expect(preview.match(post.get("content")).length).toEqual(1);
      expect(preview.match("</div>").length).toEqual(1);
    });
    
    it("an image", function() {
      post.set("type", "image");
      preview = helper.preview(post.toJSON());

      expect(preview).not.toBeNull();
      expect(preview.match("<div class='inline_block'>").length).toEqual(1);
      expect(preview.match("<img class='preview_img' src='"+ post.get("content") +"'>").length).toEqual(1);
      expect(preview.match("</div>").length).toEqual(1);
    });
    
    it("a video", function() {
      post.set("type", "video");
      post.set("content", "http://www.youtube.com/watch?v=7CLd1oaVDlE")
      preview = helper.preview(post.toJSON());

      expect(preview).not.toBeNull();
      expect(preview.match("<div class='inline_block'>").length).toEqual(1);
      expect(preview.match("<iframe width='270' height='152' src='http://www.youtube.com/embed/7CLd1oaVDlE' frameborder='0' allowfullscreen='true'></iframe>").length).toEqual(1);
      expect(preview.match("</div>").length).toEqual(1);
    });
    
    it("a tweet", function() {
      post.set("type", "tweet");
      preview = helper.preview(post.toJSON());

      expect(preview).not.toBeNull();
      expect(preview.match("<div class='inline_block'>").length).toEqual(1);
      expect(preview.match("Tweet").length).toEqual(1);
      expect(preview.match("</div>").length).toEqual(1);
    });
    
    it("a quote", function() {
      post.set("type", "quote");
      preview = helper.preview(post.toJSON());

      expect(preview).not.toBeNull();
      expect(preview.match("<div class='inline_block'>").length).toEqual(1);
      expect(preview.match("<div class='preview_quote'>"+ post.get("content") +"</div>").length).toEqual(1);
      expect(preview.match(/\<\/div\>/g).length).toEqual(2);
    });
    
    it("an invalid type", function() {
      post.set("type", "smoo");
      preview = helper.preview(post.toJSON());

      expect(preview).not.toBeNull();
      expect(preview.match("<div class='inline_block'>").length).toEqual(1);
      expect(preview.match(post.get("content")).length).toEqual(1);
      expect(preview.match("</div>").length).toEqual(1);
    });
  }); //preview
  
  describe("dropdown", function() {
    // want a just values test here too
    it("can be created with custom class and id", function() {
      dropdown_options = {
        field: "coolpo",
        options: {
          class: "editably",
          id: "dd_shoop"
        },
        value: "roojoop",
        values: ["smoolfra", "roojoop", "yanakanak"]
      };
      dropdown = helper.dropdown(dropdown_options);

      expect(dropdown.match("<div class='dropdown editably' id='dd_shoop'>").length).toEqual(1);
      expect(dropdown.match("<input class='dropdown_target' id='coolpo' type='text' name='coolpo' value='roojoop'>").length).toEqual(1);
      expect(dropdown.match("<span class='dropdown-toggle'>roojoop</span>").length).toEqual(1);
      expect(dropdown.match("<ul class='dropdown-menu' role='menu'>").length).toEqual(1);
      expect(dropdown.match("<li class='dropdown_item' v='smoolfra'>smoolfra</li>").length).toEqual(1);
      expect(dropdown.match("<li class='dropdown_item' v='roojoop'>roojoop</li>").length).toEqual(1);
      expect(dropdown.match("<li class='dropdown_item' v='yanakanak'>yanakanak</li>").length).toEqual(1);
      expect(dropdown.match("</ul>").length).toEqual(1);
      expect(dropdown.match("</div>").length).toEqual(1);
    });
    
  }); // dropdown
  
  describe("avatar", function() {
    beforeEach( function() {
      avatar_url = "http://ianh.co/eio.png";
    });
    it("can be created with just an img url", function() {
      avatar = helper.avatar(avatar_url);

      expect(avatar).not.toBeNull();
      expect(avatar.match("<div class='avatar medium'").length).toEqual(1);
      expect(avatar.match("style='background-image: url").length).toEqual(1);
      expect(avatar.match("http:&#47;&#47;ianh.co&#47;eio.png").length).toEqual(1);
      expect(avatar.match("</div>").length).toEqual(1);
    });
    
    it("can be customized", function() {
      avatar = helper.avatar(avatar_url, "large", { class: "muchos_deliciosos" } );

      expect(avatar).not.toBeNull();
      expect(avatar.match("<div class='avatar large muchos_deliciosos'").length).toEqual(1);
    });
  }); // avatar
  
  describe("partial", function() {
    // this fn is implicitly tested in all of the other helper tests
    it('exists', function() {
      expect(helper.partial).not.toBeNull();
    });
  });
  describe("get and set", function() {
    beforeEach(function() {
      init = new Once.Initializer();
      user = {
        id: "888",
        name: "Jack Kerouac",
        asset_url: "http://smoo.org/yambo.png"
      };
      init.set_current_user(user);
    });
    
    it("current_user", function() {
      current_user = helper.current_user();
      
      expect(current_user).not.toBeNull();
      expect(current_user.id).toBe(Once.CurrentUser.id);
      expect(current_user.name).toBe(Once.CurrentUser.name);
      expect(current_user.asset_url).toBe(Once.CurrentUser.asset_url);
    }); // current_user
    
    it("user params", function() {
      initial = {boof: "smoo"}
      params = helper.augment_with_user_params(initial);
      console.log(params);
      expect(params).not.toBe(initial);
      expect(params.boof).toBe(initial.boof);
      expect(params.user_id).toBe(Once.CurrentUser.id);
      expect(params.creator_name).toBe(Once.CurrentUser.name);
      expect(params.creator_path).toBe("/users/" + Once.CurrentUser.id);
      expect(params.creator_avatar_url).toBe(Once.CurrentUser.asset_url);
    }); // augment_with_user_params
  });
  describe("add liked post", function() {
    it("adds post id to current user", function() {
      expect(true).toBe(false);
    });
  });
}); //posts helper