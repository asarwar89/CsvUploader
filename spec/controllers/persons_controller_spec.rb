require 'rails_helper'
require 'csv'

RSpec.describe Api::V1::PersonsController, :type => :controller do

    file = CSV.generate do |csv|
      csv << ["Name", "Location", "Species", "Gender", "Affiliations", "Weapon", "Vehicle"]
      csv << ["Jar Jar Binks", "Naboo", "Gungan", "Male", "Galactic Republic, Gungan Grand Army", "Energy Ball", "Gungan Bongo Submarine"]
      csv << ["R2-D2", "Naboo", "Astromech Droid", "Other", "Rebel Alliance, Galactic Republic", "", "X-wing Starfighter"]
      csv << ["Boba Fett", "Kamino", "Human", "m", "", "Blaster", "Slave 1"]
    end

    describe "GET index" do
        it "response data is correct" do
          get :index
          expect(response.status).to eq(200)
          expect(response.content_type).to eq "application/json; charset=utf-8"
        end
    end
    
    describe "POST create" do
        it "process file properly" do

          csv_file = instance_double(File)
          allow(csv_file).to receive(:path)
          allow(File).to receive(:open).and_return(file)

          @expected = {
              :success => 'File processed successfully'
          }

          post :create, params: {file: file}
          expect(response.body).to eq @expected.to_json
        end
    end

end