require 'rails_helper'

RSpec.describe "trip", :type => :request do
  it "It returns newly created trip" do
    Transfer.create({name: "Clissa"})
    post "/api/v1/transfers/1/trips", params: {departure_time: '10/01/1993',
                                               arrival_time: '11/01/1993',
                                               number_of_tickets: 2
    }

    @expected_response = {"id" => 1, "transfer_id" => 1, "departure_time" => "1993-01-10T00:00:00.000Z", "arrival_time" => "1993-01-11T00:00:00.000Z", "number_of_tickets" => 2}

    assert_equal(response.status, 201)
    assert_equal(@expected_response, JSON.parse(response.body))
  end

  it "It returns error parameters missing" do
    Transfer.create({name: "Clissa"})
    post "/api/v1/transfers/1/trips", params: {
        arrival_time: '11/01/1993',
        number_of_tickets: 2
    }

    @expected_response = {"departure_time" => [" is missing!"]}

    assert_equal(response.status, 400)
    assert_equal(@expected_response, JSON.parse(response.body))


    post "/api/v1/transfers/1/trips", params: {
        departure_time: '10/01/1993',
        number_of_tickets: 2
    }

    @expected_response = {"arrival_time" => [" is missing!"]}

    assert_equal(response.status, 400)
    assert_equal(@expected_response, JSON.parse(response.body))


    post "/api/v1/transfers/1/trips", params: {
        departure_time: '10/01/1993',
        arrival_time: '11/01/1993',
    }

    @expected_response = {"number_of_tickets" => [" is missing!"]}

    assert_equal(response.status, 400)
    assert_equal(@expected_response, JSON.parse(response.body))
  end

  it "It returns error if there is no transfer with that ID" do
    expect {
      post "/api/v1/transfers/1/trips", params: {departure_time: '10/01/1993',
                                                 arrival_time: '11/01/1993',
                                                 number_of_tickets: 2
      }}.to raise_error(ActiveRecord::RecordNotFound)

  end

  it "It throws an error if departure date is later than arrival date" do
    Transfer.create({name: "Clissa"})
    post "/api/v1/transfers/1/trips", params: {departure_time: '20/01/1993',
                                               arrival_time: '11/01/1993',
                                               number_of_tickets: 2
    }

    @expected_response = {"errors" => {"departure_time" => ["Departure date and time should be before arrival date and time"]}}


    assert_equal(response.status, 400)
    assert_equal(@expected_response, JSON.parse(response.body))
  end
end


