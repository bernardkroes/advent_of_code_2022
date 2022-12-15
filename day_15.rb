all_lines = File.read('day_15_input.txt').split("\n")
# all_lines = File.read('day_15_test_input.txt').split("\n")

sensors = {}
beacons = []

all_lines.each do |line|
  all_ints = line.scan(/[0-9+\-]+/).map(&:to_i)
  sensor = [all_ints[0], all_ints[1]]
  dist = (all_ints[0] - all_ints[2]).abs + (all_ints[1] - all_ints[3]).abs

  sensors[sensor] = dist
  beacons << [all_ints[2], all_ints[3]]
end

def is_covered?(sensors, x, y)
  sensors.each do |s, dist|
    return true if (s[0] - x).abs + (s[1] - y).abs <= dist
  end
  false
end

min_x, max_x = sensors.keys.collect { |s| s[0]}.minmax
max_d = sensors.values.max

y = 2000000
count = 0

(min_x - max_d).upto(max_x + max_d) do |x|
  if is_covered?(sensors, x, y)
    if !sensors.include?([x,y]) && !beacons.include?([x,y])
      count += 1
    end
  end
end
puts count

# part 2: only search around the borders
limit = 4000000

sensors.each do |s, dist|
  s_x, s_y = s[0], s[1]

  the_check_dist = dist + 1
  (-the_check_dist).upto(the_check_dist) do |delta_x|
    delta_y = the_check_dist - delta_x

    the_x = s_x + delta_x
    next if the_x < 0 || the_x > limit

    [-1, 1].each do |sign|
      the_y = s_y + sign * delta_y
      next if the_y < 0 || the_y > limit
      if !is_covered?(sensors, the_x, the_y)
        puts  the_x * 4000000 + the_y
        exit
      end
    end
  end
end

