all_lines = File.read('day_3_input.txt').split("\n")
# all_lines = File.read('day_3_test_input.txt').split("\n")

sum = 0
all_lines.each do |line|
  ll = line.size / 2
  first_half = line[0..ll-1]
  second_half = line[ll..-1]
  combined = first_half.split("").uniq + second_half.split("").uniq
  duplicate = combined.select { |e| combined.count(e) > 1 }.uniq[0]
  if ('a'..'z').include?(duplicate)
    sum += duplicate.ord - 'a'.ord + 1
  else 
    sum += duplicate.ord - 'A'.ord + 27
  end
end
puts sum

# part 2
sum = 0
(all_lines.size / 3).times do |i|
  ll = i * 3
  the_line = all_lines[ll].split("").uniq + all_lines[ll+1].split("").uniq + all_lines[ll+2].split("").uniq
  badge = the_line.select { |e| the_line.count(e) == 3 }.uniq[0]
  if ('a'..'z').include?(duplicate)
    sum += badge.ord - 'a'.ord + 1
  else 
    sum += badge.ord - 'A'.ord + 27
  end
end

puts sum
