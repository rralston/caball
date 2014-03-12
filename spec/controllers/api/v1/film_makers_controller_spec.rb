require 'spec_helper'

describe Api::V1::FilmMakersController do

  before :each do
    @user = create(:user)
    @params = {:username => @user.email, :password => "123456"}
  end
  context 'Status Codes' do
    it "returns HTTP 200 on GET film_makers" do
      get "film_makers"
      expect(response.status).to eql(200)
    end

  end

  context 'JSON response' do
    subject(:json){
      JSON.parse(response.body)
    }

  end

end