class CreateAffiliations < ActiveRecord::Migration[6.0]
  def change
    create_table :affiliations do |t|
      t.string :title
      t.references :person, null: false, foreign_key: true

      t.timestamps
    end
  end
end
