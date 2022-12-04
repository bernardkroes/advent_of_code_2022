all_lines = File.read('day_4_input.txt').split("\n")
# all_lines = File.read('day_4_test_input.txt').split("\n")

the_count = 0
all_lines.each do |line|
  s1, s2 = line.split(",")
  s1_s, s1_e = s1.split("-").map(&:to_i)
  s2_s, s2_e = s2.split("-").map(&:to_i)
  section1 = (s1_s..s1_e)
  section2 = (s2_s..s2_e)

  if section2.include?(s1_s) && section2.include?(s1_e) # or: section2.include?(section1.first) && section2.include?(section1.last)
    the_count += 1
  elsif section1.include?(s2_s) && section1.include?(s2_e)
    the_count += 1
  end
end
puts the_count

the_count = 0
all_lines.each do |line|
  s1, s2 = line.split(",")
  s1_s, s1_e = s1.split("-").map(&:to_i)
  s2_s, s2_e = s2.split("-").map(&:to_i)
  section1 = (s1_s..s1_e)
  section2 = (s2_s..s2_e)

  if section2.include?(s1_s) || section2.include?(s1_e)
    the_count += 1
  elsif section1.include?(s2_s) || section1.include?(s2_e)
    the_count += 1
  end
end
puts the_count
