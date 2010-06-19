class TimestampRef
  attr_reader :timestamp
  
  def initialize(value)
    case namespace(value)
    when "now"
      @timestamp = Time.now
    end
  end

  private

  def namespace(value)
    value.match(/^([^:]+)/)[1]
  end
  
  def timestamp_value(value)
    value.match(/:(.*)/)[1]
  end
end
