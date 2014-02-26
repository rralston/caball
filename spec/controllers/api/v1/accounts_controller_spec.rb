require 'spec_helper'

describe Api::V1::UsersController do

  before :each do
    @user = create(:user)
    @params = {:username => @user.email, :password => "123456"}
  end
  context 'Status Codes' do
    it 'returns HTTP STATUS 200 when login is successful' do
      post 'auth', @params
      expect(response.status).to eql(200)
    end

    it 'returns HTTP STATUS 400 when params are invalid' do
      post 'auth'
      expect(response.status).to eql(400)
    end

    it 'returns HTTP STATUS 401 when login fails because of wrong password' do
      post 'auth', :username => @user.email, :password => 'WRONG PASSWORD'
      expect(response.status).to eql(401)
    end

    it 'returns HTTP STATUS 401 when login fails because of wrong email' do
      post 'auth', :username => 'WRONG EMAIL ADDRESS', :password => '123456'
      expect(response.status).to eql(401)
    end

  end

  context 'JSON response' do
    subject(:json){
      JSON.parse(response.body)
    }

    it 'returns access token when login is valid' do
      post 'auth', @params
      expect(json['user']['authentication_token']).to eql(@user.authentication_token)
    end

    it 'returns user when login is valid' do
      post 'auth', @params
      expect(json['user']['account_type']).to eql('homebuyer')
    end
  end

end