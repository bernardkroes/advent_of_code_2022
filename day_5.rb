stacklines, instructions = File.read('day_5_input.txt').split("\n\n")
# stacklines, instructions = File.read('day_5_test_input.txt').split("\n\n")

# parse and compose the stacks
stacks = Array.new(9, "") # use strings for stacks
stacklines.split("\n").each do |line|
  break if line.start_with?(" 1")

  0.upto(8) do |p|
    val = line.split("")[4 * p + 1]
    stacks[p] = val + stacks[p] if ('A'..'Z').include?(val)
  end
end

# do the  moves
instructions.split("\n").each do |line|
  num, source, dest = line.gsub(/[a-z]*/,"").split(" ").map(&:to_i)
  stacks[dest - 1] += stacks[source-1][(-1*num)..].reverse   # this line for part 1
  # stacks[dest - 1] += stacks[source-1][(-1*num)..]         # this line for part 2
  stacks[source - 1] = stacks[source - 1][0..(-1*num -1)]
end

puts stacks.collect { |s| s[-1] }.join

__END__

    [D]    
[N] [C]    
[Z] [M] [P]
 1   2   3 

move 1 from 2 to 1
move 3 from 1 to 3
move 2 from 2 to 1
move 1 from 1 to 2
