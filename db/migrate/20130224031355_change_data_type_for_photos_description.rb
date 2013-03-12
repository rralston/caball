class ChangeDataTypeForPhotosDescription < ActiveRecord::Migration
  def self.up
      change_table :photos do |t|
        t.change :description, :text
      end
    end
    def self.down
      change_table :photos do |t|
        t.change :description, :text
      end
    end
  end


