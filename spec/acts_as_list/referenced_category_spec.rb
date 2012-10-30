require 'spec_helper'

ActsAsList::Mongoid.default_position_column = :pos
require 'referenced_category'

describe 'ActsAsList for Mongoid' do

  before :each do
    @category = Category.create!
    @category.categories = []
    (1..4).each do |counter|
      @category.categories << Category.new(:number => counter)
    end
    @category.save!

    @category.categories.init_list!
  end

  after :each do
    Category.mongo_session.drop
  end

  def get_positions(category)
    category.reload.categories.sort.map(&:number)
  end

  context "4 category categories (1,2,3,4) that have parent_id pointing to first category container" do
    describe '# initial configuration' do
      it "should category categories 1 to 4 in order" do
        positions = get_positions @category
        positions.should == [1, 2, 3, 4]
      end
    end

    describe '#reordering' do
      it "should move item 2 to position 3" do
        @category.categories[1].increment_position
        @category.categories[2].decrement_position
        get_positions(@category).should == [1, 3, 2, 4]
      end


      it "should move item 2 to position 3 directly" do
        Category.where(:number => 2).first.move_lower
        get_positions(@category).should == [1, 3, 2, 4]
      end

      it "move :down should move item 2 to position 3" do
        Category.where(:number => 2).first.move(:down)
        get_positions(@category).should == [1, 3, 2, 4]
      end

      it "move :lower should move item 2 to position 3" do
        Category.where(:number => 2).first.move(:lower)
        get_positions(@category).should == [1, 3, 2, 4]
      end

      it "should move item 2 to position 1" do
        Category.where(:number => 2).first.move_higher
        get_positions(@category).should == [2, 1, 3, 4]
      end

      it "move :up should move item 2 to position 1" do
        Category.where(:number => 2).first.move(:up)
        get_positions(@category).should == [2, 1, 3, 4]
      end

      it "move :higher should move item 2 to position 1" do
        Category.where(:number => 2).first.move(:higher)
        get_positions(@category).should == [2, 1, 3, 4]
      end

      it "should move item 1 to bottom" do
        Category.where(:number => 1).first.move_to_bottom
        get_positions(@category).should == [2, 3, 4, 1]
      end

      it "move :lowest should move item 1 to bottom" do
        Category.where(:number => 1).first.move(:lowest)
        get_positions(@category).should == [2, 3, 4, 1]
      end

      it "should move item 1 to top" do
        Category.where(:number => 1).first.move_to_top
        get_positions(@category).should == [1, 2, 3, 4]
      end

      it "move :highest should move item 1 to top" do
        Category.where(:number => 1).first.move(:highest)
        get_positions(@category).should == [1, 2, 3, 4]
      end

      it "move :unknown should cause argument error" do
        lambda {Category.where(:number => 1).first.move(:unknown)}.should raise_error
      end

      it "should move item 2 to bottom" do
        Category.where(:number => 2).first.move_to_bottom
        get_positions(@category).should == [1, 3, 4, 2]
      end

      it "should move item 4 to top" do
        Category.where(:number => 4).first.move_to_top
        get_positions(@category).should == [4, 1, 2, 3]
      end

      it "should move item 3 to bottom" do
        Category.where(:number => 3).first.move_to_bottom
        get_positions(@category).should == [1, 2, 4, 3]
      end

      it "categories[2].move_to(4) should move item 2 to position 4" do
        Category.where(:number => 2).first.move_to(4)
        get_positions(@category).should == [1, 3, 4, 2]
      end

      it "categories[2].insert_at(3) should move item 2 to position 3" do
        Category.where(:number => 2).first.insert_at(3)
        get_positions(@category).should == [1, 3, 2, 4]
      end

      it "categories[2].move(:to => 3) should move item 2 to position 3" do
        Category.where(:number => 2).first.move(:to => 3)
        get_positions(@category).should == [1, 3, 2, 4]
      end

      it "categories[1].move_below(item[2]) should move item 1 to position 2" do
        item2 = Category.where(:number => 2).first
        Category.where(:number => 1).first.move_below(item2)
        get_positions(@category).should == [2, 1, 3, 4]
      end

      it "categories[3].move_below(item[1]) should move item 3 to position 2" do
        item1 = Category.where(:number => 1).first
        Category.where(:number => 3).first.move_below(item1)
        get_positions(@category).should == [1, 3, 2, 4]
      end

      it "categories[3].move_above(item[2]) should move item 3 to position 2" do
        item2 = Category.where(:number => 2).first
        Category.where(:number => 3).first.move_above(item2)
        get_positions(@category).should == [1, 3, 2, 4]
      end

      it "categories[1].move_above(item[3]) should move item 1 to position 2" do
        item3 = Category.where(:number => 3).first
        Category.where(:number => 1).first.move_above(item3)
        get_positions(@category).should == [2, 1, 3, 4]
      end

    end

    describe 'relative position queries' do
      it "should find item 2 to be lower item of item 1" do
        expected = Category.where(:pos => 2).first
        Category.where(:pos => 1).first.lower_item.should == expected
      end

      it "should not find any item higher than nr 1" do
        Category.where(:pos => 1).first.higher_item.should == nil
      end

      it "should find item 3 to be higher item of item 4" do
        expected = Category.where(:pos => 3).first
        Category.where(:pos => 4).first.higher_item.should == expected
      end

      it "should not find item lower than item 4" do
        Category.where(:pos => 4).first.lower_item.should == nil
      end
    end
  end
end
