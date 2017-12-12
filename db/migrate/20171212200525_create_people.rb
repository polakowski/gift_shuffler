class CreatePeople < ActiveRecord::Migration[5.1]
  def change
    create_table :people do |t|
      t.string :email
      t.string :name
      t.integer :group_id
      t.integer :gifts_to_receive, default: 0
      t.integer :gifts_to_make, default: 0
    end
  end
end
