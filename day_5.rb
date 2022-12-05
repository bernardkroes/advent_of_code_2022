all_lines = File.read('day_5_input.txt').split("\n")
# all_lines = File.read('day_5_test_input.txt').split("\n")

# use strings for te stacks
stacks = Array.new(9, "")

# compose the stacks
all_lines.each do |line|
  if line.start_with?(" 1")
    break
  end
  0.upto(8) do |p|
    val = line.split("")[4 * p + 1]
    stacks[p] = val + stacks[p] if ('A'..'Z').include?(val)
  end
end

# do the  moves
all_lines.each do |line|
  if line.start_with?("move")
    num, source, dest = line.gsub(/[a-z]*/,"").split(" ").map(&:to_i)
    stacks[dest - 1] += stacks[source-1][(-1*num)..].reverse   # this line for part 1
    # stacks[dest - 1] += stacks[source-1][(-1*num)..]         # this line for part 2
    stacks[source - 1] = stacks[source - 1][0..(-1*num -1)]
  end
end

res = ""
stacks.each do |s|
  res += s[-1]
end
puts res

__END__

    [D]    
[N] [C]    
[Z] [M] [P]
 1   2   3 

move 1 from 2 to 1
move 3 from 1 to 3
move 2 from 2 to 1
move 1 from 1 to 2
