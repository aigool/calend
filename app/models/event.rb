class Event < ActiveRecord::Base
  belongs_to :user

  validates :title, :presence => true,
                    :length => { :minimum => 5 }
  validates :shedule, :presence => true

end
