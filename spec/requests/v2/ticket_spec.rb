require 'rails_helper'

RSpec.describe "buying_ticket_v2", :type => :request do
  it "Ticket successful purchase" do
    create_and_login_user
    generate_tickets

    post "/api/v2/trips/1/tickets/buy", params: {credit_card: '1' * 16}, headers: {"Authorization" => @token}

    @expected_response = {"message" => "Ticket purchase successful!"}

    assert_equal(response.status, 201)
    assert_equal(@expected_response, JSON.parse(response.body))
  end

  it "Ticket successful purchase with guest user" do
    generate_tickets

    post "/api/v2/trips/1/tickets/buy", params: {credit_card: '1' * 16,
                                                 name: 'ivan',
                                                 surname: 'matas',
                                                 email: 'ivan.matas2@gmail.com',
    }

    @expected_response = {"message" => "Ticket purchase successful!"}

    assert_equal(response.status, 201)
    assert_equal(@expected_response, JSON.parse(response.body))
  end

  it "Throws param errors if missing" do
    create_and_login_user
    generate_tickets

    expect {
      post "/api/v2/trips/1/tickets/buy", params: {}, headers: {"Authorization" => @token}
    }.to raise_error(ActionController::ParameterMissing)
  end

  it "Throws param errors if missing for guest users" do
    generate_tickets

    expect {
      post "/api/v2/trips/1/tickets/buy", params: {}
    }.to raise_error(ActionController::ParameterMissing)
  end

  it "Throws errors if credit card info not valid" do
    create_and_login_user
    generate_tickets

    post "/api/v2/trips/1/tickets/buy", params: {credit_card: '1'}, headers: {"Authorization" => @token}

    @expected_response = {"credit_card" => ["Credit card number length invalid!"]}

    assert_equal(response.status, 400)
    assert_equal(@expected_response, JSON.parse(response.body))
  end

  it "Throws errors if credit card info not valid for guest user" do
    generate_tickets

    post "/api/v2/trips/1/tickets/buy", params: {credit_card: '1',
                                                 name: 'ivan',
                                                 surname: 'matas',
                                                 email: 'ivan.matas2@gmail.com',
    }

    @expected_response = {"credit_card" => ["Credit card number length invalid!"]}

    assert_equal(response.status, 400)
    assert_equal(@expected_response, JSON.parse(response.body))
  end

  it "Throws an error if no tickets are available" do
    create_and_login_user

    Transfer.create({name: "Clissa"})
    post "/api/v1/transfers/1/trips", params: {departure_time: '10/01/1993',
                                               arrival_time: '11/01/1993',
                                               number_of_tickets: 1
    }

    post "/api/v2/trips/1/tickets/buy", params: {credit_card: '1' * 16, }, headers: {"Authorization" => @token}

    @expected_response = {"credit_card" => ["Credit card number length invalid!"]}

    assert_equal(response.status, 201)

    post "/api/v2/trips/1/tickets/buy", params: {credit_card: '1' * 16, }, headers: {"Authorization" => @token}

    @expected_response = {"message" => "No tickets available for this trip!"}

    assert_equal(response.status, 400)
    assert_equal(@expected_response, JSON.parse(response.body))
  end

  it "Throws an error if no tickets are available for guest user" do
    Transfer.create({name: "Clissa"})
    post "/api/v1/transfers/1/trips", params: {departure_time: '10/01/1993',
                                               arrival_time: '11/01/1993',
                                               number_of_tickets: 1
    }

    post "/api/v2/trips/1/tickets/buy", params: {credit_card: '1' * 16,
                                                 name: 'ivan',
                                                 surname: 'matas',
                                                 email: 'ivan.matas2@gmail.com',
    }

    @expected_response = {"credit_card" => ["Credit card number length invalid!"]}

    assert_equal(response.status, 201)

    post "/api/v2/trips/1/tickets/buy", params: {credit_card: '1' * 16,
                                                 name: 'ivan',
                                                 surname: 'matas',
                                                 email: 'ivan.matas2@gmail.com',
    }

    @expected_response = {"message" => "No tickets available for this trip!"}

    assert_equal(response.status, 400)
    assert_equal(@expected_response, JSON.parse(response.body))
  end
end


private

def create_and_login_user
  User.create!(:name => "ivan", :surname => "matas",
               :email => "ivan.matas2@gmail.com", :password => "secret",
               :password_confirmation => "secret")


  post "/api/v1/login", params: {email: "ivan.matas2@gmail.com", password: "secret"}
  @token = JSON.parse(response.body).values.first

end

def generate_tickets
  Transfer.create({name: "Clissa"})
  post "/api/v1/transfers/1/trips", params: {departure_time: '10/01/1993',
                                             arrival_time: '11/01/1993',
                                             number_of_tickets: 2
  }
end