# frozen_string_literal: true

FactoryBot.define do
  factory :booking do
    start_time { '10:30' }
    end_time { '11:00' }
    name { 'anthony' }
    phone_number { '561-555-5555' }
  end
end
