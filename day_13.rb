all_pairs = File.read('day_13_input.txt').split("\n\n")

class Packet
  attr_accessor   :values

  def initialize(ll)
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
end

def is_list?(a)
  a.start_with?("[")
end

def sorted_correct?(pack_a, pack_b)
  if pack_a.values.size == 0
    if pack_b.values.size == 0
      return 0
    elsif pack_b.values.size > 0
      return 1
    end
  elsif pack_b.values.size == 0
    return -1
  end

  ret_val = 0
  a = pack_a.values.shift
  b = pack_b.values.shift

  if is_list?(a) && is_list?(b)
    ret_val = sorted_correct?(Packet.new(a), Packet.new(b))
  elsif !is_list?(a) && !is_list?(b)
    aval = a.scan(/\d+/).first.to_i
    bval = b.scan(/\d+/).first.to_i
    return 1 if aval < bval
    return -1 if aval > bval
  elsif !is_list?(a)
    ret_val = sorted_correct?(Packet.new("["+a+"]"), Packet.new(b))
  elsif is_list?(a)
    ret_val = sorted_correct?(Packet.new(a), Packet.new("["+b+"]"))
  end
  return ret_val != 0 ? ret_val : sorted_correct?(pack_a, pack_b)
end

sum = 0
all_pairs.each_with_index do |p, ii|
  a, b = p.split("\n")

  ret_val = sorted_correct?(Packet.new(a), Packet.new(b))
  sum += ii + 1 if ret_val == 1
end
puts sum

#part 2
all_lines = File.read('day_13_input.txt').split("\n").delete_if { |l| l.chomp == "" }
all_lines << "[[2]]"
all_lines << "[[6]]"

sorted_lines = all_lines.sort { |i,j| sorted_correct?(Packet.new(i), Packet.new(j)) }.reverse
puts (sorted_lines.index("[[2]]") + 1) * (sorted_lines.index("[[6]]") + 1)
