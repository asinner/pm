class Api::V1::CompaniesController < ApplicationController
  def create
    return render status: 422, json: {msg: 'You have already created a company'} if current_user.company
    
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
