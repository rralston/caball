module JsonHelper
  def json
    @json ||= JSON.parse(response.body)
  end
end

RSpec.configure do |c|
  c.include JsonHelper, :type => :request
end