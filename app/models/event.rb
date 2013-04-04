class Event < ActiveRecord::Base

  belongs_to :user

  validates :title, :presence => true,
                    :length => { :minimum => 5 }
  validates :shedule, :presence => true

  scope :till, lambda { |date| where("shedule <= ?", date.end_of_month ) }
  scope :start, lambda { |date| where("shedule >= ?", date.beginning_of_month ) }
  scope :user, lambda { |user| user ? where(:user_id => user) : where("user_id IS NOT NULL") }


  def self.events_and_repeats(date, user)
    # Events that no repeat
    no_repeat = where(:repeat => [nil, 'none']).start(date).till(date).user(user)

    # Every day repeated events that created till current month
    dr = where(:repeat => 'daily' ).till(date).user(user)
	d_repeats = []
	for every_day_event in(dr)
	  for day in(1..date.end_of_month.day)
	    new_date = Date.new(date.year, date.month, day)
	    if every_day_event.shedule <= new_date
	      repeat_event = Marshal.load(Marshal.dump(every_day_event)) # deep_copy
	      repeat_event.shedule = new_date
	      d_repeats << repeat_event
	    end
	  end
	end

    # Every month repeated events that created till current month
    mr = where(:repeat => 'monthly' ).till(date).user(user)
    m_repeats = []
	for elem in(mr)
	  if elem.shedule.day <= date.end_of_month.day
	    elem.shedule = Date.new(date.year, date.month, elem.shedule.day)
	  	m_repeats << elem
	  end
	end

	# Every year repeated events that created till current month and have same month
	#yr = where(:repeat => 'yearly').where("MONTH(shedule) = ? ", date.month).till(date).user(user)
	yr = where(:repeat => 'yearly').till(date).user(user)
	y_repeats = []
	for elem in(yr)
	  if elem.shedule.day <= date.end_of_month.day
	    elem.shedule = Date.new(date.year, elem.shedule.month, elem.shedule.day)
	  	y_repeats << elem
	  end
	end

    return no_repeat + d_repeats + m_repeats + y_repeats
  end

end
