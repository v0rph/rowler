class CreateGames < ActiveRecord::Migration[5.0]
  def change
    create_table :games do |t|
      t.integer :current_frame
      t.boolean :finished

      t.timestamps
    end
  end
end
