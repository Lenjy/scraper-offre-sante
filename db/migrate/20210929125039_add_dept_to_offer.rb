class AddDeptToOffer < ActiveRecord::Migration[6.1]
  def change
    add_column :offers, :dept, :integer
  end
end
