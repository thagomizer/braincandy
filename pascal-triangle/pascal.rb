# 1
# 1 1
# 1 2 1
# 1 3 3 1

require 'pp'

TRIANGLE = [[1], [1, 1]]

# gets row n of pascal's triangle
def iterative n
  return TRIANGLE[n] if n < 2

  i = 1
  prev = TRIANGLE[i - 1]
  row  = TRIANGLE[i]
  while i <= n do
    prev = row
    row = [1]
    i += 1

    prev.each_cons(2) do |a, b|
      row << a + b
    end
    row << 1
  end

  return prev
end

def recursive n
  return TRIANGLE[n] if n < 2

  prev = recursive n - 1

  row = [1]
  prev.each_cons(2) do |a, b|
    row << a + b
  end

  row << 1

  return row
end

# pp iterative(0)
# pp iterative(1)
pp iterative(5)

pp recursive(5)
