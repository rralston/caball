require 'spec_helper'

describe Like do
	let(:user){User.create(name: "yuvaraja",email:'yuv.slm@gmail.com')}
	let(:project){user.projects.create(title: "Sample Title", description: "Sample description")}
	let(:love){user.likes.create(loveable_id: project.id, loveable_type: 'Project')}
	subject{love}

	it { should be_valid }
	it { should respond_to :user }
	it { should respond_to :loveable }
end
