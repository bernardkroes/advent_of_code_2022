lines = File.read('day_7_input.txt').split("\n")
# lines = File.read('day_7_test_input.txt').split("\n")

sizes = {}
cur_dir = "/"
sizes[cur_dir] = 0
lines.each do |line|
  if line == "$ cd /"
    cur_dir = "/"
  elsif line.start_with?("$ cd ")
    if line == "$ cd .."
      cur_dir = cur_dir[0..(cur_dir.rindex("/") - 1)]
    else
      cur_dir += "/" + line.gsub("$ cd ","")
    end
    sizes[cur_dir] = 0 unless sizes.has_key?(cur_dir)
  elsif line.gsub(/[^0-9]*/,"").to_i > 0
    the_size = line.gsub(/[^0-9]*/,"").to_i
    sizes.each do |k, v|
      sizes[k] += the_size if cur_dir.start_with?(k)
    end
  end
end

total = 0
sizes.each do |k, v|
  total += v if v < 100000
end
puts total

unused_space = 70000000 - sizes["/"]
required_extra_space = 30000000 - unused_space
smallest = 30000000
sizes.each do |k, v|
  if v > required_extra_space && v < smallest
    smallest = v
  end
end
puts smallest
