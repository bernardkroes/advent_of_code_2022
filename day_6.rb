chars = File.read('day_6_input.txt').split("")

marker_length = 4      # use this line for part 2
#marker_length = 14    # use this line for part 2

start_pos = marker_length - 1
chars[start_pos..-start_pos].each_with_index do |_, i|
  if chars[i..(i+start_pos)].uniq.count == marker_length
    puts i + marker_length
    exit
  end
end
