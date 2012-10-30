class Video < ActiveRecord::Base
  belongs_to :user
  attr_accessible :provider, :title, :description, :keywords, :duration, :date, :thumbnail_small, :thumbnail_large, :embed_url, :embed_code, :video_updated_at, :url
  before_create :movie_details, :if => :url?
  
  def movie_details
    video = VideoInfo.new(self.url)
    self.provider = video.provider     
    self.title = video.title  
    self.description = video.description 
    self.keywords = video.keywords      
    self.duration = video.duration   
    self.date = video.date       
    self.thumbnail_small = video.thumbnail_small
    self.thumbnail_large = video.thumbnail_large
    self.embed_url = video.embed_url      
    self.embed_code = video.embed_code
  end
end