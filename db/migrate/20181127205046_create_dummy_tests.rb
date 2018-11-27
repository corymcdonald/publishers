class CreateDummyTests < ActiveRecord::Migration[5.2]
  def change
    create_table :dummy_tests do |t|

      t.timestamps
    end
  end
end
