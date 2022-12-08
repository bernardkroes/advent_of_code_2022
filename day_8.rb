lines = File.read('day_8_input.txt').split("\n")
# lines = File.read('day_8_test_input.txt').split("\n")

grid = []
lines.each do |line|
  grid << line.split("").map(&:to_i)
end
the_size = grid[0].size

def key_for(x,y)
  [x,y] #  or: "#{x}_#{y}"
end

found = {}
grid.each_with_index do |line, y|
  line.each_with_index do |height, x|
    if x == 0 || x == the_size - 1
      found[key_for(x,y)] = 1
    else
      if height > line[0...x].max || height > line[(x+1)..].max
        found[key_for(x,y)] = 1
      end
    end
  end
end
# swap the x and y params!
grid.transpose.each_with_index do |line, x|
  line.each_with_index do |height, y|
    if y == 0 || y == the_size - 1
      found[key_for(x,y)] = 1
    else
      if height > line[0...y].max || height > line[(y+1)..].max
        found[key_for(x,y)] = 1
      end
    end
  end
end
puts found.size

# part 2
max_score = 0
grid.each_with_index do |line, y|
  line.each_with_index do |height, x|
    left, right, up, down = 0, 0, 0, 0

    (x-1).downto(0) do |walk_x| # to the left
      left += 1
      break if line[walk_x] >= height
    end

    (x+1).upto(the_size - 1) do |walk_x| # to the right
      right += 1
      break if line[walk_x] >= height
    end

    (y-1).downto(0) do |walk_y| # upwards
      up += 1
      break if grid[walk_y][x] >= height
    end

    (y+1).upto(the_size - 1) do |walk_y| # downwards
      down += 1
      break if grid[walk_y][x] >= height
    end

    score = left * right * up * down
    max_score = score if score > max_score
  end
end
puts max_score

