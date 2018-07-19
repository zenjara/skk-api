require 'rails_helper'

RSpec.describe "transfer", :type => :request do
  it "It returns newly created transfer" do
    post "/api/v1/transfers", params: {name: 'clissa'}

    assert_equal(response.status, 201)
    assert_equal("transfer", JSON.parse(response.body).keys.first)
    assert_equal("clissa", JSON.parse(response.body)["transfer"]["name"])
  end

  it "It returns error if name is not sent" do
    expect {
      post "/api/v1/transfers", params: {}
    }.to raise_error(ActionController::ParameterMissing)
  end

  it "It returns error if name already taken" do
    post "/api/v1/transfers", params: {name: 'clissa'}

    assert_equal(response.status, 201)

    post "/api/v1/transfers", params: {name: 'clissa'}
    @expected_response = {"errors" => {"name" => ["has already been taken"]}}

    assert_equal(response.status, 400)
    assert_equal(@expected_response, JSON.parse(response.body))
  end
end
