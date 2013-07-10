require 'spec_helper'
require 'request_helper'

describe Admin::AdminHelper do

  context "objects_created_within_date_range" do
    let!(:start_time) { 5.days.ago }
    let!(:end_time) { Time.now }
    let(:object1) { OpenStruct.new(name: "1", created_at: 8.days.ago) }
    let(:object2) { OpenStruct.new(name: "2", created_at: 4.days.ago) }
    let(:object3) { OpenStruct.new(name: "3", created_at: 3.days.ago) }
    let(:object4) { OpenStruct.new(name: "4", created_at: 1.week.ago) }
    let(:object5) { OpenStruct.new(name: "5", created_at: 5.days.ago) }
    let(:objects) { [object1, object2, object3, object4, object5] }
    let(:filtered_objects) { objects_created_within_date_range(objects, start_time, end_time) }
    it "should return objects created within range" do
      filtered_objects.should =~ [object2, object3, object5]
    end
  end

end