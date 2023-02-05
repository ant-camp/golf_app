# frozen_string_literal: true

class CreateBookings < ActiveRecord::Migration[6.1]
  def change
    create_table :bookings do |t|
      t.datetime :start_time
      t.datetime :end_time
      t.string :name
      t.string :phone_number

      t.timestamps
    end
  end
end
