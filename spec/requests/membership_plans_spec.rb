require 'rails_helper'

RSpec.describe "MembershipPlans", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/membership_plans/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    it "returns http success" do
      get "/membership_plans/show"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /new" do
    it "returns http success" do
      get "/membership_plans/new"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /edit" do
    it "returns http success" do
      get "/membership_plans/edit"
      expect(response).to have_http_status(:success)
    end
  end

end
