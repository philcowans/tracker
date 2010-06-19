class TleSet
  def lookup_source(id)
    return_value = nil

    index = 0
    current_lines = []

    File.open("#{RAILS_ROOT}/db/visual.txt").each do |line|
      current_lines[index] = line
      if index == 2
        if current_lines[1] =~ /^..#{id}/
          return_value = current_lines
        end
        current_lines = []
      end
      index = (index + 1) % 3
    end

    return return_value
  end
end
