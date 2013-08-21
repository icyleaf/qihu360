require 'spec_helper'


describe DJing360 do
  it "Has not any method" do
    cls = DJing360.new
    cls.hi be_nil
    cls.to_s 
  end
end