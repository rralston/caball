require 'spec_helper'

describe "Users" do
	let(:user){User.create(name: "yuvaraja",email:'yuv.slm@gmail.com')}
	subject{user}

	it { should be_valid }
	it { should respond_to :loves }
end