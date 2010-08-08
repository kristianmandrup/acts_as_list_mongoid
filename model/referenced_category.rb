class Category
  include Mongoid::Document
  include Mongoid::Timestamps
  include ActsAsList::Mongoid

  field :number, :type => Integer

  field :pos, :type => Integer
  acts_as_list :column => :pos

  references_many :categories
  referenced_in :category

  def scope_condition
    {:category_id => category.id, :pos.ne => nil}
  end
end