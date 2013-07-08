require 'spec_helper'

describe Comment do
	let(:user){User.create(name: "yuvaraja",email:'yuv.slm@gmail.com')}
	let(:project){user.projects.create(title: "Sample Title", description: "Sample description")}
	let(:comment){user.comments.create(content: "Sample Comment", project_id: project.id)}
	let(:love){comment.likes.create(user_id: user.id)}
	subject{comment}

	it { should be_valid }
	it { should respond_to :user }
	it { should respond_to :likes }
end
