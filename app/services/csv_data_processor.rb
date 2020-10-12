class CsvDataProcessor
    def initialize(file)
        @csvfile = file
    end

    def process

        CSV.foreach(@csvfile, headers: true) do |row|
            # row[4] = Affiliation, row[0] = Name. Both required
            # Process data only if both field exists
            if (!(row[4].blank?) & !(row[0].blank?))

                # Capitalise each part of name
                name_arr = row[0].split(' ').map(&:capitalize)

                # Create person object using Person model
                @person = Person.new({
                    firstname: name_arr.slice!(0),
                    lastname: name_arr.join(' '),
                    species: row[2],
                    gender: row[3],
                    weapon: row[5],
                    vehicle: row[6]
                })

                # If person is saved only then process Affiliation and Location
                if @person.save

                    # row[1] = Location
                    unless row[1].blank?
                        process_location(row[1], @person.id)
                    end
                    
                    process_affiliation(row[4], @person.id)

                end
            end
        end
    end

    def process_location(location, person_id)
        location_arr = location.split(',').map { |item| item.strip.split(' ').map(&:capitalize).join(' ') }

        # Save each location in Location table linking person id
        location_arr.each do |location|
            @location = Location.new({ name: location, person_id: person_id})
            @location.save
        end
    end

    def process_affiliation(affiliation, person_id)
        # Convert affiliations to Capitalized affiliations array
        affiliations_arr = affiliation.split(',').map { |item| item.strip.capitalize() }

        # Save each affiliation in Affiliation table linking person id
        affiliations_arr.each do |affiliation|
            @affiliation = Affiliation.new({ title: affiliation, person_id: person_id})
            @affiliation.save
        end
    end
    
end