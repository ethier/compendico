class PricingController < ApplicationController
  def index
    @plans = Compendico::Plan.publicly_available
  end
end
