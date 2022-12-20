mix = File.read('day_20_input.txt').split("\n").map(&:to_i)

ii = []
original_zero_index = -1
mix.each_with_index do |m, i|
  ii << [m,i]
  original_zero_index = i if m == 0
end
the_size = ii.size

mix.each_with_index do |m, i|
  found_i = ii.find_index([m,i])
  ii.delete_at(found_i)
  dest = (found_i + m) % (the_size - 1)
  ii.insert(dest, [m,i])
end

i_zero = ii.find_index([0,original_zero_index])
puts ii[(i_zero + 1000) % the_size][0] + ii[(i_zero + 2000) % the_size][0] + ii[(i_zero + 3000) % the_size][0]

# part 2

ii = []
original_zero_index = -1
mix.each_with_index do |m, i|
  mix[i] = m * 811589153
  ii << [m * 811589153,i]
  original_zero_index = i if m == 0
end
the_size = ii.size

10.times do
  mix.each_with_index do |m, i|
    found_i = ii.find_index([m, i])
    ii.delete_at(found_i)
    dest = (found_i + m) % (the_size - 1)
    ii.insert(dest, [m,i])
  end
end

i_zero = ii.find_index([0,original_zero_index])
puts ii[(i_zero + 1000) % the_size][0] + ii[(i_zero + 2000) % the_size][0] + ii[(i_zero + 3000) % the_size][0]
