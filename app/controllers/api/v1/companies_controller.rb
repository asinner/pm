class Api::V1::CompaniesController < ApplicationController
  before_action :authenticate_user
  
  def create    
    company = Company.new(company_params)
    company.users << current_user
    company.plan = Plan.find_by_name('Trial')
    company.subscription_status = 'active'
    
    if company.save
      render status: 201, json: company
    else
      render status: 422, json: company.errors
    end
  end
  
  def update
    company = Company.find(params[:id])
    authorize company
    
    if company.update(company_params)
      render status: 200, json: company
    else
      render status: 422, json: company.errors
    end
  end
  
  private
  
  def company_params
    params.require(:company).permit(:name)
  end
end
