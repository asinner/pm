class Api::V1::SubscriptionsController < ApplicationController
  before_action :authenticate_user
  before_action :authenticate_company
  
  def create
    company = current_user.company
    
    begin
      customer = Stripe::Customer.retrieve(params[:customer][:id])      
      subscription = customer.subscriptions.create(plan: params[:plan])
    rescue Stripe::StripeError => e
      company.errors[:base] << e.message
    end
      
    if subscription && company.update(
        stripe_subscription_id: subscription.id,
        stripe_plan_id: subscription.plan.id,
        subscription_status: 'active'
      )
      render status: 200, json: company
    else
      render status: 422, json: company.errors
    end
    
  end
end
