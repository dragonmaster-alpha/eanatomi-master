class Postnord::Servicepoint::Hour
  attr_accessor :days, :from, :to

  def day
    if days.length > 1
      "#{Postnord::Servicepoint::Hour.short_day(days.first)}-#{Postnord::Servicepoint::Hour.short_day(days.last)}"
    else
      days.first
    end
  end

  def time
    "#{Postnord::Servicepoint::Hour.parse_time(from)}-#{Postnord::Servicepoint::Hour.parse_time(to)}"
  end

  def self.from_json(json)
    json ||= {}
    hours = json.map do |data|
      self.new.tap do |hour|
        hour.days = [parse_day(data['day'])]
        hour.from = data['from1']
        hour.to = data['to1']
      end
    end

    group_hours hours
  end

  def self.group_hours(hours)
    new_hours = []

    hours.each_with_index do |hour, i|
      if new_hours.last && hour.from == new_hours.last.from && new_hours.last.to == hour.to
        new_hours.last.days += hour.days
      else
        new_hours << hour
      end
    end

    new_hours
  end

  def self.short_day(day)
    day[0..2]
  end

  def self.parse_day(day)
    {
      'MO' => 'mandag',
      'TU' => 'tirsdag',
      'WE' => 'onsdag',
      'TH' => 'torsdag',
      'FR' => 'fredag',
      'SA' => 'lørdag',
      'SU' => 'søndag'
    }[day]
  end

  def self.parse_time(time)
    time.insert 2, '.'
    time.gsub /\A0/, ''
  end


end
