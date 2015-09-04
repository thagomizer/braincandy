#!/usr/bin/env ruby -w

require "graphics"
require "pp"

COLORS = [:red, :blue, :yellow, :white, :green]

class Ball < Graphics::Body
  GRAVITY = V[0, -2]

  attr_accessor :color, :width

  def initialize w
    super
    @color    = COLORS.sample
    @width    = 10
    @y = rand(w.h / 2) + w.h / 2
  end

  def update
    if self.on_edge? then
     self.velocity *= -0.9
    end

    self.velocity += GRAVITY

    self.move

    self.clip
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

    @balls = populate(Ball, 200)
  end

  def update n
    @balls.map(&:update)
  end

  def draw n
    self.clear

    @balls.each do |ball|
      ball.draw
    end
  end
end

BounceSimulation.new.run
