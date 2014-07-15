class AbstractAccount <  ActiveRecord::Base
  belongs_to :user
  validates_presence_of :user_id
  self.abstract_class = true
end