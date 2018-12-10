class AddLastYearReceiverIdToPeople < ActiveRecord::Migration[5.1]
  def change
    add_column :people, :last_year_receiver_id, :integer
  end
end
