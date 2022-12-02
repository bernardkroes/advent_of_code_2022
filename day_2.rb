all_lines = File.read('day_2_input.txt').split("\n")
# all_lines = File.read('day_2_test_input.txt').split("\n")

total = 0
all_lines.each do |line|
  p1c, p2c = line.split()
  p1 = p1c.ord - "A".ord # zero based
  p2 = p2c.ord - "X".ord

  line_score = p2 + 1 # compensate for the zerobasedness
  line_score += 3 if p2 == p1
  line_score += 6 if ((p2 - p1) % 3) == 1

  total += line_score
end
puts total

# part 2
total = 0
all_lines.each do |line|
  p1c, p2c = line.split()
  p1 = p1c.ord - "A".ord # zero based
  p2 = p2c.ord - "X".ord

  # score
  line_score = [0,3,6][p2] # or: p2 * 3
  # piece
  line_score += 1       # compensate for the zerobasedness
  delta = [-1,0,1][p2]  # or: p2 - 1
  line_score += (p1 + delta) % 3 

  total += line_score  # or in one line:  total += 1 + p2 * 3 + (p1 + p2 - 1) % 3
end
puts total

__END__
12493
