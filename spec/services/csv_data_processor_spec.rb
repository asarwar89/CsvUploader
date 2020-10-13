require 'rails_helper'

RSpec.describe CsvDataProcessor do

    file = CSV.generate do |csv|
        csv << ["Name", "Location", "Species", "Gender", "Affiliations", "Weapon", "Vehicle"]
        csv << ["Jar Jar Binks", "Naboo", "Gungan", "Male", "Galactic Republic, Gungan Grand Army", "Energy Ball", "Gungan Bongo Submarine"]
        csv << ["R2-D2", "Naboo", "Astromech Droid", "Other", "Rebel Alliance, Galactic Republic", "", "X-wing Starfighter"]
        csv << ["Boba Fett", "Kamino", "Human", "m", "", "Blaster", "Slave 1"]
    end
      
    describe "create new" do
        it "process file properly" do

            csv_file = instance_double(File)
            allow(csv_file).to receive(:path)
            allow(File).to receive(:open).and_return(file)

            # before file processed
            @person_count_before = Person.count
            @location_count_before = Location.count
            @affiliation_count_before = Affiliation.count

            @instance = CsvDataProcessor.new(file).process

            # after file processed
            @person_count_after = Person.count
            @location_count_after = Location.count
            @affiliation_count_after = Affiliation.count

            expect(@instance).to eq nil
            
            # process file without error
            @instance = CsvDataProcessor.new(file).process
            
            # Inserted two person to person table
            # Boba Fett has not affiliation so should be skipped
            expect(@person_count_after - @person_count_before ).to eq(2)

            # Inserted four affiliations to affiliations table
            expect(@affiliation_count_after - @affiliation_count_before ).to eq(4)

            # Inserted 2 locations to locations table
            expect(@location_count_after - @location_count_before ).to eq(2)
        end
    end

end