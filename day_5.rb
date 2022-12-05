stacklines, instructions = File.read('day_5_input.txt').split("\n\n").map { |ll| ll.split("\n") }
# stacklines, instructions = File.read('day_5_test_input.txt').split("\n\n").map { |ll| ll.split("\n") }

# parse and compose the stacks
num_stacks = stacklines.last.split(" ").map(&:to_i).max
stacks = Array.new(num_stacks, "") # use strings for stacks

stacklines.pop
stacklines.each do |line|
  num_stacks.times do |s|
    val = line.split("")[4 * s + 1]
    stacks[s] = val + stacks[s] if ('A'..'Z').include?(val)
  end
end

# do the  moves
instructions.each do |line|
  num, src, dst = line.scan(/\d+/).map(&:to_i)          # or: num, src, dst = line.gsub(/[a-z]*/,"").split(" ").map(&:to_i)
  stacks[dst - 1] += stacks[src - 1][(-num)..].reverse  # this line for part 1
  # stacks[dst - 1] += stacks[src - 1][(-num)..]        # this line for part 2
  stacks[src - 1] = stacks[src - 1][0..(-num -1)]

  # show stacks in terminal:
  puts "\e[H\e[2J" # clear the terminal for more fun
  stacks.each do |s|
    puts "\033[0;32m#{s[0..-2]}\033[0m#{s[-1]}"
  end
  sleep(0.2/24.0)
end

puts "\n"
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
