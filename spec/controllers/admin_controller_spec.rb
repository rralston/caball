require 'spec_helper'
require 'request_helper'

describe Admin::AdminController do

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      response.should be_success
    end
  end

end
