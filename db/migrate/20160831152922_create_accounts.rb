class CreateAccounts < ActiveRecord::Migration
  def up
    create_table :accounts do |t|
      t.integer :card_number
      t.string :card_holder_first_name
      t.string :card_holder_second_name
      t.integer :balance
      t.belongs_to :user

      t.timestamps null: false
    end

    add_reference :users, :account
  end

  def down
  	drop_table :accounts
  	remove_reference :users, :account
  end
end
