# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Booking, type: :model do
  describe 'scopes' do
    describe '.today' do
      let!(:today_booking) { create(:booking, created_at: Time.zone.today) }

      it 'returns bookings created today' do
        expect(described_class.today).to include(today_booking)
      end
    end

    describe '.in_order' do
      let!(:first_booking) { create(:booking, start_time: '11:00', end_time: '11:30') }
      let!(:second_booking) { create(:booking, start_time: '13:00', end_time: '13:30') }

      it 'returns bookings ordered by start time' do
        expect(described_class.in_order).to eq([first_booking, second_booking])
      end
    end
  end

  describe '#available_times' do
    let!(:booking) { create(:booking) }

    it 'returns a list of available times for bookings' do
      expect(described_class.available_times).not_to include(booking.start_time.strftime('%I:%M %p'))
    end
  end

  describe '#within_time_range' do
    let(:booking) { build(:booking, start_time: start_time, end_time: end_time) }

    context 'when start time and end time are within the range' do
      let(:start_time) { Time.zone.today + 8.hours }
      let(:end_time) { Time.zone.today + 9.hours }

      it 'does not add an error' do
        booking.valid?
        expect(booking.errors[:start_time]).to be_empty
      end
    end

    context 'when start time and end time are not within the range' do
      let(:start_time) { Time.zone.today + 7.hours }
      let(:end_time) { Time.zone.today + 17.hours }

      it 'adds an error' do
        booking.valid?
        expect(booking.errors[:start_time]).to include('Not within the range')
      end
    end
  end

  describe '#within_30_minutes?' do
    let(:booking) { build(:booking) }

    context 'when the time difference between start_time and end_time is less than or equal to 30 minutes' do
      it 'does not add an error to the end_time attribute' do
        booking.end_time = booking.start_time + 15.minutes
        booking.valid?
        expect(booking.errors[:end_time]).to be_empty
      end
    end

    context 'when the time difference between start_time and end_time is greater than 30 minutes' do
      it 'adds an error to the end_time attribute' do
        booking.end_time = booking.start_time + 45.minutes
        booking.valid?
        expect(booking.errors[:end_time]).to include('Time range cannot be more than 30 minutes')
      end
    end
  end

  describe '#overlapping_booking?' do
    let(:booking) { build(:booking) }

    context 'when there is no existing booking with the same start_time and end_time' do
      it 'does not add an error to the booking attribute' do
        booking.valid?
        expect(booking.errors[:booking]).to be_empty
      end
    end

    context 'when there is an existing booking with the same start_time and end_time' do
      it 'adds an error to the booking attribute' do
        create(:booking, start_time: booking.start_time, end_time: booking.end_time)
        booking.valid?
        expect(booking.errors[:booking]).to include('Timeslot not available')
      end
    end
  end
end
