require 'csv'

class PersonsController < ApplicationController

    def index

        # Checks if ordering requested
        if !(params[:ob].blank?)

            # checks order is ascending or descending
            # oad blank means ascending else descending
            if (params[:oad].blank?)
                @orderby = self.class.getColumnName(params[:ob])
                @orderingObj = self.class.processOrdering(params[:ob])
            else
                @orderby = "#{self.class.getColumnName(params[:ob])} desc"
                @orderingObj = self.class.processOrdering(params[:oad], 'desc')
            end
        else
            # if no ordering required on page load
            # ordering object requried for toggling order history
            @orderingObj = self.class.processOrdering()
        end

        if !(params[:searchfor].blank?)
            @searchParam = "%#{params[:searchfor]}%"
        else
            @searchParam = ""
        end

        @page = params[:page]
        
        # requesting person class for SQL
        @persons = Person.getPeople(@searchParam, @orderby, @page)

    end

    def new
        @person = Person.new
    end
  
    def create
        processFile(params[:person][:file])
        flash[:notice] = "Countries uploaded successfully"
        redirect_to persons_path
    end

    def processFile(file)

        CSV.foreach(file.path, headers: true) do |row|

            # row[4] = Affiliation, row[0] = Name. Both required
            # Process data only if both field exists
            if (!(row[4].blank?) & !(row[0].blank?))

                # Capitalise each part of name
                nameArr = row[0].split(" ").map(&:capitalize);

                # Create person object using Person model
                @person = Person.new({
                    firstname: nameArr.slice!(0),
                    lastname: nameArr.join(' '),
                    species: row[2],
                    gender: row[3],
                    weapon: row[5],
                    vehicle: row[6]
                })

                # If person is saved only then process Affiliation and Location
                if @person.save

                    # row[1] = Location
                    if !(row[1].blank?)

                        locationArr = row[1].split(",").map { |item| item.strip.split(" ").map(&:capitalize).join(" ") }

                        # Save each location in Location table linking person id
                        locationArr.each do |location|
                            @location = Location.new({ name: location, person_id: @person.id})
                            @location.save
                        end
                    end
                    
                    # Convert affiliations to Capitalized affiliations array
                    affiliationsArr = row[4].split(",").map { |item| item.strip.capitalize() }

                    # Save each affiliation in Affiliation table linking person id
                    affiliationsArr.each do |affiliation|
                        @affiliation = Affiliation.new({ title: affiliation, person_id: @person.id})
                        @affiliation.save
                    end
                end
            end
        end
    end

    # Process ordering object to toggle ordering
    def self.processOrdering(orderby = "", order = "")
        orderHash = { fn: '', ln: '', sp: '', gd: '', wp: '', vh: '', afl: '', loc: '' }

        if (order.blank?)
            orderHash[orderby.to_sym] = 'desc'
        end

        orderHash
    end

    # Get order by column name for SQL
    def self.getColumnName(orderby) 
        columnList = {
            :fn => 'people.firstname',
            :ln => 'people.lastname',
            :sp => 'people.species',
            :gd => 'people.gender',
            :wp => 'people.weapon',
            :vh => 'people.vehicle',
            :afl => 'affiliations.title',
            :loc => 'locations.name'
        }

        columnList[orderby.to_sym]
    end

    # As a test site added this function to empty data tables
    # So that a fresh start is possible for testing
    def destroyAll
        Location.destroy_all
        Affiliation.destroy_all
        Person.destroy_all
        redirect_to persons_path
    end
end
