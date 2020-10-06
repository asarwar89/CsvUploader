require 'csv'

class Person < ApplicationRecord
    has_many :locations, dependent: :destroy
    has_many :affiliations, dependent: :destroy

    validates :firstname, presence: true
    validates :species, presence: true
    validates :gender, presence: true

    def self.getPeople(searchParam = "", orderby = "", page = 1)

        # Where condition in SQL for search option
        if !(searchParam.blank?)

            @searchQuery = "people.firstname LIKE :search"\
                " OR people.lastname LIKE :search"\
                " OR people.species LIKE :search"\
                " OR people.gender LIKE :search"\
                " OR people.weapon LIKE :search"\
                " OR people.vehicle LIKE :search"\
                " OR locations.name LIKE :search"\
                " OR affiliations.title LIKE :search"
        else
            @searchQuery = ""
        end

        # Get data from table matching all conditions
        @persons = Person
                    .left_outer_joins(:locations, :affiliations)
                    .select('people.*, group_concat(locations.name) as locations, group_concat(affiliations.title) as affiliations')
                    .where(@searchQuery, search: searchParam)
                    .group('people.id')
                    .order(orderby)
                    .paginate(page: page, per_page: 10) 
    end
end