require 'spec_helper'

describe Project do
	let(:user){FactoryGirl.create(:user,name: "yuvaraja",email:'yuv.slm@gmail.com')}
	let(:blog){user.blogs.create(content: "Sample Blog Content.")}
	let(:love){blog.likes.create(user_id: user.id)}
	subject{blog}

	it { should be_valid }
	it { should respond_to :user }
	it { should respond_to :likes }
end
