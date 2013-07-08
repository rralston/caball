require "spec_helper"
require "request_helper"

describe UserMailer do

  before(:all) do
    clean!
  end

  describe "signup_confirmation" do
    let(:user) { FactoryGirl.create(:user) }
    let(:mail) { UserMailer.signup_confirmation(user) }

    it "renders the headers" do
      mail.subject.should eq("Sign Up Confirmation")
      mail.to.should_not be_nil
      mail.from.should eq(["notification@filmzu.com"])
    end

    it "renders the body" do
      mail.body.encoded.should have_text("Thank you for signing up")
    end
  end

end
