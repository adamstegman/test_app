class CreateTestings < ActiveRecord::Migration
  def change
    create_table :testings do |t|
      t.string :key
      t.text :value

      t.timestamps
    end
  end
end
