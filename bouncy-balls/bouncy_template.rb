#!/usr/bin/env ruby -w

require "graphics"
require "pp"

COLORS = [:red, :blue, :yellow, :white, :green]

class Ball < Graphics::Body
  GRAVITY = V[0, -0.2]

  attr_accessor :color, :width

  def initialize w
    super
    @color    = COLORS.sample
    @width    = rand(10) + 5
    @y = rand(w.h / 2) + w.h / 2
    @a = random_angle
    @m = rand(10)
  end

  def update
    self.velocity += GRAVITY

    self.move

    self.bounce
  end

  def on_edge?
    return true if @y < @width
    return true if @y >= self.w.h - @width
  end

  def draw
    @w.circle @x, @y, @width, @color, true
  end
end

class BounceSimulation < Graphics::Simulation
  def initialize
    super 640, 640, 16, "Bounce"

    @balls = populate(Ball, 50)
  end

  def update n
    @balls.map(&:update)
  end

  def draw n
    self.clear

    @balls.map(&:draw)
  end
end

BounceSimulation.new.run
