require 'mixin'

class ListMixin < Mixin
  include ActsAsList::Mongoid

  acts_as_list :column => "pos", :scope => :parent  
end

class ListMixinSub1 < ListMixin
end

class ListMixinSub2 < ListMixin
end
