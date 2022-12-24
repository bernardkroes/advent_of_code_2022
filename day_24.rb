all_lines = File.read('day_24_input.txt').split("\n")
# all_lines = File.read('day_24_test_input.txt').split("\n")

DELTA_MOVES = [[-1,0],[ 0,-1],[ 1,0],[0,1], [0,0]]
LEFT = 0
UP = 1
RIGHT = 2
DOWN = 3
WAIT = 4

grid = []
bbs = [] # starting positions x,y, dir

all_lines.each_with_index do |line, y|
  grid << []
  line.split("").each_with_index do |c, x|
    grid[y][x] = (c == "#" ? "#" : ".")
    the_dir = case c
      when "<" then LEFT
      when "^" then UP
      when ">" then RIGHT
      when "v" then DOWN
      else
        -1
    end
    bbs << [x,y,the_dir] if the_dir > -1
  end
end
size_x = grid[0].size
size_y = grid.size

def show_grid(grid, bbs)
  grid.each_with_index do |line, y|
    out = ""
    line.each_with_index do |c, x|
      if c == "#"
        out += "#"
      else
        ccs = []
        bbs.each do |b|
          if b[0] == x && b[1] == y
            the_char = case b[2]
              when LEFT then "<"
              when UP then "^"
              when RIGHT then ">"
              when DOWN then "v"
            end
            ccs << the_char
          end
        end
        if ccs.size == 1
          out += ccs[0]
        elsif ccs.size > 1
          out += ccs.size.to_s
        else
          out += "."
        end
      end
    end
    puts out
  end
end

def show_grid_simple(grid, exp_x, exp_y)
  grid.each_with_index do |line, y|
    out = ""
    line.each_with_index do |c, x|
      if x == exp_x && y == exp_y
        out += "E"
      else
        out += c
      end
    end
    puts out
  end
end

def possible_moves(grid, cur_x, cur_y)
  size_x = grid[0].size
  size_y = grid.size

  mm = []
  DELTA_MOVES.each do |m|
    next_x, next_y = cur_x + m[0], cur_y + m[1]
    if next_x >= 0 && next_x < size_x && next_y >= 0 && next_y < size_y && grid[next_y][next_x] == "."
      mm << m
    end
  end
  mm
end

# calculate the grids for the first 1000 minutes
grids = [Marshal.load(Marshal.dump(grid))]

# first add the start grid!
grid_for_this_minute = Marshal.load(Marshal.dump(grid))
bbs.each_with_index do |b, i|
  grid_for_this_minute[b[1]][b[0]] = "*"
end
grids << grid_for_this_minute

1000.times do |minute|
  grid_for_this_minute = Marshal.load(Marshal.dump(grid))
  bbs.each_with_index do |b, i|
    bx, by = b[0], b[1]

    bx = (bx + DELTA_MOVES[b[2]][0]) % size_x
    by = (by + DELTA_MOVES[b[2]][1]) % size_y
    while grid[by][bx] == "#"
      bx = (bx + DELTA_MOVES[b[2]][0]) % size_x
      by = (by + DELTA_MOVES[b[2]][1]) % size_y
    end
    bbs[i] = [bx, by, b[2]]
    grid_for_this_minute[by][bx] = "*"
  end
  grids << grid_for_this_minute
end

def shortest_path(grids, start_x, start_y, dst_x, dst_y, start_minute)
  shortest = 1000

  work_queue = []
  seen = {}

  mm = possible_moves(grids[start_minute + 1], start_x, start_y)
  mm.each do |m|
    work_queue << [start_x, start_y, m, start_minute]
  end

  while work_queue.size > 0
    the_x, the_y, m, the_minute = work_queue.shift

    next_x, next_y = the_x + m[0], the_y + m[1]
    if next_x == dst_x && next_y == dst_y
      shortest = the_minute if the_minute < shortest
    elsif the_minute < shortest
      the_minute += 1
      all_moves = possible_moves(grids[the_minute + 1], next_x, next_y, )
      all_moves.each do |next_m|
        if !seen.has_key?([next_x, next_y, next_m, the_minute])
#          work_queue.unshift([next_x, next_y, next_m, the_minute + 1 ])    # use this for DFS
          work_queue << [next_x, next_y, next_m, the_minute ]               # use this for BFS (faster for my input and implementation)
          seen[[next_x, next_y, next_m, the_minute]] = 1
        end
      end
    end
  end
  shortest
end

shortest = shortest_path(grids, 1, 0, size_x - 2, size_y - 1, 1)
puts "Part 1: #{shortest}"

# part 2
# back to start and to goal again

shortest = shortest_path(grids, size_x - 2, size_y - 1, 1, 0, shortest)
shortest = shortest_path(grids, 1, 0, size_x - 2, size_y - 1, shortest)
puts "Part 2: #{shortest}"
