all_lines = File.read('day_3_input.txt').split("\n")
# all_lines = File.read('day_3_test_input.txt').split("\n")

def priority(el)
  if ('a'..'z').include?(el)
    return el.ord - 'a'.ord + 1
  else 
    return el.ord - 'A'.ord + 27
  end
end

sum = 0
all_lines.each do |line|
  ll = line.size / 2
  first_half = line[0..ll-1]
  second_half = line[ll..-1]
  combined = first_half.split("").uniq & second_half.split("").uniq
  sum += priority(combined[0])
end
puts sum

# part 2
sum = 0
all_lines.each_slice(3) do |g|
  combined = g[0].split("").uniq & g[1].split("").uniq & g[2].split("").uniq
  sum += priority(combined[0])
end
puts sum
