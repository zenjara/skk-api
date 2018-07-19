require 'rails_helper'

RSpec.describe "login", :type => :request do
  it "It returns token after successful login" do
    user = User.create!(:name => "ivan", :surname => "matas",
                        :email => "ivan.matas2@gmail.com", :password => "secret", :password_confirmation => "secret")

    post "/api/v1/login", params: {email: "ivan.matas2@gmail.com", password: "secret"}
    assert_equal(response.status, 200)
    assert_equal("auth_token", JSON.parse(response.body).keys.first)
    assert_instance_of(String, JSON.parse(response.body).values.first)
  end

  it "It returns a 401 error if email is not sent" do
    post "/api/v1/login", params: {password: "secret"}

    @expected_response = {"error" => {"user_authentication" => ["invalid credentials"]}}
    assert_equal(response.status, 401)
    assert_equal(@expected_response, JSON.parse(response.body))
  end

  it "It returns a 401 error if password is not sent" do
    post "/api/v1/login", params: {email: "ivan.matas2@gmail.com"}

    @expected_response = {"error" => {"user_authentication" => ["invalid credentials"]}}
    assert_equal(response.status, 401)
    assert_equal(@expected_response, JSON.parse(response.body))
  end
end



