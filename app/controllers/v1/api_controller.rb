# frozen_string_literal: true

class V1::ApiController < ApplicationController
  include Consul::Controller

  before_action :set_locale
  layout :products_layout
  
  attr_reader :current_user

  # Set Power and inject it with current user
  current_power do
    Power.new(current_user, params)
  end
  require_power_check
# called before every action on controllers


end
