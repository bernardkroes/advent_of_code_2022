lines = File.read('day_10_input.txt').split("\n")
# lines = File.read('day_10_test_input.txt').split("\n")

class CPU
  attr_accessor :regx, :cycle, :strength, :xpos

  def initialize()
    @regx = 1
    @cycle = 0
    @strength = 0
    @xpos = 0
    @crt = []
    @current_line = ""
  end

  def inc_cycle
    @cycle += 1
    if (@cycle - 20) % 40 == 0
      @strength += @cycle * @regx
    end
  end

  def draw_pixel_and_move_cursor
    @current_line += (@regx - @xpos).abs < 2 ? "#" : "."
    @xpos += 1

    if @xpos == 40
      @crt << @current_line
      @xpos = 0
      @current_line = ""
    end
  end

  def process_lines(in_lines)
    in_lines.each do |line|
      if line == "noop"
        inc_cycle
        draw_pixel_and_move_cursor
      else
        2.times do
          inc_cycle
          draw_pixel_and_move_cursor
        end

        oper, val_s = line.split(" ")
        @regx += val_s.to_i
      end
    end
  end

  def show_crt
    @crt.each do |l|
      puts l
    end
  end
end

# part 1
c = CPU.new()
c.process_lines(lines)
puts c.strength

# part 2
c.show_crt

