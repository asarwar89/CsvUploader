require 'rails_helper'

class PersonTest < ActiveSupport::TestCase

  RSpec.describe Auction, :type => :model do
    it "is valid with valid attributes"
    it "is not valid without a title"
    it "is not valid without a description"
    it "is not valid without a start_date"
    it "is not valid without a end_date"
  end

end
