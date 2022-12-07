lines = File.read('day_7_input.txt').split("\n")
# lines = File.read('day_7_test_input.txt').split("\n")

sizes = {}
dirs =["root"] # a stack of dirnames that we have followd

sizes[dirs.join("/")] = 0
lines.each do |line|
  if line == "$ cd /"
    dirs =["root"]
  elsif line.start_with?("$ cd ")
    if line == "$ cd .."
      dirs.pop
    else
      dirs.push(line.split.last)
    end
    sizes[dirs.join("/")] ||= 0
  else # it is a file
    filesize = line.gsub(/[^0-9]*/,"").to_i
    dirs.each_with_index do |_,i|
      key = dirs[0..i].join("/")
      sizes[key] += filesize
    end
  end
end

# part 1
puts sizes.values.select { |v| v < 100000 }.sum

# part 2
unused_space = 70000000 - sizes["root"]
required_extra_space = 30000000 - unused_space
puts sizes.values.select { |v| v > required_extra_space }.min
