#!/usr/bin/env ruby

require 'rubygems'
require 'bundler'

Bundler.require(:default)

class Game < Chingu::Window

  def initialize
    super(800, 600, false)

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
    super
  end

end

class Player < Chingu::GameObject

  def setup
    @image = Gosu::Image['captain.png']
  end

end

if __FILE__ == $0
  Game.new.show
end
