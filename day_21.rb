all_lines = File.read('day_21_input.txt').split("\n")
# all_lines = File.read('day_21_test_input.txt').split("\n")

monkeys = {}
all_lines.each do |line|
  oper = ""
  the_num = 0
  in_1, in_2 = "", ""
  name, task = line.split(": ")
  if task.include?(" + ")
    oper = "+"
    in1, in2 = task.split(" + ")
  elsif task.include?(" - ")
    oper = "-"
    in1, in2 = task.split(" - ")
  elsif task.include?(" / ")
    oper = "/"
    in1, in2 = task.split(" / ")
  elsif task.include?(" * ")
    oper = "*"
    in1, in2 = task.split(" * ")
  else
    the_num = task.to_i
  end
  monkeys[name] = [the_num, oper, in1, in2]
end

def value_for(monkeys, monkey_name)
  v = monkeys[monkey_name]
  if v[1] == "+"
    return value_for(monkeys, v[2]) + value_for(monkeys, v[3])
  elsif v[1] == "-"
    return value_for(monkeys, v[2]) - value_for(monkeys, v[3])
  elsif v[1] == "/"
    return value_for(monkeys, v[2]) * 1.0 / value_for(monkeys, v[3]) * 1.0
  elsif v[1] == "*"
    return value_for(monkeys, v[2]) * value_for(monkeys, v[3])
  else
    return v[0]
  end
end
puts value_for(monkeys, "root").to_i

# part 2

def root_diff_value_for_humn(monkeys, humn)
  monkeys["root"][1] = "-"
  monkeys["humn"][0] = humn

  return value_for(monkeys, "root")
end

# played around with humn values: conclusion: we can play the lower/higher guess game
guess_num_low  =    0       # a start value that gives us a positive value for both inputs for root
guess_num_high = 1e13.to_i  # high enough!!!

while true
  # just calculate all the values again, because computers!
  val_low = root_diff_value_for_humn(monkeys, guess_num_low)
  val_mid = root_diff_value_for_humn(monkeys, (guess_num_low + guess_num_high) / 2)
  val_high = root_diff_value_for_humn(monkeys, guess_num_high)
  if val_mid < 0
    guess_num_high = (guess_num_low + guess_num_high) / 2
  elsif val_mid > 0
    guess_num_low = (guess_num_low + guess_num_high) / 2
  else
    puts "#{(guess_num_low + guess_num_high) / 2}"
    exit
  end
end

__END__

root: pppw + sjmn
dbpl: 5
cczh: sllz + lgvd
zczc: 2
ptdq: humn - dvpt
dvpt: 3
lfqf: 4
humn: 5
ljgn: 2
sjmn: drzm * dbpl
sllz: 4
pppw: cczh / lfqf
lgvd: ljgn * ptdq
drzm: hmdt - zczc
hmdt: 32

