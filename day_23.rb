all_lines = File.read('day_23_input.txt').split("\n")
# all_lines = File.read('day_23_test_input.txt').split("\n")

DELTA_MOVES = [[-1,-1],[ 0,-1],[ 1,-1],
               [-1, 0],[ 1, 0],
               [-1, 1],[ 0, 1],[ 1, 1]]

NORTH = 1
SOUTH = 6
WEST = 3
EAST = 4

CHECKS = [[0,1,2], [5,6,7], [0,3,5], [2,4,7]]
DESTS  =  [NORTH,   SOUTH,   WEST,    EAST]

grid = {}
all_lines.each_with_index do |line, y|
  line.split("").each_with_index do |c,x|
    grid[[x,y]] = "#" if c == "#"
  end
end

def grid_minmax_x(grid)
  grid.keys.collect { |k| k[0] }.minmax
end

def grid_minmax_y(grid)
  grid.keys.collect { |k| k[1] }.minmax
end

def do_round(grid, first_check_dir)
  moves = {} # next moves
  skip_moves = []

  grid.each do |k,v|
    the_x, the_y = k[0], k[1]

    occupied = 0
    DELTA_MOVES.each do |m|
      if grid.has_key?( [the_x + m[0], the_y + m[1] ])
        occupied += 1
        break
      end
    end
    if occupied > 0
      0.upto(3) do |delta_dir|
        the_dir = (first_check_dir + delta_dir) % 4
        cc = 0
        CHECKS[the_dir].each do |m|
          the_move = DELTA_MOVES[m]
          if grid.has_key?([ the_x + the_move[0], the_y + the_move[1] ])
            cc += 1
            break
          end
        end
        if cc == 0
          the_dest_move = DELTA_MOVES[DESTS[the_dir]]
          the_dest = [the_x + the_dest_move[0], the_y + the_dest_move[1]]
          if !skip_moves.include?(the_dest)
            if !moves.values.include?(the_dest)
              moves[k] = the_dest
            else
              moves.delete_if { |k,v| v == the_dest }
              skip_moves << the_dest
            end
          end
          break
        end
      end
    end
  end
  if moves.size == 0
    exit
  end

  moves.each do |k,v|
    grid[moves[k]] = "#"
    grid.delete(k)
  end
end

def show_grid(grid)
  min_x, max_x = grid_minmax_x(grid)
  min_y, max_y = grid_minmax_y(grid)
  puts "x: #{min_x} - #{max_x}"
  puts "y: #{min_y} - #{max_y}"
  (min_y - 1).upto(max_y + 1) do |y|
    line = ""
    (min_x - 1).upto(max_x + 1) do |x|
      if grid.has_key?( [x,y] )
        line += "#"
      else
        line += "."
      end
    end
    puts line
  end
end

first_check_dir = 0
round = 1

# 10.times do                     # use this line for part 1
while true                        # use this line for part 2
  puts "stepping round #{round}"

  do_round(grid, first_check_dir)
  round += 1

  first_check_dir = (first_check_dir + 1) % 4
end

min_x, max_x = grid_minmax_x(grid)
min_y, max_y = grid_minmax_y(grid)

puts (max_x - min_x + 1) * (max_y - min_y + 1) - grid.keys.size

