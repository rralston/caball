class CreateFilmMakers < ActiveRecord::Migration
  def change
    create_table :film_makers do |t|

      t.timestamps
    end
  end
end
