class CreateOffers < ActiveRecord::Migration[6.1]
  def change
    create_table :offers do |t|
      t.string :orga
      t.string :title
      t.string :details_link
      t.datetime :date_post
      t.string :content
      t.string :email
      t.string :phone_number
      t.datetime :date_end

      t.timestamps
    end
  end
end
