class Video < ActiveRecord::Base
  belongs_to :videoable, :polymorphic => true
  attr_accessible :provider, :title, :description, :user_description,
                  :keywords, :duration, :date, :thumbnail_small, :is_demo_reel,
                  :thumbnail_large, :embed_url, :embed_code, :video_updated_at,
                  :url, :imdb
  before_save :movie_details, :if => :url?
  scope :real, where("thumbnail_small is NOT NULL")

  def movie_details
    video = VideoInfo.get(self.url)
    if video.present?
      self.provider        = video.provider     
      self.title           = video.title  
      self.description     = video.description 
      self.keywords        = video.keywords      
      self.duration        = video.duration   
      self.date            = video.date       
      self.thumbnail_small = video.thumbnail_small
      self.thumbnail_large = video.thumbnail_large
      self.embed_url       = video.embed_url      
      self.embed_code      = video.embed_code
    end
  end
end
