class AvailabilityChange
  attr_accessor :beds, :start_date, :end_date

  def initialize(beds, start_date, end_date)
    @beds = beds
    @start_date = start_date
    @end_date = end_date
  end

end