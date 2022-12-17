jets = File.read('day_17_input.txt').chomp.split("")

ROCK_WIDTHS  = [4, 3, 3, 1, 2]
ROCK_HEIGHTS = [ [1, 1, 1, 1],
                 [2, 3, 2],
                 [3, 3, 3],
                 [4],
                 [2,2] ]

ROCK_TEMPLATES = [
  ["####"],
  [".#.","###",".#."],
  ["..#","..#","###"],
  ["#","#","#","#"],
  ["##","##"]
]

class TetrisTunnel
  attr_accessor :jets, :max_height

  def initialize(jets)
    @jets = jets
    @grid = {}
    0.upto(8) do |x|
      @grid[[x, 0]] = "-"
    end
    @max_height = 0
  end

  def can_move_right?(rock_type, rock_x, rock_y)
    return false if rock_x + ROCK_WIDTHS[rock_type] > 7

    ROCK_TEMPLATES[rock_type].each_with_index do |line, y|
      rx = line.rindex("#")
      return false if @grid.has_key?([rock_x + rx + 1, rock_y - y])
    end
    true
  end

  def can_move_left?(rock_type, rock_x, rock_y)
    return false if rock_x <= 1

    ROCK_TEMPLATES[rock_type].each_with_index do |line, y|
      lx = line.index("#")
      return false if @grid.has_key?([rock_x + lx - 1, rock_y - y])
    end
    true
  end

  def can_move_down?(rock_type, rock_x, rock_y)
    ROCK_HEIGHTS[rock_type].each_with_index do |y, x|
      return false if @grid.has_key?([rock_x + x, rock_y - y])
    end
    true
  end

  def fix_rock(rock_type, rock_x, rock_y)
    char = rock_type.to_s # easier visual debugging
    ROCK_TEMPLATES[rock_type].each_with_index do |line, y|
      line.chars.each_with_index do |c, x|
        @grid[ [rock_x + x, rock_y - y] ] = char if c == "#"
      end
    end
  end

  def draw_grid(max_height)
    max_height.downto(-1) do |y|
      line = ""
      0.upto(8) do |x|
        if x == 0 || x == 8
          line += "|"
        elsif @grid.has_key?([x, y])
          line += @grid[ [x,y] ]
        else
          line += "."
        end
      end
      puts line
    end
  end

  def drop_rocks(in_count)
    num_dropped = 0
    rock_type = 0
    jet_pos = 0

    rock_y = max_height + ROCK_HEIGHTS[rock_type].max + 3
    rock_x = 3

    while num_dropped < in_count
      if @jets[jet_pos] == "<" && can_move_left?(rock_type, rock_x, rock_y)
        rock_x -= 1
      elsif @jets[jet_pos] == ">" && can_move_right?(rock_type, rock_x, rock_y)
        rock_x += 1
      end
      jet_pos = (jet_pos + 1) % @jets.size

      if can_move_down?(rock_type, rock_x, rock_y)
        rock_y -= 1
     else
        fix_rock(rock_type, rock_x, rock_y)
        num_dropped += 1

        @max_height = rock_y if rock_y > @max_height

        rock_type = (rock_type + 1) % 5
        rock_y = max_height + ROCK_HEIGHTS[rock_type].max + 3
        rock_x = 3
      end
    end
  end
end

tt = TetrisTunnel.new(jets)
tt.drop_rocks(2022)
puts tt.max_height

# part 2
#
#  Anaylyze the resulting heights after each dropped rock 
#  (eg. by looking at long (3+) ranges of identical consecutive heights)
#  Determine a period and a delta
#
#  period = 1735
#  delta = 2667
#  1000000000000 = (576368875 * 1735) + 1875
#
#  576368875 * 2667 = 1537175789625
#  height after 1875 blocks: 2870
#  1537175789625 + 2870 = 1537175792495

puts 576368875 * 2667 + 2870
