all_lines = File.read('day_14_input.txt').split("\n")
# all_lines = File.read('day_14_test_input.txt').split("\n")

DELTA_MOVES = [[ 0,1], [-1,1], [ 1,1]]
class Grid
  attr_accessor :min_x, :min_y, :grid, :max_x, :max_y

  def initialize(in_lines)
    @grid = {}
    in_lines.each do |line|
      line.split(" -> "). each_cons(2) do |pairs|
        src = pairs[0].split(",").map(&:to_i)
        dst = pairs[1].split(",").map(&:to_i)

        stx, endx = [src[0], dst[0]].minmax
        sty, endy = [src[1], dst[1]].minmax

        @min_x ||= stx
        @max_x ||= endx
        @min_y ||= sty
        @max_y ||= endy

        stx.upto(endx) do |x|
          sty.upto(endy) do |y|
            @min_x = x if x < @min_x
            @max_x = x if x > @max_x
            @min_y = y if y < @min_y
            @max_y = y if y > @max_y
            @grid[key_for(x,y)] = "#"
          end
        end
      end
    end
  end

  def key_for(x,y)
    "#{x}_#{y}"
  end

  def get_info # show (a part of) the map
    puts "X: #{@min_x} - #{@max_x}"
    puts "Y: #{@min_y} - #{@max_y}"
    0.upto(@max_y) do |y|
      line = ""
      @min_x.upto(@max_x) do |x|
        if @grid.has_key?(key_for(x,y))
          line += @grid[key_for(x,y)]
        else
          line += "."
        end
      end
      puts line
    end
  end

  def is_occupied?(x, y)
    @grid.has_key?(key_for(x, y))
  end

  def get_move(x,y)
    DELTA_MOVES.find { |m| !is_occupied?(x + m[0], y + m[1]) }
  end

  def drop_sand
    dropped = 0

    while true
      sx, sy = 500, 0

      while m = get_move(sx,sy)
        sx += m[0]
        sy += m[1]
        if sy > @max_y # sand is flowing
          return dropped
        end
        m = get_move(sx,sy)
      end
      @grid[key_for(sx,sy)] = "O"
      dropped += 1
    end
  end

  def is_occupied_p2?(x, y)
    @grid.has_key?(key_for(x, y)) || (y == @max_y + 2)
  end

  def get_move_p2(x,y)
    DELTA_MOVES.find { |m| !is_occupied_p2?(x + m[0], y + m[1]) }
  end

  def drop_sand_p2
    dropped = 0

    while true
      sx, sy = 500, 0
      while m = get_move_p2(sx,sy)
        sx += m[0]
        sy += m[1]
        m = get_move_p2(sx,sy)
      end
      @grid[key_for(sx,sy)] = "O"
      dropped += 1

      if sx == 500 && sy == 0
        return dropped
      end
    end
  end
end

g = Grid.new(all_lines)
g.get_info
p1 = g.drop_sand
g.get_info
puts p1

# reset the grid! (duh!)
g2 = Grid.new(all_lines)
p2 = g2.drop_sand_p2
g2.get_info
puts p2

