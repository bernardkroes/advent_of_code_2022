all_lines = File.read('day_15_input.txt').split("\n")
# all_lines = File.read('day_15_test_input.txt').split("\n")

sensors = []
beacons = []
dists = []
all_lines.each do |line|
  all_ints = line.scan(/[0-9+\-]+/).map(&:to_i)
  sensors << [all_ints[0], all_ints[1]]
  beacons << [all_ints[2], all_ints[3]]
  dists << (all_ints[0] - all_ints[2]).abs + (all_ints[1] - all_ints[3]).abs
end

def is_covered?(sensors, dists, x, y)
  sensors.each_with_index do |s,i|
    return true if (s[0] - x).abs + (s[1] - y).abs <= dists[i]
  end
  false
end

min_x, max_x = sensors.collect { |s| s[0]}.minmax
max_d = dists.max

y = 2000000
count = 0

(min_x - max_d).upto(max_x + max_d) do |x|
  if is_covered?(sensors, dists, x, y)
    if !sensors.any? { |s| s[0] == x && s[1] == y} && !beacons.any? { |b| b[0] == x && b[1] == y}
      count += 1
    end
  end
end
puts count

# part 2: only search around the borders
limit = 4000000

sensors.each_with_index do |s,i|
  s_x, s_y = s[0], s[1]
  the_check_dist = dists[i] + 1
  (-the_check_dist).upto(the_check_dist) do |delta_x|
    delta_y = the_check_dist - delta_x

    the_x = s_x + delta_x
    next if the_x < 0 || the_x > limit

    the_y1 = s_y + delta_y
    next if the_y1 < 0 || the_y1 > limit
    if !is_covered?(sensors, dists, the_x, the_y1)
      puts  the_x * 4000000 + the_y1
      exit
    end

    the_y2 = s_y - delta_y
    next if the_y2 < 0 || the_y2 > limit
    if !is_covered?(sensors, dists, the_x, the_y2)
      puts the_x * 4000000 + the_y2
      exit
    end
  end
end

