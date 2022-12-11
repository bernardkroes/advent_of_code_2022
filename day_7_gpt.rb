lines = File.read('day_7_input.txt').split("\n")
# lines = File.read('day_7_test_input.txt').split("\n")

sizes = Hash.new(0)
current_path = "root"

lines.each do |line|
  if line == "$ cd /"
    current_path = "root"
  elsif line.start_with?("$ cd ")
    if line == "$ cd .."
      current_path = File.dirname(current_path)
    else
      current_path = File.join(current_path, line.split.last)
    end
  else # it is a file (or ls command, but that does not contain any digits hopefully)
    filesize = line.scan(/\d+/).map(&:to_i).sum
    sizes[current_path] += filesize
  end
end

# part 1
puts sizes.values.select { |v| v < 100000 }.sum

# part 2
unused_space = 70000000 - sizes["root"]
required_extra_space = 30000000 - unused_space # or: sizes["root"] - 40000000
puts sizes.values.select { |v| v > required_extra_space }.min
