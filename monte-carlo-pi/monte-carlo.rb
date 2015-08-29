shots = ARGV[0].to_i

def distance_from_origin x, y
  x**2 + y**2
end

inside = 0

shots.times do
  x = Random.rand
  y = Random.rand

  inside += 1 if distance_from_origin(x, y) < 1.0
end

puts "Inside #{inside}"
puts "Total #{shots}"

puts "Pi?!?! #{inside.to_f / shots * 4}"
