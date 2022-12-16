all_lines = File.read('day_16_input.txt').split("\n")
# all_lines = File.read('day_16_test_input.txt').split("\n")

class Valve
  attr_accessor :rate, :tunnels, :name

  def initialize(line)
    the_line = line.gsub("Valve ","")
    the_line = the_line.gsub("has flow rate=" ,"")
    the_line = the_line.gsub("; tunnels lead to valves","")
    the_line = the_line.gsub("; tunnel leads to valve","")
    parts = the_line.split(" ")

    @name = parts[0]
    @rate = parts[1].to_i
    @tunnels = []

    parts[2..].each do |p|
      @tunnels << p.gsub(",","")
    end
  end
end

valves = {}
all_lines.each do |line|
  v = Valve.new(line)
  valves[v.name] = v
end

def all_possible_moves(valve, valves, open_valves)
  moves = []
  if !all_valves_with_rate_open?(valves, open_valves)
    if (valve.rate > 0) && !open_valves.include?(valve.name)
      moves << "open"
    end
    moves = moves + valve.tunnels
  else
    moves << "noop" # do nothing
  end
  return moves
end

def all_valves_with_rate_open?(valves, open_valves)
  valves.each do |k,v|
    if v.rate > 0 && !open_valves.include?(k)
      return false
    end
  end
  true
end


def calc_pressure(valves, open_valves)
  add_pressure = 0
  valves.each do |k,v|
    if v.rate > 0 && open_valves.include?(v.name)
      add_pressure += v.rate
    end
  end
  return add_pressure
end

# part 1
max_pressure = 0
all_rates = []
all_rates = valves.values.collect { |v| v.rate }.sort.reverse

top_rates_summed = all_rates[0]
max_pressure_per_minute = Array.new(30, 0)

work_queue = []
seen = {}

all_possible_moves(valves["AA"], valves, []).each do |m|
  work_queue << ["AA", [], m, 0, 1] # valve, opened, move, total_pressure, minute
end
while work_queue.size > 0
  my_valve_name, open_valves, my_move, pressure, the_minute = work_queue.shift

  my_valve = valves[my_valve_name]
  if my_move == "open"
    open_valves << my_valve_name
  elsif my_move != "noop"
    my_valve = valves[my_move]
  end
  pressure += calc_pressure(valves, open_valves)
  max_pressure_per_minute[the_minute] = pressure if pressure > max_pressure_per_minute[the_minute]
  the_minute += 1

  if the_minute == 30
    max_pressure = pressure if pressure > max_pressure
  else
    all_possible_moves(my_valve, valves, open_valves).each do |move|
      the_key = [my_valve.name, open_valves.sort, move, pressure, the_minute]
      if !seen.has_key?(the_key)
        if pressure > max_pressure_per_minute[the_minute - 1] - top_rates_summed
          work_queue << [my_valve.name, open_valves.dup, move, pressure, the_minute]
          seen[the_key] = 1
        end
      end
    end
  end
end
puts max_pressure

# part 2, here comes the elephant
top_rates_summed = all_rates[0] + all_rates[1]
max_pressure = 0
max_pressure_per_minute = Array.new(26, 0)

work_queue = []
seen = {}

all_possible_moves(valves["AA"], valves, []).each do |my_move|
  all_possible_moves(valves["AA"], valves, []).each do |elephant_move|
    the_key = ["AA", "AA", [], my_move, elephant_move, 0]
    the_key1 = ["AA", "AA", [], elephant_move, my_move, 0]
    the_key2 = ["AA", "AA", [], my_move, elephant_move, 0]
    the_key3 = ["AA", "AA", [], elephant_move, my_move, 0]

    work_queue << ["AA", "AA", [], my_move, elephant_move, 0, 1] # valve, valve of elephant, opened, move, move of elephan, total_pressure, minute

    seen[the_key] = 1
    seen[the_key1] = 1
    seen[the_key2] = 1
    seen[the_key3] = 1
  end
end
while work_queue.size > 0
  my_valve_name, elephant_valve_name, open_valves, my_move, elephant_move, pressure, the_minute = work_queue.shift

  # can we skip it?
  next if pressure < max_pressure_per_minute[the_minute - 1] - top_rates_summed

  my_valve = valves[my_valve_name]
  if my_move == "open"
    open_valves << my_valve_name
  elsif my_move != "noop"
    my_valve = valves[my_move]
  end

  elephant_valve = valves[elephant_valve_name]
  if elephant_move == "open"
    open_valves << elephant_valve_name
  elsif elephant_move != "noop"
    elephant_valve = valves[elephant_move]
  end

  pressure += calc_pressure(valves, open_valves)
  max_pressure_per_minute[the_minute] = pressure if pressure > max_pressure_per_minute[the_minute]
  the_minute += 1

  if the_minute == 26
    # stop
    max_pressure = pressure if pressure > max_pressure
  else
    all_possible_moves(my_valve, valves, open_valves).each do |my_move|
      all_possible_moves(elephant_valve, valves, open_valves).each do |elephant_move|
        the_key = [my_valve.name, elephant_valve.name, open_valves.sort, my_move, elephant_move, pressure]
        the_key1 = [my_valve.name, elephant_valve.name, open_valves.sort, elephant_move, my_move, pressure]
        the_key2 = [elephant_valve.name, my_valve.name, open_valves.sort, my_move, elephant_move, pressure]
        the_key3 = [elephant_valve.name, my_valve.name, open_valves.sort, elephant_move, my_move, pressure]
        if !seen.has_key?(the_key) && !seen.has_key?(the_key1) && !seen.has_key?(the_key2) && !seen.has_key?(the_key3)
          if pressure > max_pressure_per_minute[the_minute - 1] - top_rates_summed
            work_queue << [my_valve.name, elephant_valve.name, open_valves.dup, my_move, elephant_move, pressure, the_minute]
            seen[the_key] = 1
            seen[the_key1] = 1
            seen[the_key2] = 1
            seen[the_key3] = 1
          end
        end
      end
    end
  end
end
puts max_pressure

__END__

Valve AA has flow rate=0; tunnels lead to valves DD, II, BB
Valve BB has flow rate=13; tunnels lead to valves CC, AA
Valve CC has flow rate=2; tunnels lead to valves DD, BB
Valve DD has flow rate=20; tunnels lead to valves CC, AA, EE
Valve EE has flow rate=3; tunnels lead to valves FF, DD
Valve FF has flow rate=0; tunnels lead to valves EE, GG
Valve GG has flow rate=0; tunnels lead to valves FF, HH
Valve HH has flow rate=22; tunnel leads to valve GG
Valve II has flow rate=0; tunnels lead to valves AA, JJ
Valve JJ has flow rate=21; tunnel leads to valve II

