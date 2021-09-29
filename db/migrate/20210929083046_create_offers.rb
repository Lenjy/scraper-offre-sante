class CreateOffers < ActiveRecord::Migration[6.1]
  def change
    create_table :offers do |t|
      t.string :title
      t.string :location
      t.string :email
      t.string :content
      t.string :link
      t.string :number
      t.string :code

      t.timestamps
    end
  end
end
