all_elves = File.read('day_1_input.txt').split("\n\n")

sums = []
all_elves.each do |elf|
  sums << elf.split("\n").map(&:to_i).sum
end
# or: sums = all_elves.map { |elf| elf.split("\n").map(&:to_i).sum }

puts sums.max
puts sums.sort[-3..].sum
# or: puts sums.max(3).sum
