require 'rails_helper'

RSpec.describe "registration", :type => :request do
  it "It returns 201 with new user created after successful registration" do
    post "/api/v1/register", params: {user: {name: "ivan",
                                             surname: "matas",
                                             email: "ivan.matas2@gmail.com",
                                             password: "secret",
                                             password_confirmation: "secret"}
    }

    @expected_user_json = {"id" => 1, "name" => "ivan", "surname" => "matas", "email" => "ivan.matas2@gmail.com"}
    assert_equal(response.status, 201)
    assert_equal(JSON.parse(response.body), @expected_user_json)
  end

  it "It raises param error if parameters are not sent" do
    expect {
      post "/api/v1/register", params: {user: {}}
    }.to raise_error(ActionController::ParameterMissing)
  end

  it "It returns 400 with error messages if name is not sent as a param" do
    post "/api/v1/register", params: {user: {
        surname: "matas",
        email: "ivan.matas2@gmail.com",
        password: "secret",
        password_confirmation: "secret"}
    }

    @expected_response = {"message" => {"name" => ["can't be blank", "is too short (minimum is 2 characters)"]}}
    assert_equal(response.status, 400)
    assert_equal(JSON.parse(response.body), @expected_response)
  end

  it "It returns 400 with error message if surname is not sent as a param" do
    post "/api/v1/register", params: {user: {name: "ivan",
                                             email: "ivan.matas2@gmail.com",
                                             password: "secret",
                                             password_confirmation: "secret"}
    }

    @expected_response = {"message" => {"surname" => ["can't be blank"]}}
    assert_equal(response.status, 400)
    assert_equal(JSON.parse(response.body), @expected_response)
  end

  it "It returns 400 with error message if email is not sent as a param" do
    post "/api/v1/register", params: {user: {name: "ivan",
                                             surname: "matas",
                                             password: "secret",
                                             password_confirmation: "secret"}
    }

    @expected_response = {"message" => {"email" => ["can't be blank"]}}
    assert_equal(response.status, 400)
    assert_equal(JSON.parse(response.body), @expected_response)
  end

  it "It returns 400 with error message if password is not sent as a param" do
    post "/api/v1/register", params: {user: {name: "ivan",
                                             surname: "matas",
                                             email: "ivan.matas2@gmail.com",
                                             password_confirmation: "secret"}
    }

    @expected_response = {"message" => {"password" => ["can't be blank"]}}
    assert_equal(response.status, 400)
    assert_equal(JSON.parse(response.body), @expected_response)
  end

  it "It returns 400 with error message if email is taken" do
    post "/api/v1/register", params: {user: {name: "ivan",
                                             surname: "matas",
                                             email: "ivan.matas2@gmail.com",
                                             password: "secret",
                                             password_confirmation: "secret"}
    }

    @expected_user_json = {"id" => 1, "name" => "ivan", "surname" => "matas", "email" => "ivan.matas2@gmail.com"}
    assert_equal(response.status, 201)
    assert_equal(JSON.parse(response.body), @expected_user_json)

    post "/api/v1/register", params: {user: {name: "ivan",
                                             surname: "matas",
                                             email: "ivan.matas2@gmail.com",
                                             password: "secret",
                                             password_confirmation: "secret"}
    }

    @expected_response = {"message" => {"email" => ["has already been taken"]}}


    assert_equal(response.status, 400)
    assert_equal(JSON.parse(response.body), @expected_response)
  end
end
