class Api::V1::PersonsController < ApplicationController
    def index

        # Checks if ordering requested
        unless params[:orderby].blank?

            # checks order is ascending or descending
            # order blank means ascending else descending
            if params[:order].blank?
                @order_by = params[:orderby]
            else
                @order_by = "#{params[:orderby]} desc"
            end
        
        end

        unless params[:searchfor].blank?
            @search_param = "%#{params[:searchfor]}%"
        else
            @search_param = ""
        end

        @page = params[:page]
        
        # requesting person class for SQL
        @persons = Person.getPeople(@search_param, @order_by, @page)
        render json: {
            persons: @persons,
            page: @persons.current_page,
            page_count: @persons.total_pages
        }
    end

    def create
        begin
            process_file(params[:file])
            render json: {
                success: 'File processed successfully'
            }
        rescue => e
            render json: {
                error: e
            }
        end
    end

    def process_file(file)

        CSV.foreach(file, headers: true) do |row|
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

                        location_arr = row[1].split(',').map { |item| item.strip.split(' ').map(&:capitalize).join(' ') }

                        # Save each location in Location table linking person id
                        location_arr.each do |location|
                            @location = Location.new({ name: location, person_id: @person.id})
                            @location.save
                        end
                    end
                    
                    # Convert affiliations to Capitalized affiliations array
                    affiliations_arr = row[4].split(',').map { |item| item.strip.capitalize() }

                    # Save each affiliation in Affiliation table linking person id
                    affiliations_arr.each do |affiliation|
                        @affiliation = Affiliation.new({ title: affiliation, person_id: @person.id})
                        @affiliation.save
                    end
                end
            end
        end
    end

    # As a test site added this function to empty data tables
    # So that a fresh start is possible for testing
    def destroy_all
        begin
            Location.destroy_all
            Affiliation.destroy_all
            Person.destroy_all

            render json: {
                success: 'Deleted all data successfully'
            }
        rescue => e
            render json: {
                error: e
            }
        end
    end
end
