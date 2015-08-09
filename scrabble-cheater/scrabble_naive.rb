require 'pp'
require 'set'

class Scrabble

  def initialize dictpath = "/usr/share/dict/words"
    @words = File.readlines(dictpath).map(&:chomp).map(&:downcase).uniq.select { |w| w.length.between?(2, 7) }
  end

  def cheat tiles
    ts = Set.new tiles
    found = []

    @words.each do |w|
      found << w if check_word w, tiles
    end

    found
  end

  def check_word word, tiles
    chars = word.split ''

    tiles.each do |t|
      i = chars.index t
      next unless i
      chars.delete_at i
    end
    chars.empty?
  end
end

require 'minitest/autorun'

class TestScrabble < Minitest::Test
  def setup
    @scrabble = Scrabble.new "test_dict"
  end

  def test_single_tile
    tiles    = %w[a a]
    expected = %w[aa]
    actual   = @scrabble.cheat tiles

    assert_equal expected, actual
  end

  def test_many_tiles
    tiles    = %w[a b a f t k n]
    expected = %w[aa ab aba abaft]
    actual   = @scrabble.cheat tiles

    assert_equal expected, actual
  end

  def test_check_word_single_letter
    word = "a"
    tiles = %w[a]
    assert @scrabble.check_word word, tiles
  end

  def test_check_word_extra_letters
    word  = "cat"
    tiles = %w[a b c t]
    assert @scrabble.check_word word, tiles
  end

  def test_check_word_duplicate_letters
    word = "letter"
    tiles = %w[l e t e r f q]
    refute @scrabble.check_word word, tiles
  end

  def test_check_word_no_tiles
    word = "bath"
    tiles = []
    refute @scrabble.check_word word, tiles
  end
end

class Rack
  # 12 e, 9 a, 9 i, 8 o, 6 n, 6 r, 6 t,
  #  4 l, 4 s, 4 u, 4 d, 3 g,
  #  2 b, 2 c, 2 m, 2 p, 2 f, 2 h, 2 v, 2 w, 2 y,
  #  1 k, 1 j, 1 x, 1 q, 1 z

  DISTRIBUTION = { 12 => ['e'],
                    9 => ['a', 'i'],
                    8 => ['o'],
                    6 => ['n', 'r', 't'],
                    4 => ['l', 's', 'u', 'd'],
                    3 => ['g'],
                    2 => ['b', 'c', 'm', 'p', 'f', 'h', 'v', 'w', 'y'],
                    1 => ['k', 'j', 'x', 'q', 'z'] }

  @tiles = []

  def self.tiles
    return @tiles unless @tiles.empty?
    DISTRIBUTION.each do |count, letters|
      letters.each do |l|
        @tiles += Array.new(count, l)
      end
    end
    @tiles
  end

  def self.new_rack
    self.tiles.sample(7)
  end
end


# LETTERS = ("a".."z").to_a

# p LETTERS

# rack = 7.times.map { LETTERS.sample }

rack = Rack.new_rack

puts "RACK: #{rack.join('')}"

cheater = Scrabble.new
words = cheater.cheat(rack)
words.sort_by! { |x| x.length }

puts "Found #{words.length} words. Longest is #{words.last}"
