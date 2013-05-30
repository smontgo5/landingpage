class CreateRegistrants < ActiveRecord::Migration
  def change
    create_table :registrants do |t|
      t.string :login, :null => false
      t.string :avatar_url
      t.string :gravatar_id
      t.string :name
      t.string :company
      t.string :blog
      t.string :location
      t.string :email
      t.timestamps
    end
  end
end
