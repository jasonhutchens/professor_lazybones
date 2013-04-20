#!/usr/bin/env ruby

require 'rubygems'
require 'bundler'

Bundler.require(:default)

class Game < Chingu::Window

  def initialize
    super(1200, 675, false)

    self.input = {
      escape: :exit
    }

    switch_game_state(Level)
  end

end

class Level < Chingu::GameState

  def initialize
    super

    @player = Player.create(x: 100, y: 100, zorder: 500)
  end

  def setup
  end

  def update
    super
  end

  def draw
    _draw_guide
    c = 0xFFFFFFFF
    (0...$window.width).step(48) do |x|
      $window.draw_line(x, 0, c, x, $window.height, c)
    end
    (0..$window.height).step(48) do |y|
      $window.draw_line(0, y, c, $window.width, y, c)
    end
    super
  end

  private

  def _draw_guide
    c = 0xAAFF0000
    $window.draw_quad(48,48,c,16*48,48,c,16*48,11*48,c,48,11*48,c)
    c = 0xAA00FF00
    $window.draw_quad(17*48,48,c,24*48,48,c,24*48,11*48,c,17*48,11*48,c)
    c = 0xAA0000FF
    $window.draw_quad(48,12*48,c,24*48,12*48,c,24*48,13*48,c,48,13*48,c)
  end

end

class Player < Chingu::GameObject

  def setup
    @image = Gosu::Image['captain.png']
    @cell = [2, 0]
    update
  end

  def update
    super
    _update_position
  end

  def draw
    super
  end

  private

  def _update_position
    @x, @y = @cell.map { |v| (v+1.5)*48 }
  end

end

if __FILE__ == $0
  Game.new.show
end
