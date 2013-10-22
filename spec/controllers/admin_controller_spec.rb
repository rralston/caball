require 'spec_helper'
require 'request_helper'

describe Admin::AdminController do

  describe "GET 'index'" do
    it "returns http success" do
      { :get => "admin/admin/index" }.should route_to(
        :controller => "admin/admin",
        :action => "index"
      )
    end
  end

end
