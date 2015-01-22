class Api::V1::CompaniesController < ApplicationController
  def create
    # Return if the current user already has a company
    return render status: 403, json: {msg: 'Company already exists'} if current_user.company
    
    company = Company.new(company_params)
    company.employees << current_user
    
    if company.save
      render status: 201, json: company
    else
      render status: 422, json: company.errors
    end
  end
  
  def company_params
    params.require(:company).permit(:name)
  end
end
