# all_lines = File.read('day_18_test_input.txt').split("\n")
all_lines = File.read('day_18_input.txt').split("\n")

DELTA_MOVES = [ [1,0,0], [0,0,1], [-1,0,0], [0,-1,0], [0,0,-1], [0,1,0] ] # R, Top, L, Back, Under, Front

cubes = {}
all_lines.each do |line|
  x,y,z = line.split(",").map(&:to_i)
  cubes[ [x,y,z] ] = 1
end

covered = 0
surface = 0
cubes.each do |c, v|
  DELTA_MOVES.each do |m|
   if cubes.has_key?([c[0] + m[0], c[1] + m[1], c[2] + m[2]])
      covered += 1
    else
      surface += 1
    end
  end
end
puts surface

# part 2

painted = {}
min_x, max_x = cubes.collect { |k,v| k[0] }.minmax
min_y, max_y = cubes.collect { |k,v| k[1] }.minmax
min_z, max_z = cubes.collect { |k,v| k[2] }.minmax


# also check diagonals!
def has_neighbor?(cubes, p)
  [-1,0,1].each do |x|
    [-1,0,1].each do |y|
      [-1,0,1].each do |z|
        if (x != 0) || (y != 0) || (z != 0)
          return true if cubes.has_key?( [ p[0] + x, p[1] + y, p[2] + z] )
        end
      end
    end
  end
  false
end

# or start outside and walk around, assuming it is just one body
paint_queue = []
cc = cubes.find { |c, v| c[0] == max_x }.first
paint_queue << [cc[0] + 1, cc[1], cc[2]]

painted = {}
seen = {}
while paint_queue.size > 0
  p = paint_queue.shift

  # paint all the connecting neighbors
  DELTA_MOVES.each_with_index do |m, i|
    cc = [ p[0] + m[0], p[1] + m[1], p[2] + m[2]]
    if cubes.has_key?(cc)
      painted[ cc + [i] ] = 1
    else
      if !seen.has_key?(cc) && has_neighbor?(cubes, cc) && !paint_queue.include?(cc)
        paint_queue << cc
      end
    end
  end
  seen[p] = 1
end
puts painted.keys.size

__END__

# the ugly long convoluted code below got me the gold star
# the idea was to paint a surface and then walk the next connected surface
# for all sides of a cube there are four connected surfaces, either on the cube it self
# or on a connected cube, there are 3 possibilites for such connected surface: 
#
#  ###|  the top of the painted ("|") surface
#  ###|  can be connected to
#  ###|
#
#  ---|  the --- surface
#  ###|
#  ###|
#
#  ***|  the "|" surface of the cube above
#  ***|
#  ***|
#  ###|
#  ###|
#  ###|
#
#
#      ### the ___ surface
#      ###
#      ___
#  ###|
#  ###|
#  ###|

# start cubes to start painting collected cubes
# could there be multiple painted objects?

cc = cubes.find { |c, v| c[0] == max_x }.first
si = 0

