class Entry < ActiveRecord::Base
  belongs_to :user
  attr_accessible :task, :completed, :due_date, :priority
end
