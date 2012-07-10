class Category
  include Mongoid::Document
  include Mongoid::Timestamps
  include ActsAsList::Mongoid

  field :number, :type => Integer

  # field :pos, :type => Integer
  # acts_as_list :column => :pos

  #many should below in, or we will get:
  #NoMethodError:
  #       undefined method `entries' for #<Category:0x9acbaa8>
  belongs_to :category
  has_many :categories

  def scope_condition
    {:category_id => category.id, :pos.ne => nil}
  end
end
