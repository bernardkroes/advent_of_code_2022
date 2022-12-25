all_lines = File.read('day_25_input.txt').split("\n")
# all_lines = File.read('day_25_test_input.txt').split("\n")

SVALS = { "=" => -2, "-" => -1, "0" => 0, "1" => 1, "2" => 2 }

def from_snafu(line)
  temp = 0
  base = 1
  line.split("").reverse.each_with_index do |c,i|
    val = SVALS[c]
    temp += val * base
    base *= 5
  end
  return temp
end

sum = 0
all_lines.each do |line|
  sum += from_snafu(line)
end

def max_value(p5)
  return 2 if p5 == 1
  return p5 * 2 + max_value(p5/5)
end

RVALS = { -2 => "=", -1 => "-", 0 => "0", 1 => "1", 2 => "2" }

def to_snafu(v, pp)
  return RVALS[v] if v >= -2 && v <= 2

  (-2..2).each do |d|
    rem = v - pp * d
    return RVALS[d] + to_snafu(rem, pp/5) if rem.abs <= max_value(pp/5)
  end
end

the_num = sum
pp = 1
while the_num.abs > max_value(pp)
  pp *= 5
end
puts to_snafu(the_num,pp)

__END__

34061028947237
puts from_snafu("2-0=11=-0-2-1==1=-22")

 Decimal          SNAFU
        1              1
        2              2
        3             1=
        4             1-
        5             10
        6             11
        7             12
        8             2=
        9             2-
       10             20
       15            1=0
       20            1-0
     2022         1=11-2
    12345        1-0---0
314159265  1121-1110-1=0

1=-0-2
12111
2=0=
21
2=01
111
20012
112
1=-1=
1-12
12
1=
122

34061028947237
