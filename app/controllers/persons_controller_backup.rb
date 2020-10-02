require 'csv'

class PersonsController < ApplicationController
    def index

        if !(params[:searchfor].blank?)
            @searchParam = "%#{params[:searchfor]}%"

            @searchQuery = "people.firstname LIKE :search"\
                " OR people.lastname LIKE :search"\
                " OR people.species LIKE :search"\
                " OR people.gender LIKE :search"\
                " OR people.weapon LIKE :search"\
                " OR people.vehicle LIKE :search"\
                " OR locations.name LIKE :search"\
                " OR affiliations.title LIKE :search"
        end

        # if (params[:searchfor].blank?)
            # @persons = Person
            #             .left_outer_joins(:locations, :affiliations)
            #             .select('people.*, locations.*, affiliations.*')
            #             .paginate(page: params[:page], per_page: 10)
            
            puts "#{@searchParam} Search param"
            puts "#{@searchQuery} Search Query"
            # puts @searchParam

            @persons = Person
                        .left_outer_joins(:locations, :affiliations)
                        .select('people.*, locations.name, affiliations.title, group_concat(locations.name) as locations, group_concat(affiliations.title) as affiliations')
                        .where(@searchQuery, search: @searchParam)
                        .group('people.id')
                        .paginate(page: params[:page], per_page: 10)
        # else

            # @persons = Person
            #             .left_outer_joins(:locations, :affiliations)
            #             .select('people.*, locations.*, affiliations.*')
            #             .where(@searchQuery, search: @searchParam)
            #             .paginate(page: params[:page], per_page: 10)
        # end

        # @orders = Order.order('created_at desc').page(params[:page])
        # select p.firstname, p.lastname, group_concat(l.name, ', ') as locations from people p left JOIN affiliations a on a.person_id = p.id LEFT JOIN locations l on l.person_id = p.id GROUP by p.id
    end

    def new
        @person = Person.new
    end
  
    def create
        processFile(params[:person][:file])
        flash[:notice] = "Countries uploaded successfully"
        redirect_to persons_path
    end

    def search
        @persons = Person
                    .left_outer_joins(:locations, :affiliations)
                    .select('people.*, locations.*, affiliations.*')
                    .paginate(page: params[:page], per_page: 10)

        redirect_to persons_path
    end

    def destroyAll
        Location.destroy_all
        Affiliation.destroy_all
        Person.destroy_all
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
end
