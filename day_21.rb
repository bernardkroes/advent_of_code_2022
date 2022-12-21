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
monkeys_orig = monkeys.dup # make a copy for part 2

while monkeys["root"][0] == 0
  monkeys.each do |k,v|
    if v[0] == 0 && v[1] != ""
      if monkeys[v[2]][0] > 0 && monkeys[v[3]][0] > 0
        res = 0
        if v[1] == "+"
          res = monkeys[v[2]][0] + monkeys[v[3]][0]
        elsif v[1] == "-"
          res = monkeys[v[2]][0] - monkeys[v[3]][0]
        elsif v[1] == "/"
          res = monkeys[v[2]][0] / monkeys[v[3]][0]
        elsif v[1] == "*"
          res = monkeys[v[2]][0] * monkeys[v[3]][0]
        end
        monkeys[k] = [res, v[1], v[2], v[3]]
      end
    end
  end
end
puts monkeys["root"][0]

# part 2

def root_diff_value_for_humn(monkeys, humn)
  monkeys["root"][1] = "="
  monkeys["humn"][0] = humn

  the_loop_count = 0
  while monkeys["root"][0] == 0 && the_loop_count < 100 # enough cycles to process a value for root, if this value is zero, we stop at 100
    monkeys.each do |k,v|
      if v[0] == 0 && v[1] != ""
        if monkeys[v[2]][0] > 0 && monkeys[v[3]][0] > 0
          res = 0
          if v[1] == "="
            if monkeys[v[2]][0] == monkeys[v[3]][0]
              puts "#{humn}"
              exit
            else
              return monkeys[v[2]][0] - monkeys[v[3]][0]
            end
          elsif v[1] == "+"
            res = monkeys[v[2]][0] + monkeys[v[3]][0]
          elsif v[1] == "-"
            res = monkeys[v[2]][0] - monkeys[v[3]][0]
          elsif v[1] == "/"
            res = monkeys[v[2]][0] / monkeys[v[3]][0]
          elsif v[1] == "*"
            res = monkeys[v[2]][0] * monkeys[v[3]][0]
          end
          monkeys[k] = [res, v[1], v[2], v[3]]
        end
      end
    end
    the_loop_count += 1
  end
  return -1
end

# played around with humn values: conclusion: we can play the lower/higher guess game
guess_num_low  =           1000 # a start value that gives us a positive value for both inputs for root
guess_num_high = 99999999999999 # high enough!!!

monkeys = monkeys_orig.dup

while true
  # just calculate all the values again, because computers!
  val_low = root_diff_value_for_humn(monkeys.dup, guess_num_low)
  val_mid = root_diff_value_for_humn(monkeys.dup, (guess_num_low + guess_num_high) / 2)
  val_high = root_diff_value_for_humn(monkeys.dup, guess_num_high)
  if val_mid < 0
    guess_num_high = (guess_num_low + guess_num_high) / 2
  else
    guess_num_low = (guess_num_low + guess_num_high) / 2
  end
  # puts "#{guess_num_low} - #{guess_num_high}"
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

