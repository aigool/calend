class Event < ActiveRecord::Base
  include IceCube
  serialize :schedule, Hash

  belongs_to :user

  validates :title, :presence => true,
                    :length => { :minimum => 5 }
  validates :shedule, :presence => true

  scope :user, lambda { |user| user ? where(:user_id => user) : where("user_id IS NOT NULL") }

  #before_save do
  #  self.repeat = Event.schedule(self.shedule, Event.available_repeats[self.repeat.to_i] ).to_hash
  #end

  def self.available_repeats
  	rule = [Rule.daily, Rule.weekly, Rule.monthly, Rule.yearly]
  	return rule
  end

  def self.events_with_repeats(date, user)
    start_date = date.beginning_of_month - 6.days
    end_date = date.end_of_month + 6.days

    # Events that no repeat
    no_repeat = where(:repeat => [nil], shedule: start_date..end_date).user(user)

    # Repeated events that created till current month
    r_events = Event.where("shedule <= ?", end_date).user(user).where("`repeat` IS NOT NULL")
    
    repeats = []
    r_events.each do |event|
      schedule = Event.schedule(event.shedule, event.repeat)
      if schedule
        schedule.occurrences(end_date).each do |elem|
          if elem >= start_date
            repeat_event = Marshal.load(Marshal.dump(event)) # deep_copy
            repeat_event.shedule = elem
            repeats << repeat_event
          end
        end
      end
    end

    return no_repeat + repeats
  end

  def self.schedule(date, repeat)
    new_schedule = Schedule.new(date) 
    if Event.available_repeats.map{ |r| r.to_s.downcase }.include? (repeat ? repeat.downcase : nil)
      rule = eval('Rule.'+repeat.downcase)
      new_schedule.add_recurrence_rule rule
      return new_schedule
    else 
      return nil
    end
  end

end
