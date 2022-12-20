all_lines = File.read('day_19_input.txt').split("\n")
# all_lines = File.read('day_19_test_input.txt').split("\n")

class Blueprint
  attr_accessor :num, :ore_robot_costs, :clay_robot_costs, :obsidian_robot_costs, :geode_robot_costs, :ore, :clay, :obsidian, :geode, :max_geode

# Blueprint 1: Each ore robot costs 4 ore. Each clay robot costs 4 ore. Each obsidian robot costs 4 ore and 14 clay. Each geode robot costs 3 ore and 16 obsidian.
# => [1, 4, 4, 4, 14, 3, 16]

def initialize(line)
  ii = line.scan(/\d+/).map(&:to_i)
  @num = ii[0]
  @ore_robot_costs = [ii[1], 0, 0]
  @clay_robot_costs = [ii[2], 0, 0]
  @obsidian_robot_costs = [ii[3], ii[4], 0]
  @geode_robot_costs = [ii[5], 0, ii[6]]

  @min_ore_cost = [ii[1], ii[2], ii[3], ii[5]].min
  @min_clay_cost = ii[4]
  @min_obsidian_cost = ii[6]

  @ore_robots_count = 1
  @clay_robots_count = 0
  @obsidian_robots_count = 0
  @geode_robots_count = 0

  @ore = 0
  @clay = 0
  @obsidian = 0
  @geode = 0
  @max_geode = 0

  @minute = 1
end

def get_info
  puts "Blueprint #{num}, minute #{@minute}"
  puts "#{@ore} ore, #{@clay} clay, #{@obsidian} obsidian, #{@geode} geode"
end

def collect_materials
  @ore += @ore_robots_count
  @clay += @clay_robots_count
  @obsidian += @obsidian_robots_count
  @geode += @geode_robots_count
end

def quality
  @max_geode * @num
end

# possible optimization: it makes no sense to build more 'clay' robots if all that clay cannot be spent on building another robot
def possible_moves
  base_move = [@ore, @clay, @obsidian, @geode, @ore_robots_count, @clay_robots_count, @obsidian_robots_count, @geode_robots_count, @minute]
  mm = []

  if @ore >= @geode_robot_costs[0] && @obsidian >= @geode_robot_costs[2]
    mm << ["geode_robot"] + base_move.dup # tactic: always build a geode bot if possible
    return mm
  end
  if @ore >= @obsidian_robot_costs[0] && @clay >= @obsidian_robot_costs[1]
    mm << ["obsidian_robot"] + base_move.dup # tactic: always build an obsidian bot if possible, may not be correct in all cases
    return mm
  end

  if @ore < 7 # tactic: always build a bot if we have more than 6 ores
    mm << ["noop"] + base_move.dup
  end
  if @ore >= @ore_robot_costs[0]
    mm << ["ore_robot"] + base_move.dup
  end
  if @ore >= @clay_robot_costs[0]
    mm << ["clay_robot"] + base_move.dup
  end
  mm
end

# biggest optimization: 
# seen keys for amounts less than the minimum costs for a material can be considered as equal states for the seen cache
def key_for(m)
  action, ore, clay, obsidian, geode, ore_robots_count, clay_robots_count, obsidian_robots_count, geode_robots_count, minute = m
  [action, ore < @min_ore_cost ? 1 : ore, clay < @min_clay_cost ? 1 : clay, obsidian < @min_obsidian_cost ? 1 : obsidian, geode, ore_robots_count, clay_robots_count, obsidian_robots_count, geode_robots_count, minute]
end

def simulate(end_minute)
  work_queue = []
  seen = {}
  possible_moves.each do |m|
    seen_key = key_for(m)
    if !seen.has_key?(seen_key)
      seen[seen_key] = 1
      work_queue << m
    end
  end
  while work_queue.size > 0
    action, @ore, @clay, @obsidian, @geode, @ore_robots_count, @clay_robots_count, @obsidian_robots_count, @geode_robots_count, @minute = work_queue.shift

    # spend the ore:
    if action.start_with?("ore")
      @ore -= @ore_robot_costs[0]
    elsif action.start_with?("clay")
      @ore -= @clay_robot_costs[0]
    elsif action.start_with?("obsidian")
      @ore -= @obsidian_robot_costs[0]
      @clay -= @obsidian_robot_costs[1]
    elsif action.start_with?("geode")
      @ore -= @geode_robot_costs[0]
      @obsidian -= @geode_robot_costs[2]
    end

    #always collect
    collect_materials
    @ore_robots_count += 1 if action.start_with?("ore")
    @clay_robots_count += 1 if action.start_with?("clay")
    @obsidian_robots_count += 1 if action.start_with?("obsidian")
    @geode_robots_count += 1 if action.start_with?("geode")

    @minute += 1
    if @minute <= end_minute
      # only add moves if we can pass the max so far: small optimization
      max_possible = @geode
      @minute.upto(end_minute) do |m|
        max_possible += (@geode_robots_count + m) * (end_minute - m + 1)
      end
      if max_possible > @max_geode
        possible_moves.each do |m|
          seen_key = key_for(m)
          if !seen.has_key?(seen_key)
            seen[seen_key] = 1
            # dfs: insert at front
            work_queue.unshift(m)
          end
        end
      end
    else
      @max_geode = @geode if @geode > @max_geode
    end
  end
end

end

bbs = []
all_lines.each do |line|
 bbs << Blueprint.new(line)
end

sum = 0
bbs.each_with_index do |bb,i|
  # puts "Part 1: Simulating Blueprint #{bb.num}"
  bb.simulate(24)
  sum += bb.quality
end
puts sum

# part 2: reinitialize (I think we could go on from the end-state of part 1 in theory)
bbs = []
all_lines.each do |line|
 bbs << Blueprint.new(line)
end

prod = 1
bbs.each_with_index do |bb,i|
  if bb.num < 4
    # puts "Part 2: Simulating Blueprint #{bb.num}"
    bb.simulate(32)
    prod *= bb.max_geode
  end
end
puts prod
