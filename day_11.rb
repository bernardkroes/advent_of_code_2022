
class Monkey
  attr_accessor :number, :items, :divisor, :inspected

  def initialize(in_lines)
    @number = in_lines[0].scan(/\d+/).first.to_i
    @items = in_lines[1].gsub(/[^0-9\,]/,"").split(",").map(&:to_i)
    @oper = in_lines[2].gsub("  Operation: new = ","")
    @divisor = in_lines[3].scan(/\d+/).first.to_i
    @next_true = in_lines[4].scan(/\d+/).first.to_i
    @next_false = in_lines[5].scan(/\d+/).first.to_i
    @inspected = 0
  end

  def do_round_part1(in_monkeys)
    @items.each_with_index do |item, i|
      @inspected += 1
      the_val = apply_operation(item) / 3
      in_monkeys[the_val % @divisor == 0 ? @next_true : @next_false].items << the_val
    end
    @items = []
  end

  def do_round_part2(in_monkeys, modulo)
    @items.each_with_index do |item, i|
      @inspected += 1
      the_val = apply_operation(item) % modulo
      in_monkeys[the_val % @divisor == 0 ? @next_true : @next_false].items << the_val
    end
    @items = []
  end

  def apply_operation(old)
    new = eval(@oper)
    new

  # hard-coded: ugly (?) but got me there the fastest (and runs faster)
#   new = case @number
#       when 0 then old * 5
#       when 1 then old * 11
#       when 2 then old + 2
#       when 3 then old + 5
#       when 4 then old * old
#       when 5 then old + 4
#       when 6 then old + 6
#       when 7 then old + 7
#     end
#    new
  end
end

monkey_lines = File.read('day_11_input.txt').split("\n\n")

modulo_div = 1
monkeys = []
monkey_lines.each do |lines|
  monkeys << Monkey.new(lines.split("\n"))
  modulo_div *= monkeys.last.divisor
end
monkeys_part2 = Marshal.load(Marshal.dump(monkeys)) # make a copy for part 2

# part 1
20.times do |round|
  monkeys.each do |monkey|
    monkey.do_round_part1(monkeys)
  end
end
inspected = monkeys.collect { |m| m.inspected }.sort.reverse
puts inspected[0] * inspected[1]

# part 2, use the copied monkeys
10000.times do |round|
  monkeys_part2.each do |monkey|
    monkey.do_round_part2(monkeys_part2, modulo_div)
  end
end
inspected = monkeys_part2.collect { |m| m.inspected }.sort.reverse
puts inspected[0] * inspected[1]

__END__

Monkey 0:
  Starting items: 79, 98
  Operation: new = old * 19
  Test: 
    If true: throw to monkey 2
    If false: throw to monkey 3
