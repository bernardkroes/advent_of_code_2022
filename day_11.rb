
class Monkey
  attr_accessor :number, :items, :inspected, :modulo_size

  def initialize(in_num, in_items, oper, divisor, next_true, next_false)
    @number = in_num
    @items =  in_items.dup
    @oper = oper
    @divisor = divisor
    @next_true = next_true
    @next_false = next_false
    @inspected = 0

    @modulo_size = @divisor
  end

  def get_info
    puts "=== Monkey #{@number}"
    puts @items.inspect
    puts "Div: #{@divisor}"
    puts "Next if true: #{@next_true}"
    puts "Next if false: #{@next_false}"
  end

  def do_round(in_monkeys)
    @items.each_with_index do |item, i|
      @inspected += 1
      the_val = do_operand(item)
      in_monkeys[the_val % @divisor == 0 ? @next_true : @next_false].items << the_val
    end
    @items = []
  end

  def do_operand(old)
    new = eval(@oper)

  # hard-coded: ugly (?) but got me there the fastest
#     case @number
#       when 0 then old * 5
#       when 1 then old * 11
#       when 2 then old + 2
#       when 3 then old + 5
#       when 4 then old * old
#       when 5 then old + 4
#       when 6 then old + 6
#       when 7 then old + 7
#     end

    # new / 3            # use this for part 1
    new % @modulo_size   # use this for part 2
  end
end

monkey_lines = File.read('day_11_input.txt').split("\n\n")

monkeys = []
modulo_div = 1
monkey_lines.each_with_index do |lines,i|
  split_lines = lines.split("\n")

  the_num = split_lines[0].scan(/\d+/).first.to_i
  the_items = split_lines[1].gsub(/[^0-9\,]/,"").split(",").map(&:to_i)
  the_oper = split_lines[2].gsub("  Operation: new = ","")
  the_div = split_lines[3].scan(/\d+/).first.to_i
  next_true = split_lines[4].scan(/\d+/).first.to_i
  next_false = split_lines[5].scan(/\d+/).first.to_i

  monkeys << Monkey.new(the_num, the_items, the_oper, the_div, next_true, next_false)
  modulo_div *= the_div
end
monkeys.each do |m|
  m.modulo_size = modulo_div
end

# monkeys.each do |m|
#   m.get_info
# end

# part 2
10000.times do |round| # part 1: 20.times
  monkeys.each do |monkey|
    monkey.do_round(monkeys)
  end
end
inspected = monkeys.collect { |m| m.inspected }.sort.reverse
puts inspected[0] * inspected[1]

__END__

Monkey 0:
  Starting items: 79, 98
  Operation: new = old * 19
  Test: 
    If true: throw to monkey 2
    If false: throw to monkey 3
