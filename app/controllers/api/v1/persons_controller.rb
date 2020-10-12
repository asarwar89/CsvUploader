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
