require 'date'

require_relative 'spec_helper'

describe "hotel_manager initalize" do 
  it "raises an error if a hotel has more than 20 rooms" do 
    expect {hotel = Booking::Hotel_Manager.new(21)}.must_raise ArgumentError
  end
end

describe "@all_rooms variable" do
  it "provides a list of all rooms in the hotel" do
    hotel = Booking::Hotel_Manager.new(5)

    expect(hotel.all_rooms).must_be_kind_of Array
    expect(hotel.all_rooms[4]).must_equal 5
  end
end

describe "add_reservation method" do
  before do
    @checkin_date = Date.new(2019,1,4)
    @checkout_date = Date.new(2019,1,7)
    @hotel = Booking::Hotel_Manager.new(4)
  end

  it "adds the Reservation to a list of reservations" do
    @hotel.add_reservation(@checkin_date, @checkout_date)
    expect(@hotel.all_reservations.length).must_equal 1
  end
end

describe "reservation_by_date" do 
  before do
    @checkin_date = Date.new(2019,1,4)
    @checkout_date = Date.new(2019,1,7)
    @hotel = Booking::Hotel_Manager.new(4)
    
    @checkin_date2 = Date.new(2019,1,4)
    @checkout_date2 = Date.new(2019,1,8)
    
  end
  it "allows you to look up reservations by a specific date" do 
    @hotel.add_reservation(@checkin_date2, @checkout_date2)
    @hotel.add_reservation(@checkin_date, @checkout_date)

    check = @hotel.reservations_by_date(@checkin_date)
    expect(check[0]).must_be_kind_of Booking::Reservation
    expect(check.length).must_equal 2
    expect(check[0].checkin_date).must_equal @checkin_date
  end
end

describe "check_availability method" do
  before do
    @hotel = Booking::Hotel_Manager.new(5)
    @checkin_date = Date.new(2019,1,4)
    @checkout_date = Date.new(2019,1,7)
    
    @reservation = @hotel.add_reservation(@checkin_date, @checkout_date)

    @checkin_date2 = Date.new(2019,1,4)
    @checkout_date2 = Date.new(2019,1,7)
    
    @reservation2 = @hotel.add_reservation(@checkin_date2, @checkout_date2)
  end

  it "checks if booked room number is included in array available rooms" do
    
    availability = @hotel.check_availability(@checkin_date, @checkout_date)

    
    expect(availability.length).must_equal 3
    expect(availability).wont_include 2
  end

  it "returns a list of available rooms" do
    availability = @hotel.check_availability(@checkin_date, @checkout_date)
    expect(availability).must_be_kind_of Array
  end

  it "expects that the room can't be double-booked" do 
    expect(@reservation.room_number).wont_equal @reservation2.room_number
  end

  it "raises an error if there are no available rooms for that date" do
    @checkin_date3 = Date.new(2019,1,4)
    @checkout_date3 = Date.new(2019,1,7)

    @checkin_date4 = Date.new(2019,1,4)
    @checkout_date4 = Date.new(2019,1,7)

    @checkin_date5 = Date.new(2019,1,4)
    @checkout_date5 = Date.new(2019,1,7)

    @checkin_date6 = Date.new(2019,1,4)
    @checkout_date6 = Date.new(2019,1,7)

    

    @reservation3 = @hotel.add_reservation(@checkin_date3, @checkout_date3)
    @reservation4 = @hotel.add_reservation(@checkin_date4, @checkout_date4)
    @reservation5 = @hotel.add_reservation(@checkin_date5, @checkout_date5)

    expect{@hotel.check_availability(@checkin_date5, @checkout_date5)}.must_raise ArgumentError
  end

  it "allows a room to be reserved on a previous reservation's checkout date" do
    @checkin_date5 = Date.new(2019,1,7)
    @checkout_date5 = Date.new(2019,1,9)

    @reservation5 = @hotel.add_reservation(@checkin_date5, @checkout_date5)
    expect(@reservation5).must_be_kind_of Booking::Reservation
  end

end

