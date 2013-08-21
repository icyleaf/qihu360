require 'spec_helper'


describe DJing360 do
  pending "add some examples to (or delete)"

  it "Has not any method" do
    client = DJing360::Client.new()
    client.authorize_url be_nil
  end
end