require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

require 'acts_as_list_mongoid'
require 'embedded_item'

describe 'ActsAsList for Mongoid' do    
  
  before :each do   
    @list = List.create!
    @list.items = []
    (1..4).each do |counter| 
      @list.items << Item.new(:number => counter)
    end
    @list.save!
    
    @list.items.created!
  end    
  
  after :each do
    Mongoid.database.collections.each do |coll|
      coll.remove
    end
  end

  def get_positions list
    list.items.sort { |x,y| x.my_position <=> y.my_position }.map(&:number)  
  end
  
  context "4 list items (1,2,3,4) that have parent_id pointing to first list container"  do
    describe '# initial configuration' do
      it "should list items 1 to 4 in order" do        
        positions = get_positions @list 
        positions.should == [1, 2, 3, 4]
      end 
    end
    
    describe '#reordering' do
      it "should move item 2 to position 3" do
        @list.items[1].increment_position
        @list.items[2].decrement_position      
        get_positions(@list).should == [1, 3, 2, 4]
      end
      
      
      it "should move item 2 to position 3" do          
        @list.items.where(:number => 2).first.move_lower
        get_positions(@list).should == [1, 3, 2, 4]
      end
      
      it "should move item 2 to position 1" do    
        @list.items.where(:number => 2).first.move_higher
        get_positions(@list).should == [2, 1, 3, 4]  
      end 
        
      it "should move item 1 to bottom" do    
        @list.items.where(:number => 1).first.move_to_bottom
        get_positions(@list).should == [2, 3, 4, 1]  
      end
      
      it "should move item 1 to top" do    
        @list.items.where(:number => 1).first.move_to_top
        get_positions(@list).should == [1, 2, 3, 4]  
      end
      
      it "should move item 2 to bottom" do    
        @list.items.where(:number => 2).first.move_to_bottom
        get_positions(@list).should == [1, 3, 4, 2]  
      end
      
      it "should move item 4 to top" do    
        @list.items.where(:number => 4).first.move_to_top
        get_positions(@list).should == [4, 1, 2, 3]  
      end  
    
      it "should move item 3 to bottom" do
        get_positions(@list).should == [1, 2, 3, 4]      
           
        @list.items.where(:number => 3).first.move_to_bottom
        get_positions(@list).should == [1, 2, 4, 3]  
        
      end      
    end
    
    describe 'relative position queries' do
      it "should find item 2 to be lower item of item 1" do
        expected = @list.items.where(:pos => 2).first
        @list.items.where(:pos => 1).first.lower_item.should == expected
      end
    
      it "should not find any item higher than nr 1" do
        @list.items.where(:pos => 1).first.higher_item.should == nil
      end
    
      it "should find item 3 to be higher item of item 4" do     
        expected = @list.items.where(:pos => 3).first
        @list.items.where(:pos => 4).first.higher_item.should == expected
      end
    
      it "should not find item lower than item 4" do            
        @list.items.where(:pos => 4).first.lower_item.should == nil
      end
    end        
  end
end