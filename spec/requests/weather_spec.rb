require 'rails_helper'

RSpec.describe "Weathers", type: :request do
  describe "GET /show" do
    it "returns http success" do
      get "/weather/show"
      expect(response).to have_http_status(:success)
    end
  end

end
