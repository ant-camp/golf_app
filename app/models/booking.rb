# frozen_string_literal: true

class Booking < ApplicationRecord
  validates :name, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true
  validates :phone_number, presence: true

  scope :today, -> { where('created_at >= ?', Time.zone.today.beginning_of_day) }
  scope :in_order, -> { order(start_time: :asc) }

  validate :within_30_minutes?, on: :create
  validate :within_time_range, on: :create
  validate :overlapping_booking?, on: :create

  def self.available_times
    # Set the start time to 8AM
    start_time = Time.zone.today.beginning_of_day + 8.hours
    # Set the stop time to 3:30pm
    end_time = Time.zone.today.beginning_of_day + 15.hours + 30.minutes

    times = []
    while start_time <= end_time
      times << start_time.strftime('%I:%M %p') unless Booking.exists?(start_time: start_time)
      start_time += 30.minutes
    end
    times
  end

  private

  def within_time_range
    time_range = (8..16)
    return if time_range.include?(start_time.hour) && time_range.include?(end_time.hour)

    errors.add(:start_time, 'Not within the range')
  end

  def within_30_minutes?
    difference = (end_time - start_time) / 60
    return unless difference > 30

    errors.add(:end_time, 'Time range cannot be more than 30 minutes')
  end

  def overlapping_booking?
    return unless Booking.exists?(start_time: start_time, end_time: end_time)

    errors.add(:booking, 'Timeslot not available')
  end
end
