require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe 'ActsAsList for Mongoid - BasicItem' do    
  
  before :each do   
    (1..3).each do |counter| 
      BasicItem.create! :pos => counter, :original_id => counter
    end       

    puts "count: #{BasicItem.all.size}"
    
    BasicItem.all[1].set_pos 3            
    BasicItem.all[2].set_pos 2                
    
    sorted = BasicItem.all.sort{ |x,y| x.pos <=> y.pos}
    puts "Items: #{sorted}"
  end    
  
  after :each do
    Mongoid.database.collections.each do |coll|
      coll.remove
    end
  end

  describe 'x' do
    it "should do it" do
    end    
  end
end