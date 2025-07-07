require 'rails_helper'

RSpec.describe "Customers", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/customers/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    it "returns http success" do
      get "/customers/show"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /new" do
    it "returns http success" do
      get "/customers/new"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /edit" do
    it "returns http success" do
      get "/customers/edit"
      expect(response).to have_http_status(:success)
    end
  end

end
