require 'pp'

def count_value value, roll
  roll.select { |x| x == value }.length
end

def n_the_same? n, roll
  (1..6).each do |x|
    return true if count_value(x, roll) == n
  end
  false
end

def full_house? roll
  return false if (roll[0] != roll[1])
  return false if (roll[3] != roll[4])

  return true if (roll[1] == roll[2])
  return true if (roll[2] == roll[3])

  false
end

def small_straight? roll
  (1..4).all? { |x| roll.include?(x) } or
    (2..5).all? { |x| roll.include?(x) } or
    (3..6).all? { |x| roll.include?(x) }
end

def large_straight? roll
  (1..5).all? { |x| roll.include?(x) } or
    (2..6).all? { |x| roll.include?(x) }
end

def score roll
  roll = roll.sort
  roll_sum = roll.inject(:+)

  scores = {}


  scores[:chance] = roll_sum
  scores[:ones]   = count_value(1, roll)
  scores[:twos]   = count_value(2, roll) * 2
  scores[:threes] = count_value(3, roll) * 3
  scores[:fours]  = count_value(4, roll) * 4
  scores[:fives]  = count_value(5, roll) * 5
  scores[:sixes]  = count_value(6, roll) * 6

  if n_the_same?(5, roll)
    scores[:yahtzee]         = 50
  elsif n_the_same?(4, roll)
    scores[:four_of_a_kind]  = roll_sum
  elsif n_the_same?(3, roll)
    scores[:three_of_a_kind] = roll_sum
  end

  scores[:full_house]     = 25 if full_house? roll
  scores[:small_straight] = 30 if small_straight? roll
  scores[:large_straight] = 40 if large_straight? roll

  max = scores.max_by {|k, v| v }
  return max
end




roll = Array.new(5) { rand(6) + 1 }

pp roll
pp score(roll)

stats = Hash.new(0)

1_000_000.times do
  roll = Array.new(5) { rand(6) + 1 }
  type, _ = score roll
  stats[type] += 1
end


pp stats
