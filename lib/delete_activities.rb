
# Use this class to delete activities that are created on a model.
# initilize with the model record, whose activities are to be deleted and call relevant method.


class DeleteActivities

  def initialize( entity )
    @entity = entity
    @entity_class = entity.class.name.downcase
  end

  attr_accessor :entity, :entity_class

  def del_1_day_ago_updates
    one_day_ago_updates.destroy_all
  end

  def one_day_ago_updates
    entity.activities.where( "activities.key = ? AND created_at >= ?", "#{entity_class}.update", 1.day.ago )
  end

end