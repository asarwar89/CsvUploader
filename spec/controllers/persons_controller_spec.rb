require 'rails_helper'

RSpec.describe PersonsController, :type => :controller do

    describe "GET index" do
        it "response data is correct" do
          get :index
          expect(response.status).to eq(200)
          expect(response.content_type).to eq "text/html; charset=utf-8"
        end
    end

    describe "Orderby function works as expected" do
        it "return correct order by" do
          PersonsController.processOrdering("fn","")[:fn] == "desc"
          PersonsController.processOrdering("fn","desc")[:fn] == ""
        end
    end

    describe "Get column name function works as expected" do
        it "set order by to correct column" do
          PersonsController.getColumnName("fn") == "people.firstname"
          PersonsController.getColumnName("ln") == "people.lastname"
          PersonsController.getColumnName("sp") == "people.species"
          PersonsController.getColumnName("gd") == "people.gender"
          PersonsController.getColumnName("wp") == "people.weapon"
          PersonsController.getColumnName("vh") == "people.vehicle"
          PersonsController.getColumnName("afl") == "affiliations.title"
          PersonsController.getColumnName("loc") == "locations.name"
        end
    end

end