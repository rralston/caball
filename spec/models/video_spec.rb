require 'spec_helper'
require 'request_helper'

describe Video do
  before(:all) do
    clean!
  end

  context "Associations" do
    it { should belong_to(:videoable) }
  end

  context "movie details" do
    context "when a valid url is given" do
      before(:all){
        @video = FactoryGirl.create(:video, :url => "http://www.youtube.com/watch?v=mZqGqE0D0n4")
        @video_details = VideoInfo.get(@video.url)
      }
      subject { @video }
      
      its(:provider) { should == @video_details.provider }
      its(:title) { should == @video_details.title }
      its(:description) { should == @video_details.description }
      its(:keywords) { should == @video_details.keywords }
      its(:duration) { should == @video_details.duration }
      its(:date) { should == @video_details.date }
      its(:thumbnail_small) { should == @video_details.thumbnail_small }
      its(:thumbnail_large) { should == @video_details.thumbnail_large }
      its(:embed_url) { should == @video_details.embed_url }
      its(:embed_code) { should == @video_details.embed_code }
    end

    context "when invalid url is given" do
      before(:all){
        @video = FactoryGirl.create(:video, :url => "google.com")
        @video_details = VideoInfo.get(@video.url)
      }
      its(:provider) { should be nil }
    end
  end
end