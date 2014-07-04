class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.boolean :vote
      t.integer :user_id
      t.string :voteable_type
      t.integer :voteable_id
      #t.references :voteable, polymorphic: true - this could replace the last
      #       two lines; does the same thing (Rails convention)

      t.timestamps
    end
  end
end
