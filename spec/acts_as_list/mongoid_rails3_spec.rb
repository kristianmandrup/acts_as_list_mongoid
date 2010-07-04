require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

require 'yaml'

describe 'ActsAsList for Mongoid' do    

  def parent_id list_nr
    list_nr
  end
  
  before :each do      
    @list = List.new :name => 'My list'           
    @list2 = List.new :name => 'My list 2'           
    @list3 = List.new :name => 'My list 3'           
        
    @list.items = []
    (1..4).each do |counter| 
      item = Item.create! :original_id => counter, :list => @list, :assoc => :items
      @list.items << item
    end
  end

  after :each do
    Mongoid.database.collections.each do |coll|
      coll.remove
    end
  end

  def subject
    @list.items    
  end

  def subject_list
    @list    
  end

  def subject2
    @list2.items    
  end

  def subject3
    @list3.items    
  end

  def eql_arrays?(first, second)
    first.map{|i| i._id}.to_set == second.map{|i| i._id}.to_set
  end

  def get_positions list
    list.items.sort{ |x,y| x.pos <=> y.pos}.map(&:original_id)  
  end
  
  context "4 list items (1,2,3,4) that have parent_id pointing to first list container"  do
    describe '# initial configuration' do
      it "should list items 1 to 4 in order" do
        positions = get_positions subject_list 
        positions.should == [1, 2, 3, 4]
      end
    end
  end

  describe '#reordering' do
    it "should move item 2 to position 3" do  
      subject.where(:original_id => 2).first.move_lower            
      get_positions(subject_list).should == [1, 3, 2, 4]
    end
      
    it "should move item 2 to position 1" do    
      subject.where(:original_id => 2).first.move_higher
      get_positions(subject_list).should == [2, 1, 3, 4]  
    end 
      
    it "should move item 1 to bottom" do    
      subject.where(:original_id => 1).first.move_to_bottom
      get_positions(subject_list).should == [2, 3, 4, 1]  
    end
    
    it "should move item 1 to top" do    
      subject.where(:original_id => 1).first.move_to_top
      get_positions(subject_list).should == [1, 2, 3, 4]  
    end
    
    it "should move item 2 to bottom" do    
      subject.where(:original_id => 2).first.move_to_bottom
      get_positions(subject_list).should == [1, 3, 4, 2]  
    end
    
    it "should move item 4 to top" do    
      subject.where(:original_id => 4).first.move_to_top
      get_positions(subject_list).should == [4, 1, 2, 3]  
    end 
      
    it "should move item 3 to bottom" do
      get_positions(subject_list).should == [1, 2, 3, 4]      
         
      subject.where(:original_id => 3).first.move_to_bottom
      get_positions(subject_list).should == [1, 2, 4, 3]  
    end     
  end

     
  describe 'relative position queries' do
    it "should find item 2 to be lower item of item 1" do
      expected = subject.where(:pos => 2).first
      subject.where(:pos => 1).first.lower_item.should == expected
    end
  
    it "should not find any item higher than nr 1" do
      subject.where(:pos => 1).first.higher_item.should == nil
    end
  
    it "should find item 3 to be higher item of item 4" do
      subject.where(:pos => 4).first.higher_item.should == subject.where(:pos => 3).first
    end
  
    it "should not find item lower than item 4" do            
      subject.where(:pos => 4).first.lower_item.should == nil
    end
  end

  describe '#insert' do
    it "should let single lonely new item be the first item" do                                        
      puts "parent_id: #{@list3._id}"
      lm = Item.create! :original_id => 1, :list => @list3, :assoc => :items, :parent_id => @list3._id
      lm.pos.should == 1
      lm.first?.should be_true
    end
  
    it "should let single lonely new item be the last item" do
      lm = Item.create! :original_id => 1, :list => @list3, :assoc => :items, :parent_id => @list3.id
      lm.pos.should == 1
      lm.last?.should be_true
    end
  
    it "should not the second added item be the first item" do
      lm = Item.create :original_id => 1, :list => @list3, :assoc => :items, :parent_id => @list3._id
      lm2 = Item.create :original_id => 2, :list => @list3, :assoc => :items, :parent_id => @list3._id 

      @list3.items << lm
      @list3.items << lm2

      # VIGTIGT!
      puts "Parent: #{ lm._parent._id}"
      puts "Parent 2: #{ lm2._parent._id}"
                  
      lm2.pos.should == 2
      lm2.first?.should be_false
      lm2.last?.should be_true
    end
  #   
  #   it "should let second added item with parent=0 be the first item" do
  #     lm = Item.create(:parent_id => @list3.id)
  #     lm2 = Item.create(:parent_id => @list2.id)
  #     lm2.pos.should == 1
  #     lm2.first?.should be_true
  #     lm2.last?.should be_true
  #   end    
  end  
  # 
  # describe '#insert at' do
  # 
  #   it "should use insert_at as expected" do
  #     lm = Item.create(:parent_id => @list3.id)
  #     lm.pos.should == 1
  # 
  #     lm = Item.create(:parent_id => @list3.id)
  #     lm.pos.should == 2
  # 
  #     lm = Item.create(:parent_id => @list3.id)
  #     lm.pos.should == 3
  #     
  #     lm4 = Item.create(:parent_id => @list3.id)
  #     lm4.pos.should == 4
  #     
  #     lm4.insert_at(3)
  #     lm4.pos.should == 3
  # 
  #     lm.reload
  #     lm.pos.should == 4
  # 
  #     lm.insert_at(2)
  #     lm.pos.should == 2
  # 
  #     lm4.reload
  #     lm4.pos.should == 4
  # 
  #     lm5 = Item.create(:parent_id => @list3.id)
  #     lm5.pos.should == 5
  # 
  #     lm5.insert_at(1)
  #     lm5.pos.should == 1
  # 
  #     lm4.reload
  #     lm4.pos.should == 5
  #           
  #   end 
  # end   
  # 
  # describe 'delete middle' do
  #   it "should delete items as expected" do
  #     get_positions(Item).should == [1, 2, 3, 4]
  #     Item.where(:original_id => 2).first.destroy    
  #     get_positions(Item).should == [1, 3, 4]
  #     Item.where(:original_id => 1).first.destroy    
  #     get_positions(Item).should == [3, 4]
  #   end
  # end  
end
