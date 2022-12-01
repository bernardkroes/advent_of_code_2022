all_elves = File.read('day_1_input.txt').split("\n\n")

sums = []
all_elves.each do |elf|
  sums << elf.split("\n").map(&:to_i).sum
end

puts sums.max
puts sums.sort[-3..-1].sum
