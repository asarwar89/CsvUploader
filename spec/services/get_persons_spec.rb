require 'rails_helper'

RSpec.describe GetPersons do

    file = CSV.generate do |csv|
        csv << ["Name", "Location", "Species", "Gender", "Affiliations", "Weapon", "Vehicle"]
        csv << ["Jar Jar Binks", "Naboo", "Gungan", "Male", "Galactic Republic, Gungan Grand Army", "Energy Ball", "Gungan Bongo Submarine"]
        csv << ["R2-D2", "Naboo", "Astromech Droid", "Other", "Rebel Alliance, Galactic Republic", "", "X-wing Starfighter"]
        csv << ["Boba Fett", "Kamino", "Human", "m", "", "Blaster", "Slave 1"]
    end
      
    describe "Return persons data" do
        it "return greater than 2 person data without params" do

            csv_file = instance_double(File)
            allow(csv_file).to receive(:path)
            allow(File).to receive(:open).and_return(file)
            CsvDataProcessor.new(file).process

            params = {}

            @persons = GetPersons.new(params).process

            expect(@persons.length).to eq(2)

            expect(@persons[0][:firstname]).to eq "Jar"
            expect(@persons[0][:lastname]).to eq "Jar Binks"
            expect(@persons[1][:species]).to eq "Astromech Droid"

        end
    end

end