class Api::V1::CompaniesController < ApplicationController
  def create
    company = current_user.build_company(company_params)
    
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
