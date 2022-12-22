DELTA_MOVES = [[ 1, 0], [0, 1], [ -1, 0], [0, -1]]
RIGHT = 0
DOWN = 1
LEFT = 2
UP = 3
FACE_SIZE = 50

class Grid
attr_accessor :grid, :cur_dir, :x_pos, :y_pos

def initialize(in_map_lines)
  @grid = []
  @cur_dir = 0
  in_map_lines.split("\n").each do |line|
    @grid << line
  end
  @x_pos, @y_pos = @grid[0].index("."), 0
  @max_x = @grid[0].size
  @max_y = @grid.size

  @grid.each_with_index do |line, i| # make all lines the same length by adding spaces (needed for part 1)
    @grid[i] = @grid[i] + " " * (@max_x - @grid[i].size) if @grid[i].size < @max_x
  end
end

def get_info
  @grid.each do |line|
    puts line
  end
  puts @x_pos, @y_pos, @cur_dir
end

def cube_move(steps, in_dir)# returns new x and y and dir
  stepped = 0
  the_x = @x_pos
  the_y = @y_pos
  the_dir = in_dir
  while stepped < steps
    next_x = the_x + DELTA_MOVES[the_dir][0]
    next_y = the_y + DELTA_MOVES[the_dir][1]
    prev_dir = the_dir

    x_tile, y_tile =  the_x / FACE_SIZE, the_y / FACE_SIZE
    next_x_tile, next_y_tile =  next_x / FACE_SIZE, next_y / FACE_SIZE

    if (next_x_tile != x_tile) || (next_y_tile != y_tile)
      # wrap
      x_in_tile = the_x % FACE_SIZE
      y_in_tile = the_y % FACE_SIZE

      wrappings = { # [tile_from_x, tile_from_y, dir] => [tile_to_x, tile_to_y, dir, operation (what to add and/or revert), new direction determines where to add the operation
        [1, 0, LEFT] => [0, 2, RIGHT, "-y"],
        [1, 0, UP] => [0, 3, RIGHT, "x"],

        [2, 0, RIGHT] => [1, 2, LEFT, "-y"],
        [2, 0, UP] => [0, 3, UP, "x"],
        [2, 0, DOWN] => [1, 1, LEFT, "x"],

        [1, 1, LEFT] => [0, 2, DOWN, "y"],
        [1, 1, RIGHT] => [2, 0, UP, "y"],

        [0, 2, LEFT] => [1, 0, RIGHT, "-y"],
        [0, 2, UP] => [1, 1, RIGHT, "x"],

        [1, 2, RIGHT] => [2, 0, LEFT, "-y"],
        [1, 2, DOWN] => [0, 3, LEFT, "x"],

        [0, 3, LEFT] => [1, 0, DOWN, "y"],
        [0, 3, RIGHT] => [1, 2, UP, "y"],
        [0, 3, DOWN] => [2, 0, DOWN, "x"],
      }
      if wrappings.has_key?([x_tile, y_tile, the_dir])
        wrap_x_tile, wrap_y_tile, the_dir, the_oper = wrappings[[x_tile, y_tile, the_dir]]
        next_x = wrap_x_tile * FACE_SIZE
        next_y = wrap_y_tile * FACE_SIZE
        the_add = case the_oper
          when "-y" then FACE_SIZE - y_in_tile - 1
          when "y"  then y_in_tile
          when "-x" then FACE_SIZE - x_in_tile - 1
          when "x"  then x_in_tile
        end
        if the_dir == RIGHT
          next_y += the_add
        elsif the_dir == UP
          next_x += the_add
          next_y += FACE_SIZE - 1
        elsif the_dir == LEFT
          next_x += FACE_SIZE - 1
          next_y += the_add
        elsif the_dir == DOWN
          next_x += the_add
        end
      end
    end
    stepped += 1
    return the_x, the_y, prev_dir if @grid[next_y][next_x] == "#"   # note the prev_dir !!! (aargh)
    the_x, the_y = next_x, next_y
  end
  return the_x, the_y, the_dir
end

def move(steps, in_dir) # returns new x and y
  stepped = 0
  the_x = @x_pos
  the_y = @y_pos
  while stepped < steps
    next_x = (the_x + DELTA_MOVES[in_dir][0]) % @max_x
    next_y = (the_y + DELTA_MOVES[in_dir][1]) % @max_y

    while @grid[next_y][next_x] == " "
      next_x = (next_x + DELTA_MOVES[in_dir][0]) % @max_x
      next_y = (next_y + DELTA_MOVES[in_dir][1]) % @max_y
    end
    stepped += 1
    return the_x, the_y if @grid[next_y][next_x] == "#"

    the_x, the_y = next_x, next_y
  end
  return the_x, the_y
end

end

map_lines, ins_line = File.read('day_22_input.txt').split("\n\n")
ins_line = ins_line.gsub("\n","")

grid = Grid.new(map_lines)

while ins_line.length > 0
  cs = ""
  while ins_line.length > 0 && ins_line[0] >='0' && ins_line[0] <= '9'
    cs << ins_line[0]
    ins_line = ins_line[1..]
  end

  # grid.x_pos, grid.y_pos = grid.move(cs.to_i, grid.cur_dir)                        # use this line for part 1
  grid.x_pos, grid.y_pos, grid.cur_dir = grid.cube_move(cs.to_i, grid.cur_dir)       # use this line for part 2

  if ins_line.length > 0
    delta_dir = ins_line[0]
    grid.cur_dir += 1 if delta_dir == "R"
    grid.cur_dir -= 1 if delta_dir == "L"

    grid.cur_dir = RIGHT if grid.cur_dir > UP
    grid.cur_dir = UP if grid.cur_dir < RIGHT
    ins_line = ins_line[1..]
  end
end

puts 1000 * (grid.y_pos + 1) + 4 * (grid.x_pos + 1) + grid.cur_dir
