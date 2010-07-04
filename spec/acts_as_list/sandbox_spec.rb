require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe 'ActsAsList for Mongoid' do    
  
  before :each do   
    # @list = SimpleList.new :name => 'My simple list'   
    # (1..3).each do |counter| 
    #   item = SimpleItem.create! :pos => counter, :original_id => counter, :list => @list, :assoc => :simple_items
    #   @list << item
    # end       
    # 
    # puts "count: #{SimpleItem.all.size}"
    # 
    # @list.simple_items[1].set_pos 3            
    # @list.simple_items[2].set_pos 2                
    # 
    # sorted = @list.simple_items.sort{ |x,y| x.pos <=> y.pos}
    # puts "Items: #{sorted}"
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