require 'spec_helper'

describe Project do
	let(:user){User.create(name: "yuvaraja",email:'yuv.slm@gmail.com')}
	let(:project){user.projects.create(title: "Sample Title", description: "Sample description")}
	let(:love){project.likes.create(user_id: user.id)}
	subject{project}

	it { should be_valid }
	it { should respond_to :user }
	it { should respond_to :likes }
end
