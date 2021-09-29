class AddOrgaToOffer < ActiveRecord::Migration[6.1]
  def change
    add_column :offers, :orga, :string
  end
end
