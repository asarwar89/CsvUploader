class GetPersons
    def initialize(params)
        @params = params
    end

    def process

        # Checks if ordering requested
        unless @params[:orderby].blank?

            # checks order is ascending or descending
            # order blank means ascending else descending
            @order_by = @params[:order].blank? ? @params[:orderby] : "#{@params[:orderby]} desc"
        
        end

        @search_param = @params[:searchfor].blank? ? "" : "%#{@params[:searchfor]}%"
        
        # requesting person class for SQL
        @persons = Person.getPeople(@search_param, @order_by, @params[:page])
    end

    
end