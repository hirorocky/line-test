require 'rails_helper'

RSpec.describe "Companies", type: :request do

  describe "GET /index" do
    it "returns http success" do
      get "/companies/index"
      expect(response).to have_http_status(:success)
    end
  end

end
