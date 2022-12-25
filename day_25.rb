all_lines = File.read('day_25_input.txt').split("\n")
# all_lines = File.read('day_25_test_input.txt').split("\n")

# solution based on base 5 conversions:

def from_snafu(line)
  num_b5_slen = line.size
  tr_line = line.tr('=\-012','01234') # in this conversion we have added "22222", we need to subtract that
  num_b5 = tr_line.to_i(5)
  delta = ("2" * num_b5_slen).to_i(5)
  return num_b5 - delta
end

# just the other way around
def to_snafu(num)
  num_b5_slen = num.to_s(5).size
  delta = ("2" * num_b5_slen).to_i(5) # in the tr below we will subtract "222222", add it (converted) first
  num_b5_s = (delta + num).to_s(5)
  return num_b5_s.tr('01234', '=\-012')
end

sum = 0
all_lines.each do |line|
  val = from_snafu(line)
  sum += val
end

puts sum
puts to_snafu(sum)
puts from_snafu(to_snafu(sum)) # verify

__END__

# first solution was to do the to_snafu manually (and submit)
# second solution was based on code by jonathanpaulson

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

puts from_snafu("2-0=11=-0-2-1==1=-22") # verify => 34061028947237

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

 SNAFU  Decimal
1=-0-2     1747
 12111      906
  2=0=      198
    21       11
  2=01      201
   111       31
 20012     1257
   112       32
 1=-1=      353
  1-12      107
    12        7
    1=        3
   122       37

