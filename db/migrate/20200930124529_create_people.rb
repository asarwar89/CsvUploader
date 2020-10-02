class CreatePeople < ActiveRecord::Migration[6.0]
  def change
    create_table :people do |t|
      t.string :firstname
      t.string :lastname
      t.string :species
      t.string :gender
      t.string :weapon
      t.string :vehicle

      t.timestamps
    end
  end
end
