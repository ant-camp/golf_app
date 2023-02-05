# frozen_string_literal: true

Rails.application.routes.draw do
  resources :bookings do
    get :todays_bookings, on: :collection
  end
end
