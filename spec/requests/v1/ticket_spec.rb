require 'rails_helper'

RSpec.describe "generating_ticket", :type => :request do
  it "It generates new tickets on trip creation" do
    Transfer.create({name: "Clissa"})
    @tickets_before = Ticket.all.count
    @num_of_tickets = 2
    post "/api/v1/transfers/1/trips", params: {departure_time: '10/01/1993',
                                               arrival_time: '11/01/1993',
                                               number_of_tickets: @num_of_tickets
    }

    @tickets_after = Ticket.all.count

    assert_equal(@tickets_after, @tickets_before + @num_of_tickets)
  end
end

RSpec.describe "buying_ticket", :type => :request do
  it "Ticket successful purchase" do
    create_and_login_user
    generate_tickets

    post "/api/v1/trips/1/tickets/buy", params: {credit_card: '1' * 16,
                                                 cvc: '1234'
    }, headers: {"Authorization" => @token}

    @expected_response = {"message" => "Ticket purchase successful!"}

    assert_equal(response.status, 201)
    assert_equal(@expected_response, JSON.parse(response.body))
  end

  it "Throws unauthorized" do
    generate_tickets

    post "/api/v1/trips/1/tickets/buy", params: {credit_card: '1' * 16,
                                                 cvc: '1234'
    }

    @expected_response = {"error" => "Not Authorized"}

    assert_equal(response.status, 401)
    assert_equal(@expected_response, JSON.parse(response.body))
  end

  it "Throws param errors if missing" do
    create_and_login_user
    generate_tickets

    expect {
      post "/api/v1/trips/1/tickets/buy", params: {credit_card: '1' * 16}, headers: {"Authorization" => @token}
    }.to raise_error(ActionController::ParameterMissing)

    expect {
      post "/api/v1/trips/1/tickets/buy", params: {cvc: '1234'}, headers: {"Authorization" => @token}
    }.to raise_error(ActionController::ParameterMissing)
  end

  it "Throws errors if credit card info not valid" do
    create_and_login_user
    generate_tickets

    post "/api/v1/trips/1/tickets/buy", params: {credit_card: '1',
                                                 cvc: '1234'
    }, headers: {"Authorization" => @token}

    @expected_response = {"credit_card" => ["Credit card number length invalid!"]}

    assert_equal(response.status, 400)
    assert_equal(@expected_response, JSON.parse(response.body))

    post "/api/v1/trips/1/tickets/buy", params: {credit_card: '1' * 16,
                                                 cvc: '1'
    }, headers: {"Authorization" => @token}

    @expected_response = {"cvc" => ["CVC length invalid!"]}


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

    post "/api/v1/trips/1/tickets/buy", params: {credit_card: '1' * 16,
                                                 cvc: '1234'
    }, headers: {"Authorization" => @token}

    @expected_response = {"credit_card" => ["Credit card number length invalid!"]}

    assert_equal(response.status, 201)

    post "/api/v1/trips/1/tickets/buy", params: {credit_card: '1' * 16,
                                                 cvc: '1234'
    }, headers: {"Authorization" => @token}

    @expected_response = {"message" => "No tickets available for this trip!"}

    assert_equal(response.status, 400)
    assert_equal(@expected_response, JSON.parse(response.body))
  end
end

RSpec.describe "fetching_bought_tickets", :type => :request do
  it "It returns list of logged in users tickets" do
    create_and_login_user
    Transfer.create({name: "Clissa"})
    post "/api/v1/transfers/1/trips", params: {departure_time: '10/01/1993',
                                               arrival_time: '11/01/1993',
                                               number_of_tickets: 2
    }

    post "/api/v1/trips/1/tickets/buy", params: {credit_card: '1' * 16,
                                                 cvc: '1234'
    }, headers: {"Authorization" => @token}

    assert_equal(response.status, 201)

    get "/api/v1/my-tickets", params: {credit_card: '1' * 16,
                                       cvc: '1234'
    }, headers: {"Authorization" => @token}

    @expected_response = [{"id" => 1, "barcode" => Ticket.find(1).barcode, "trip" => {"arrival_time" => "1993-01-11T00:00:00.000Z", "departure_time" => "1993-01-10T00:00:00.000Z"}}]

    assert_equal(response.status, 200)
    assert_equal(@expected_response, JSON.parse(response.body))

  end

  it "It returns 401 if headers not present" do
    create_and_login_user
    Transfer.create({name: "Clissa"})
    post "/api/v1/transfers/1/trips", params: {departure_time: '10/01/1993',
                                               arrival_time: '11/01/1993',
                                               number_of_tickets: 2
    }

    post "/api/v1/trips/1/tickets/buy", params: {credit_card: '1' * 16,
                                                 cvc: '1234'
    }, headers: {"Authorization" => @token}

    assert_equal(response.status, 201)

    get "/api/v1/my-tickets", params: {credit_card: '1' * 16,
                                       cvc: '1234'
    }

    @expected_response = {"error" => "Not Authorized"}

    assert_equal(response.status, 401)
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