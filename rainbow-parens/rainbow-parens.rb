# Valid:
# ()
# []
# {}
# ({})
# ([{()}()])
# (define square (lambda (x) (* x x)))
# (define smile "(:")

# Invalid:
# ([{()}()])
# ([{()}()}])
# (define square (lambda (x) (* x x)

COLORS = ["\e[31m", "\e[33m", "\e[32m", "\e[34m", "\e[36m", "\e[35m"]
RESET = "\e[0m"

def rainbowize str
  color_index = 0
  current_color = RESET
  in_quotes = false

  str.each_char do |c|
    new_color = current_color

    case
    when c =~ /"/
      in_quotes = !in_quotes
      new_color = RESET
    when in_quotes
      new_color = RESET
    when c =~ /[\(\{\[]/
      new_color = COLORS[color_index % 6]
      color_index += 1
    when c =~ /[\)\}\]]/
      color_index -= 1
      new_color = COLORS[color_index % 6]
    else
      new_color = RESET
    end

    if new_color != current_color
      print new_color
      current_color = new_color
    end

    print c
  end

  print RESET
  puts
end

require 'minitest/autorun'

class TestRainbowize < Minitest::Test
  def test_simple
    assert_output("\e[31m()\e[0m\n") {
      rainbowize "()"
    }
    assert_output("\e[31m[]\e[0m\n") {
      rainbowize "[]"
    }
    assert_output("\e[31m{}\e[0m\n") {
      rainbowize "{}"
    }
  end

  def test_nested
    assert_output("\e[31m(\e[33m{}\e[31m)\e[0m\n") {
      rainbowize "({})"
    }
  end

  def test_complex_nested
    assert_output("\e[31m(\e[33m[\e[32m{\e[34m()\e[32m}()\e[33m]\e[31m)\e[0m\n") {
      rainbowize "([{()}()])"
    }
  end

  def test_function
    assert_output("\e[31m(\e[0md s \e[33m(\e[0ml \e[32m(\e[0mx\e[32m)\e[0m \e[32m(\e[0m* x x\e[32m)\e[33m)\e[31m)\e[0m\n") {
      rainbowize "(d s (l (x) (* x x)))"
    }
  end

  def test_quotes
    assert_output("\e[31m(\e[0md \"(:\" \e[31m)\e[0m\n") {
      rainbowize '(d "(:" )'
    }
  end
end

rainbowize '(d "(:")'
