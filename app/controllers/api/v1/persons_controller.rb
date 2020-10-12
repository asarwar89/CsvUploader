class Api::V1::PersonsController < ApplicationController
    def index

        @persons = GetPersons.new(params).process

        render json: {
            persons: @persons,
            page: @persons.current_page,
            page_count: @persons.total_pages
        }
    end

    def create
        begin
            CsvDataProcessor.new(params[:file]).process
            render json: {
                success: 'File processed successfully'
            }
        rescue => e
            render json: {
                error: e
            }
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
