DELTA_MOVES = { "U" => [ 0,1],
                "L" => [-1,0],
                "R" => [ 1,0],
                "D" => [0,-1]}

class Grid
  attr_accessor :tail_visited

  def initialize(num_knots)
    # for showing the grid:
    @min_x, @max_x = 0, 0
    @min_y, @max_y = 0, 0

    @knots = []
    num_knots.times do
      @knots << [0, 0]  # head is knot[0]
    end

    @tail_visited = {}
    @tail_visited[@knots.last.dup] = 1
  end

  # by knot-index
  def knots_adjacent?(i, j)
    ((@knots[i][0] - @knots[j][0]).abs < 2) && ((@knots[i][1] - @knots[j][1]).abs < 2)
  end

  # by knot-index, t follows h
  def move_tail_knot(t,h)
    return if knots_adjacent?(t,h)

#    used this at first:
#    delta_0 = (@knots[h][0] > @knots[t][0] ? 1 : -1)
#    delta_0 = 0 if @knots[h][0] == @knots[t][0]
#    delta_1 = (@knots[h][1] > @knots[t][1] ? 1 : -1)
#    delta_1 = 0 if @knots[h][1] == @knots[t][1]

    delta_0 = @knots[h][0] <=> @knots[t][0]
    delta_1 = @knots[h][1] <=> @knots[t][1]

    @knots[t][0] += delta_0
    @knots[t][1] += delta_1
  end

  def move_tail_knots
    1.upto(@knots.size-1) do |i|
      move_tail_knot(i, i-1)
    end
    @tail_visited[@knots.last.dup] = 1
  end

  def do_move(in_dir)
    @knots[0][0] += DELTA_MOVES[in_dir][0]
    @knots[0][1] += DELTA_MOVES[in_dir][1]
    move_tail_knots
  end

  def do_moves(lines)
    lines.each do |line|
      dir, count = line.split(" ")
      count.to_i.times do |i|
        do_move(dir)
      end
      # show grid terminal animation disabled, need a bigger monitor
#       show_grid
#       sleep(3.0/24.0)
    end
  end

  # show grid in the terminal window
  def show_grid
    head = @knots.first

#     the_min_x, the_max_x = @knots.collect { |k| k[0] }.minmax
#     @min_x = the_min_x if the_min_x < @min_x
#     @max_x = the_max_x if the_max_x > @max_x
#     the_min_y, the_max_y = @knots.collect { |k| k[1] }.minmax
#     @min_y = the_min_y if the_min_y < @min_y
#     @max_y = the_max_y if the_max_y > @max_y

    @min_x = head[0] - 100 # if @min_x < head[0] - 50
    @max_x = head[0] + 100 # if @max_x > head[0] + 50

    @min_y = head[1] - 50 # if @min_y < head[1] - 50
    @max_y = head[1] + 50 # if @max_y > head[1] + 50

    puts "\e[H\e[2J" # clear the terminal for more fun
    @max_y.downto(@min_y) do |y|
      the_line = ""
      @min_x.upto(@max_x) do |x|
        the_y = @max_y + @min_y - y
        the_knot = @knots.index { |k| (k[0] == x) && (k[1] == the_y) }
        if x == 0 && the_y == 0
          the_line += "s"
        elsif the_knot
          if the_knot == 0
            the_line += "H"
          elsif the_knot == @knots.size - 1
            the_line += "T"
          else
            the_line += "#{the_knot+1}"
          end
        elsif @tail_visited.has_key?([x, the_y])
          the_line += "#"
        else
          the_line += "."
        end
      end
      puts the_line
    end
  end
end

lines = File.read('day_9_input.txt').split("\n")

# part 1
g = Grid.new(2)
g.do_moves(lines)
puts g.tail_visited.count

# part 2
g = Grid.new(10)
g.do_moves(lines)
puts g.tail_visited.count

