# frozen_string_literal: true

class BookingsController < ApplicationController
  before_action :set_booking, only: %i[show destroy]

  # GET /bookings
  def index
    @bookings = Booking.available_times

    render json: @bookings
  end

  # GET /bookings/todays_bookings
  def todays_bookings
    @bookings = Booking.today.in_order

    render json: @bookings
  end

  # GET /bookings/1
  def show
    render json: @booking
  end

  # POST /bookings
  def create
    @booking = Booking.new(booking_params)

    if @booking.save
      render json: @booking, status: :created, location: @booking
    else
      render json: @booking.errors, status: :unprocessable_entity
    end
  end

  # DELETE /bookings/1
  def destroy
    @booking.destroy
    render json: 'Booking was removed'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_booking
    @booking = Booking.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def booking_params
    params.require(:booking).permit(:start_time, :end_time, :name, :phone_number)
  end
end
