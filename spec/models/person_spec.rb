require 'rails_helper'

RSpec.describe Person, type: :model do
   subject { 
       Person.new({
            firstname: 'John',
            lastname: 'Doe',
            species: 'Human',
            gender: 'Male',
            weapon: 'Stick',
            vehicle: 'Car'
        }) 
    }

    before { subject.save }

    it 'Person should be valid with firstname & species & gender' do
        expect(subject).to be_valid
    end
    
    it 'Person should not be valid without firstname' do
        subject.firstname = nil
        expect(subject).to_not be_valid
    end
    
    it 'Person should not be valid without species' do
        subject.species = nil
        expect(subject).to_not be_valid
    end

    it 'Person should not be valid without gender' do
        subject.gender = nil
        expect(subject).to_not be_valid
    end

    it 'Person should return results' do
        expect(Person.getPeople().size).to have(1).items
    end

    it 'Person should return results with search' do
        expect(Person.getPeople('stick').size).to have(1).items
    end

    it 'Person should not return results with unmatched search' do
        expect(Person.getPeople('Machine Gun').size).to have(0).items
    end

end