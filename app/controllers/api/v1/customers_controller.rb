class Api::V1::CustomersController < ApplicationController
  before_action :authenticate_user
  before_action :authenticate_company
  
  def create
    company = current_user.company
    
    begin
      customer = Stripe::Customer.create(card: params[:card])
    rescue Stripe::StripeError => e
      company.errors[:base] << e.message
    end
    
    if customer && company.update(stripe_customer_id: customer.id)
      render status: 200, json: company
    else
      render status: 422, json: company.errors
    end
  end
end
