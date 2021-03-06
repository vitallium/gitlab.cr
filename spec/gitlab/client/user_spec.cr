require "../../spec_helper"

describe Gitlab::Client::User do
  describe ".users" do
    it "should return a json data of users" do
      stub_get("/users", "users")
      users = client.users

      users.should be_a JSON::Any
      users[0]["email"].as_s.should eq "john@example.com"
    end
  end

  describe ".user" do
    context "with user ID passed" do
      it "should return a json data of user" do
        stub_get("/users/1", "user")
        user = client.user(1)

        user.should be_a JSON::Any
        user["email"].as_s.should eq "john@example.com"
      end
    end

    context "withount user ID passed" do
      it "should return a json data of user" do
        stub_get("/user", "user")
        user = client.user

        user.should be_a JSON::Any
        user["email"].as_s.should eq "john@example.com"
      end
    end
  end

  describe ".create_user" do
    context "when successful request" do
      it "should return information about a created user" do
        stub_post("/users", "user")

        user = client.create_user("email", "pass", "username")
        user["email"].as_s.should eq "john@example.com"
      end
    end

    context "when bad request" do
      it "should throw an exception" do
        WebMock.reset
        stub_post("/users", "error_already_exists", 409)

        expect_raises Gitlab::Error::Conflict, "Server responded with code 409, message: 409 Already exists. Request URI: #{client.endpoint}/users" do
          client.create_user("email", "pass", "username")
        end
      end
    end
  end

  describe ".edit_user" do
    it "should get the correct resource" do
      params = {"name" => "Roberto"}
      stub_put("/users/1", "user", params)
      user = client.edit_user(1, params)

      user["email"].as_s.should eq "john@example.com"
    end
  end

  describe ".delete_user" do
    it "should return information about a deleted user" do
      stub_delete("/users/1", "user")

      user = client.delete_user(1)
      user["email"].as_s.should eq "john@example.com"
    end
  end

  describe ".block_user" do
    it "should return boolean" do
      stub_put("/users/1/block", "user_block_unblock")

      result = client.block_user(1)
      result.as_bool.should be_true
    end
  end

  describe ".unblock_user" do
    it "should return boolean" do
      stub_put("/users/1/unblock", "user_block_unblock")

      result = client.unblock_user(1)
      result.as_bool.should be_true
    end
  end

  describe ".ssh_keys" do
    context "with user ID passed" do
      it "should return a paginated response of SSH keys" do
        stub_get("/users/1/keys", "keys")
        keys = client.ssh_keys(1)

        keys.should be_a JSON::Any
        keys[0]["title"].as_s.should eq "narkoz@helium"
      end
    end

    context "without user ID passed" do
      it "should return a paginated response of SSH keys" do
        stub_get("/user/keys", "keys")

        keys = client.ssh_keys
        keys.should be_a JSON::Any
        keys[0]["title"].as_s.should eq "narkoz@helium"
      end
    end
  end

  describe ".create_ssh_key" do
    it "should return information about a created SSH key" do
      stub_post("/user/keys", "key")
      key = client.create_ssh_key("title", "body")

      key["title"].as_s.should eq "narkoz@helium"
    end
  end

  describe ".delete_ssh_key" do
    it "should return information about a deleted SSH key" do
      stub_delete("/user/keys/1", "key")
      key = client.delete_ssh_key(1)

      key["title"].as_s.should eq "narkoz@helium"
    end
  end

  describe ".emails" do
    describe "without user ID" do
      it "should return a information about a emails of user" do
        stub_get("/user/emails", "user_emails")
        emails = client.emails

        emails[0]["id"].as_i.should eq 1
        emails[0]["email"].as_s.should eq "email@example.com"
      end
    end

    describe "with user ID" do
      it "should return a information about a emails of user" do
        stub_get("/users/2/emails", "user_emails")
        emails = client.emails(2)

        emails[0]["id"].as_i.should eq 1
        emails[0]["email"].as_s.should eq "email@example.com"
      end
    end
  end

  describe ".add_email" do
    describe "without user ID" do
      it "should return information about a new email" do
        stub_post("/user/emails", "user_email")
        email = client.add_email("email@example.com")

        email["id"].as_i.should eq 1
        email["email"].as_s.should eq "email@example.com"
      end
    end

    describe "with user ID" do
      it "should return information about a new email" do
        stub_post("/users/2/emails", "user_email")
        email = client.add_email(2, "email@example.com")

        email["id"].as_i.should eq 1
        email["email"].as_s.should eq "email@example.com"
      end
    end
  end

  describe ".delete_email" do
    describe "without user ID" do
      it "should return information about a deleted email" do
        stub_delete("/user/emails/1", "user_email")

        email = client.delete_email(1)
        email.should be_truthy
      end
    end

    describe "with user ID" do
      it "should return information about a deleted email" do
        stub_delete("/users/2/emails/1", "user_email")
        email = client.delete_email(1, 2)

        email.should be_truthy
      end
    end
  end

  describe ".user_search" do
    it "should return an array of users found" do
      stub_get("/users?search=User", "user_search")
      users = client.user_search("User")

      users[0]["id"].as_i.should eq(1)
      users[-1]["id"].as_i.should eq(2)
    end
  end
end