# Surface index: right, top, left, back, under, front
#                0      1    2     3     4      5
def next_surfaces_for(cubes, cc, surface_index)
  nn = []
  if surface_index == 0
    # 0 -> 1
    ns = [[ 1, 0, 1, 4],
          [ 0, 0, 1, 0],
          [ 0, 0, 0, 1]].find { |d| cubes.has_key?( [ cc[0] + d[0], cc[1] + d[1], cc[2] + d[2]] ) }
    nn << [ cc[0] + ns[0], cc[1] + ns[1], cc[2] + ns[2], ns[3]]

    # 0 -> 3
    ns = [[ 1, -1, 0, 5],
          [ 0, -1, 0, 0],
          [ 0,  0, 0, 3]].find { |d| cubes.has_key?( [ cc[0] + d[0], cc[1] + d[1], cc[2] + d[2]] ) }
    nn << [ cc[0] + ns[0], cc[1] + ns[1], cc[2] + ns[2], ns[3]]

    # 0 -> 4
    ns = [[ 1,  0, -1, 1],
          [ 0,  0, -1, 0],
          [ 0,  0,  0, 4]].find { |d| cubes.has_key?( [ cc[0] + d[0], cc[1] + d[1], cc[2] + d[2]] ) }
    nn << [ cc[0] + ns[0], cc[1] + ns[1], cc[2] + ns[2], ns[3]]

    # 0 -> 5
    ns = [[ 1,  1, 0, 3],
          [ 0,  1, 0, 0],
          [ 0,  0, 0, 5]].find { |d| cubes.has_key?( [ cc[0] + d[0], cc[1] + d[1], cc[2] + d[2]] ) }
    nn << [ cc[0] + ns[0], cc[1] + ns[1], cc[2] + ns[2], ns[3]]

  elsif surface_index == 1
    # 1 -> 2
    ns = [[ -1, 0, 1, 0],
          [ -1, 0, 0, 1],
          [  0, 0, 0, 2]].find { |d| cubes.has_key?( [ cc[0] + d[0], cc[1] + d[1], cc[2] + d[2]] ) }
    nn << [ cc[0] + ns[0], cc[1] + ns[1], cc[2] + ns[2], ns[3]]

    # 1 -> 3
    ns = [[  0, -1, 1, 5],
          [  0, -1, 0, 1],
          [  0,  0, 0, 3]].find { |d| cubes.has_key?( [ cc[0] + d[0], cc[1] + d[1], cc[2] + d[2]] ) }
    nn << [ cc[0] + ns[0], cc[1] + ns[1], cc[2] + ns[2], ns[3]]

    # 1 -> 5
    ns = [[  0, 1, 1, 3],
          [  0, 1, 0, 1],
          [  0, 0, 0, 5]].find { |d| cubes.has_key?( [ cc[0] + d[0], cc[1] + d[1], cc[2] + d[2]] ) }
    nn << [ cc[0] + ns[0], cc[1] + ns[1], cc[2] + ns[2], ns[3]]

    # 1 -> 0
    ns = [[  1, 0, 1, 2],
          [  1, 0, 0, 1],
          [  0, 0, 0, 0]].find { |d| cubes.has_key?( [ cc[0] + d[0], cc[1] + d[1], cc[2] + d[2]] ) }
    nn << [ cc[0] + ns[0], cc[1] + ns[1], cc[2] + ns[2], ns[3]]

  elsif surface_index == 2
    # 2 -> 3
    ns = [[ -1, -1, 0, 5],
          [  0, -1, 0, 2],
          [  0,  0, 0, 3]].find { |d| cubes.has_key?( [ cc[0] + d[0], cc[1] + d[1], cc[2] + d[2]] ) }
    nn << [ cc[0] + ns[0], cc[1] + ns[1], cc[2] + ns[2], ns[3]]

    # 2 -> 4
     ns = [[ -1,  0, -1, 1],
           [  0,  0, -1, 2],
           [  0,  0,  0, 4]].find { |d| cubes.has_key?( [ cc[0] + d[0], cc[1] + d[1], cc[2] + d[2]] ) }
     nn << [ cc[0] + ns[0], cc[1] + ns[1], cc[2] + ns[2], ns[3]]

    # 2 -> 5
    ns = [[ -1,  1, 0, 3],
          [  0,  1, 0, 2],
          [  0,  0, 0, 5]].find { |d| cubes.has_key?( [ cc[0] + d[0], cc[1] + d[1], cc[2] + d[2]] ) }
    nn << [ cc[0] + ns[0], cc[1] + ns[1], cc[2] + ns[2], ns[3]]

    # 2 -> 1
    ns = [[ -1,  0, 1, 4],
          [  0,  0, 1, 2],
          [  0,  0, 0, 1]].find { |d| cubes.has_key?( [ cc[0] + d[0], cc[1] + d[1], cc[2] + d[2]] ) }
    nn << [ cc[0] + ns[0], cc[1] + ns[1], cc[2] + ns[2], ns[3]]

  elsif surface_index == 3
    # 3 -> 4
    ns = [[  0, -1, -1, 1],
          [  0,  0, -1, 3],
          [  0,  0,  0, 4]].find { |d| cubes.has_key?( [ cc[0] + d[0], cc[1] + d[1], cc[2] + d[2]] ) }
    nn << [ cc[0] + ns[0], cc[1] + ns[1], cc[2] + ns[2], ns[3]]

    # 3 -> 0
    ns = [[  1, -1,  0, 2],
          [  1,  0,  0, 3],
          [  0,  0,  0, 0]].find { |d| cubes.has_key?( [ cc[0] + d[0], cc[1] + d[1], cc[2] + d[2]] ) }
    nn << [ cc[0] + ns[0], cc[1] + ns[1], cc[2] + ns[2], ns[3]]

    # 3 -> 1
    ns = [[  0, -1,  1, 4],
          [  0,  0,  1, 3],
          [  0,  0,  0, 1]].find { |d| cubes.has_key?( [ cc[0] + d[0], cc[1] + d[1], cc[2] + d[2]] ) }
    nn << [ cc[0] + ns[0], cc[1] + ns[1], cc[2] + ns[2], ns[3]]

    # 3 -> 2
    ns = [[  -1, -1, 0, 0],
          [  -1,  0, 0, 3],
          [   0,  0, 0, 2]].find { |d| cubes.has_key?( [ cc[0] + d[0], cc[1] + d[1], cc[2] + d[2]] ) }
    nn << [ cc[0] + ns[0], cc[1] + ns[1], cc[2] + ns[2], ns[3]]

  elsif surface_index == 4
    # 4 -> 5
    ns = [[  0,  1, -1, 3],
          [  0,  1,  0, 4],
          [  0,  0,  0, 5]].find { |d| cubes.has_key?( [ cc[0] + d[0], cc[1] + d[1], cc[2] + d[2]] ) }
    nn << [ cc[0] + ns[0], cc[1] + ns[1], cc[2] + ns[2], ns[3]]

    # 4 -> 0
    ns = [[  1,  0, -1, 2],
          [  1,  0,  0, 4],
          [  0,  0,  0, 0]].find { |d| cubes.has_key?( [ cc[0] + d[0], cc[1] + d[1], cc[2] + d[2]] ) }
    nn << [ cc[0] + ns[0], cc[1] + ns[1], cc[2] + ns[2], ns[3]]

    # 4 -> 2
    ns = [[  -1,  0, -1, 0],
          [  -1,  0,  0, 4],
          [   0,  0,  0, 2]].find { |d| cubes.has_key?( [ cc[0] + d[0], cc[1] + d[1], cc[2] + d[2]] ) }
    nn << [ cc[0] + ns[0], cc[1] + ns[1], cc[2] + ns[2], ns[3]]

    # 4 -> 3
    ns = [[  0,  -1, -1, 5],
          [  0,  -1,  0, 4],
          [  0,   0,  0, 3]].find { |d| cubes.has_key?( [ cc[0] + d[0], cc[1] + d[1], cc[2] + d[2]] ) }
    nn << [ cc[0] + ns[0], cc[1] + ns[1], cc[2] + ns[2], ns[3]]

  elsif surface_index == 5
    # 5 -> 0
    ns = [[  1,  1,  0, 2],
          [  1,  0,  0, 5],
          [  0,  0,  0, 0]].find { |d| cubes.has_key?( [ cc[0] + d[0], cc[1] + d[1], cc[2] + d[2]] ) }
    nn << [ cc[0] + ns[0], cc[1] + ns[1], cc[2] + ns[2], ns[3]]

    # 5 -> 1
    ns = [[  0,  1,  1, 4],
          [  0,  0,  1, 5],
          [  0,  0,  0, 1]].find { |d| cubes.has_key?( [ cc[0] + d[0], cc[1] + d[1], cc[2] + d[2]] ) }
    nn << [ cc[0] + ns[0], cc[1] + ns[1], cc[2] + ns[2], ns[3]]

    # 5 -> 2
    ns = [[  -1,  1,  0, 0],
          [  -1,  0,  0, 5],
          [   0,  0,  0, 2]].find { |d| cubes.has_key?( [ cc[0] + d[0], cc[1] + d[1], cc[2] + d[2]] ) }
    nn << [ cc[0] + ns[0], cc[1] + ns[1], cc[2] + ns[2], ns[3]]

    # 5 -> 4
    ns = [[  0,  1, -1, 1],
          [  0,  0, -1, 5],
          [  0,  0,  0, 4]].find { |d| cubes.has_key?( [ cc[0] + d[0], cc[1] + d[1], cc[2] + d[2]] ) }
    nn << [ cc[0] + ns[0], cc[1] + ns[1], cc[2] + ns[2], ns[3]]
  end
  nn
end

painted = {}
paint_queue = []
paint_queue << cc + [si]

while paint_queue.size > 0
  p = paint_queue.shift
  painted[ p ] = 1

  cc = p[0..2]
  si = p[3]
  next_surfaces = next_surfaces_for(cubes, cc, si)
  next_surfaces.each do |ns|
    if !painted.has_key?(ns) && !paint_queue.include?(ns)
      paint_queue << ns
    end
  end
end
puts painted.keys.size

