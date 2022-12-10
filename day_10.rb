lines = File.read('day_10_input.txt').split("\n")
# lines = File.read('day_10_test_input.txt').split("\n")

class CPU
  attr_accessor :signal_strength

  NUM_CYCLES = { "noop" => 1, "addx" => 2 }

  def initialize()
    @regx = 1
    @cycle = 0
    @signal_strength = 0
    @xpos = 0
    @crt = []
    @current_line = ""
  end

  def inc_cycle
    @cycle += 1
    if (@cycle - 20) % 40 == 0
      @signal_strength += @cycle * @regx
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
      oper, val_s = line.split
      NUM_CYCLES[oper].times do
        inc_cycle
        draw_pixel_and_move_cursor
      end
      if oper == "addx"
        @regx += val_s.to_i
      end
    end
  end

  def show_crt
    puts @crt.join("\n")
  end
end

# part 1
c = CPU.new()
c.process_lines(lines)
puts c.signal_strength

# part 2
c.show_crt

