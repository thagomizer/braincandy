#!/usr/bin/env ruby -w

require "graphics"

class Ball < Graphics::Body
  GRAVITY = [0, -2]

  attr_accessor :color, :x, :y, :width, :window, :velocity

  def initialize w
    super
    @color    = :red
    @x        = 50
    @y        = 600
    @width    = 15
    @window   = w
    @velocity = [0, 0]
  end

  def update
    if self.on_edge? then
      @velocity[1] *= -0.9
    end

    @velocity[0] += GRAVITY[0]
    @velocity[1] += GRAVITY[1]

    @x += @velocity[0]
    @y += @velocity[1]

    self.clip
  end

  def on_edge?
    return true if @x < @width or @y < @width
    return true if @x >= 640 - @width
    return true if @y >= 640 - @width
  end

  def draw
    #TODO
  end
end

class BounceSimulation < Graphics::Simulation
  def initialize
    super 640, 640, 16, "Bounce"
    @ball = Ball.new self
  end

  def update n
    @ball.update
  end

  def draw n
    self.clear
    self.circle @ball.x, @ball.y, @ball.width, @ball.color, true
  end
end

BounceSimulation.new.run
