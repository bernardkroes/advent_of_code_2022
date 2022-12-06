chars = File.read('day_6_input.txt').split("")

marker_length = 4      # use this line for part 2
#marker_length = 14    # use this line for part 2

# end_pos = marker_length - 1
# chars[0..-end_pos].each_with_index do |_, i|
#   if chars[i..(i+end_pos)].uniq.count == marker_length
#     puts i + marker_length
#     exit
#   end
# end

chars.each_cons(marker_length).with_index do |g, i|
  if g.uniq.count == marker_length
    puts i + marker_length
    exit
  end
end

