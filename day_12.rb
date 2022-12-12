DELTA_MOVES = [[ 0,1], [-1,0], [ 1,0], [0,-1]]
class Grid
  attr_accessor :size_x, :size_y, :grid, :start_x, :start_y

  def initialize(in_lines)
    @grid = []
    in_lines.each do |line|
      @grid << line.split("").to_a
    end
    @size_x = @grid[0].size
    @size_y = in_lines.size

    @grid.each_with_index do |l, y|
      if l.include?("E")
        @dst_x, @dst_y = l.find_index("E"), y
      end
      if l.include?("S")
        @start_x, @start_y = l.find_index("S"), y
      end
    end

    @grid[@start_y][@start_x] = 'a'
    @grid[@dst_y][@dst_x] = 'z'
  end

  def get_info
    puts "Size x: #{@size_x}"
    puts "Size y: #{@size_y}"
    puts "Cur pos: #{@start_x} #{@start_y}"
    puts "Dst pos: #{@dst_x} #{@dst_y}"

    @grid.each do |l|
      puts l.join
    end
  end

  def on_grid?(x,y)
    x >= 0 && x < @size_x && y>=0 && y < @size_y
  end

  def possible_moves(x, y)
    the_moves = []
    cur_height = @grid[y][x].ord
    DELTA_MOVES.each do |m|
      dst_x, dst_y = x + m[0], y + m[1]
      if on_grid?(dst_x, dst_y) && @grid[dst_y][dst_x].ord - cur_height <= 1
        the_moves << m
      end
    end
    the_moves
  end

  def find_dst(start_positions)
    seen = {} # hash_key: x_y

    work_queue = []
    num_steps = 0

    start_positions.each do |sp|
      work_queue << [sp[0], sp[1], num_steps]
    end
    while work_queue.size > 0
      the_state = work_queue.shift

      all_moves = possible_moves(the_state[0], the_state[1])
      all_moves.each do |m|
        the_x, the_y = the_state[0] + m[0], the_state[1] + m[1]
        the_num_steps = the_state[2] + 1
        if (the_x == @dst_x) && (the_y == @dst_y)
          return the_num_steps
        end
        if !seen.has_key?("#{the_x}_#{the_y}")
          work_queue << [the_x, the_y, the_num_steps]
          seen["#{the_x}_#{the_y}"] = the_num_steps
        end
      end
    end
  end

  def find_dst_part_2
    start_positions = []
    @grid.each_with_index do |l, y|
      l.each_with_index do |c, x|
        start_positions << [x, y] if c == "a"
      end
    end
    find_dst(start_positions)
  end
end

all_lines = File.read('day_12_input.txt').split("\n")
# all_lines = File.read('day_12_test_input.txt').split("\n")

g = Grid.new(all_lines)
# g.get_info
puts g.find_dst([[g.start_x, g.start_y]])
puts g.find_dst_part_2
