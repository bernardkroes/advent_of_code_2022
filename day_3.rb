all_lines = File.read('day_3_input.txt').split("\n")
# all_lines = File.read('day_3_test_input.txt').split("\n")

def priority(el)
  return el.ord - 'a'.ord + 1  if ('a'..'z').include?(el)
  return el.ord - 'A'.ord + 27 if ('A'..'Z').include?(el)
  0
end

sum = 0
all_lines.each do |line|
  ll = line.size / 2
  first_half, second_half = line[0..ll-1], line[ll..-1]
  combined = first_half.split("") & second_half.split("")
  sum += priority(combined[0])
end
puts sum

# part 2
sum = 0
all_lines.each_slice(3) do |g|
  # or:  combined = g[0].split("") & g[1].split("") & g[2].split("")
  combined = g.collect {|e| e.split("") }.reduce(:&)
  sum += priority(combined[0])
end
puts sum
