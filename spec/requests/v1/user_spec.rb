require 'rails_helper'

RSpec.describe "my_profile", :type => :request do
  it "It returns my personal information" do
    user = User.create!(:name => "ivan", :surname => "matas",
                        :email => "ivan.matas2@gmail.com", :password => "secret", :password_confirmation => "secret")

    post "/api/v1/login", params: {email: "ivan.matas2@gmail.com", password: "secret"}
    @token = JSON.parse(response.body).values.first

    get "/api/v1/my-profile", params: {}, headers: {"Authorization" => @token}

    @expected_response = {"id" => 1, "name" => "ivan", "surname" => "matas", "email" => "ivan.matas2@gmail.com"}

    assert_equal(response.status, 200)
    assert_equal(@expected_response, JSON.parse(response.body))
  end

  it "It returns unauthorized without proper headers" do

    get "/api/v1/my-profile", params: {}, headers: {}

    @expected_response = {"error" => "Not Authorized"}

    assert_equal(response.status, 401)
    assert_equal(@expected_response, JSON.parse(response.body))
  end
end
