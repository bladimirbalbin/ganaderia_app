require 'rails_helper'

RSpec.describe "CompanyRegistrations", type: :request do
  describe "GET /new" do
    it "returns http success" do
      get "/company_registrations/new"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /create" do
    it "returns http success" do
      get "/company_registrations/create"
      expect(response).to have_http_status(:success)
    end
  end

end
