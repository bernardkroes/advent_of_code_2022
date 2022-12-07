lines = File.read('day_7_input.txt').split("\n")
# lines = File.read('day_7_test_input.txt').split("\n")

sizes = Hash.new(0)
dirs = ["root"] # a stack of current dirnames that we have followed

lines.each do |line|
  if line == "$ cd /"
    dirs = ["root"]
  elsif line.start_with?("$ cd ")
    if line == "$ cd .."
      dirs.pop
    else
      dirs.push(line.split.last)
    end
  else # it is a file (or ls command that does not contain any digits)
    filesize = line.gsub(/[^0-9]*/,"").to_i
    1.upto(dirs.size) do |i|
      key = dirs.first(i).join("/")
      sizes[key] += filesize
    end
  end
end

# part 1
puts sizes.values.select { |v| v < 100000 }.sum

# part 2
unused_space = 70000000 - sizes["root"]
required_extra_space = 30000000 - unused_space # or: sizes["root"] - 40000000
puts sizes.values.select { |v| v > required_extra_space }.min
