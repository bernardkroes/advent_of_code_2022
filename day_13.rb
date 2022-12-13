all_pairs = File.read('day_13_input.txt').split("\n\n")

class Packet
  attr_accessor :values # just the top level elements in an array

  def initialize(ll)    # should have used eval?
    @values = []

    if ll.length > 2
      ll = ll[1..-2]

      bracket_count = 0
      part_s = 0
      ll.length.times do |p|
        bracket_count += 1 if ll[p] == "["
        bracket_count -= 1 if ll[p] == "]"
        if ll[p] == "," && bracket_count == 0
          @values << ll[part_s...p]
          part_s = p + 1
        end
        if p == ll.length - 1
          @values << ll[part_s..p]
        end
      end
    end
  end

  def num_values
    @values.size
  end
end

def is_list?(a) # in: value
  a.start_with?("[")
end

def in_order?(pack_a, pack_b) # returns 1 if in_order, -1 if not, and 0 if undecided
  if pack_a.num_values == 0
    return 0 if pack_b.num_values == 0
    return 1 if pack_b.num_values > 0
  end
  return -1 if pack_b.num_values == 0

  ret_val = 0
  a = pack_a.values.shift
  b = pack_b.values.shift

  if is_list?(a) && is_list?(b)
    ret_val = in_order?(Packet.new(a), Packet.new(b))
  elsif !is_list?(a) && !is_list?(b)
    aval = a.scan(/\A\d+/).first.to_i
    bval = b.scan(/\A\d+/).first.to_i
    return 1 if aval < bval
    return -1 if aval > bval
  elsif !is_list?(a)
    ret_val = in_order?(Packet.new("["+a+"]"), Packet.new(b))
  elsif is_list?(a)
    ret_val = in_order?(Packet.new(a), Packet.new("["+b+"]"))
  end
  return ret_val != 0 ? ret_val : in_order?(pack_a, pack_b)
end

sum = 0
all_pairs.each_with_index do |p, ii|
  a, b = p.split("\n")

  ret_val = in_order?(Packet.new(a), Packet.new(b))
  sum += ii + 1 if ret_val == 1
end
puts sum

#part 2
all_lines = File.read('day_13_input.txt').split("\n").delete_if { |l| l.chomp == "" }
all_lines << "[[2]]"
all_lines << "[[6]]"

sorted_lines = all_lines.sort { |i,j| in_order?(Packet.new(i), Packet.new(j)) }.reverse
puts (sorted_lines.index("[[2]]") + 1) * (sorted_lines.index("[[6]]") + 1)

__END__

if using eval (nice):

def compare(x, y)
  case [x, y]
  in [Integer, Integer]
    x <=> y
  in [Array, Array]
    (0...[x.size, y.size].min).each do |i|
      res = compare(x[i], y[i])
      return res if res != 0
    end
    x.size <=> y.size
  else
    compare([x].flatten(1), [y].flatten(1))
  end
end


