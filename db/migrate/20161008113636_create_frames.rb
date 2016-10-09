class CreateFrames < ActiveRecord::Migration[5.0]
  def change
    create_table :frames do |t|
      t.integer :game_id
      t.integer :points
      t.integer :first_throw
      t.integer :second_throw

      t.timestamps
    end
  end
end
