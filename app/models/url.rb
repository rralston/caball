class Url < ActiveRecord::Base
  belongs_to :urlable, :polymorphic => true
  attr_accessible :url

  validates :url, :url => true, :if => :validate_url?

  def validate_url?
    # check if the url is present.
    self.url.present?
  end

end
