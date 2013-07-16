require 'spec_helper'
require 'request_helper'

describe Event do
  before(:all) do
    clean!
  end

  context "Associations" do
    it { should belong_to(:user) }
    it { should have_many(:other_photos).dependent(:destroy) }
    it { should have_many(:videos).dependent(:destroy) }
    it { 
      pending 'comments should be made polymorphic'
      should have_many(:comments).dependent(:destroy) 
    }
    it { should have_many(:other_important_dates).dependent(:destroy) }
    it { should have_many(:likes).dependent(:destroy) }
    it { should have_many(:fans) }

    it { should have_one(:main_photo).class_name('Photo').dependent(:destroy) }
    it { should have_one(:start).class_name('ImportantDate').dependent(:destroy) }
    it { should have_one(:end).class_name('ImportantDate').dependent(:destroy) }

    it { should accept_nested_attributes_for :other_photos }
    it { should accept_nested_attributes_for :videos }
    it { should accept_nested_attributes_for :main_photo }
    it { should accept_nested_attributes_for :start }
    it { should accept_nested_attributes_for :end }
    it { should accept_nested_attributes_for :other_important_dates }
  end

  context "Validations" do
    before(:all){
      @event = Event.new
      @event.valid?
    }
    specify { @event.errors.full_messages.join(', ').should == 'Title is required, Title is required, Description is required, Description is required' }
  end
end
