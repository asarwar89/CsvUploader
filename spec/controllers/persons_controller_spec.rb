require 'rails_helper'

RSpec.describe Api::V1::PersonsController, :type => :controller do

    describe "GET index" do
        it "response data is correct" do
          get :index
          expect(response.status).to eq(200)
          expect(response.content_type).to eq "application/json; charset=utf-8"
        end
    end

end