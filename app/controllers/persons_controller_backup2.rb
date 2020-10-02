require 'csv'

class PersonsController < ApplicationController
    def index

        if !(params[:ob].blank?)

            if (params[:oad].blank?)
                @orderby = getColumnName(params[:ob])
                @orderingObj = processOrdering(params[:ob])
            else
                @orderby = "#{getColumnName(params[:ob])} desc"
                @orderingObj = processOrdering(params[:oad], 'desc')
            end
        else
            @orderingObj = processOrdering()
        end

        if !(params[:searchfor].blank?)
            @searchParam = "%#{params[:searchfor]}%"
        else
            @searchParam = ""
        end

        # @searchParam = params[:searchfor] && "%#{params[:searchfor]}%"
        @page = params[:page]

        # @persons = Person
        #             .left_outer_joins(:locations, :affiliations)
        #             .select('people.*, group_concat(locations.name) as locations, group_concat(affiliations.title) as affiliations')
        #             .where(@searchQuery, search: @searchParam)
        #             .group('people.id')
        #             .order(@orderby)
        #             .paginate(page: params[:page], per_page: 10)
        
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

            if (!(row[4].blank?) & !(row[0].blank?))

                nameArr = row[0].split(" ").map(&:capitalize);

                @person = Person.new({
                    firstname: nameArr.slice!(0),
                    lastname: nameArr.join(' '),
                    species: row[2],
                    gender: row[3],
                    weapon: row[5],
                    vehicle: row[6]
                })

                if @person.save

                    if !(row[1].blank?)

                        locationArr = row[1].split(",").map { |item| item.strip.split(" ").map(&:capitalize).join(" ") }

                        locationArr.each do |location|
                            @location = Location.new({ name: location, person_id: @person.id})
                            @location.save
                        end
                    end
                    
                    affiliationsArr = row[4].split(",").map { |item| item.strip.capitalize() }

                    affiliationsArr.each do |affiliation|
                        @affiliation = Affiliation.new({ title: affiliation, person_id: @person.id})
                        @affiliation.save
                    end
                end
            end
        end
    end

    def processOrdering(orderby = "", order = "")
        orderHash = { fn: '', ln: '', sp: '', gd: '', wp: '', vh: '', afl: '', loc: '' }

        if (order.blank?)
            orderHash[orderby.to_sym] = 'desc'
        end

        orderHash
    end

    def getColumnName(orderby) 
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
end
