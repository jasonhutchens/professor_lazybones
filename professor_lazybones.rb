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

# + M move (0 = until blocked, 1-8 = steps)
# + T turn (x, n, s, e, w, f, r, b, l)
# + Z sleep (1-8 = steps)
# + U use (1-8 = steps)
# + D drop (x, n, e, s, w, f, r, b, l)
# + W wield (0 = nothing, 1-8 = inventory items)
# + L loop (1-8 = steps)
# + X explode (0-8 = steps)
# + N noop (used for loop point only)

class Player < Chingu::GameObject

  def setup
    @image = Gosu::Image['captain.png']
    @cell = [7, 5]
    @code = [ { M: 2 }, { T: 8 }, { N: 0 }, { M: 3 }, { T: 6 }, { L: 3 }, { Z: 3 }, { X: 0 } ]
    @heading = 1
    @pointer = -1
    @opcode = -1
    @data = -1
    @label = -1
    @loop = -1
    update
  end

  def update
    super
    _run_code
    _update_position
  end

  def draw
    super
  end

  private

  def _update_position
    @x, @y = @cell.map { |v| (v+1.5)*48 }
  end

  def _run_code
    if @pointer < 0
      _reboot
    else
      true while _step
    end
  end

  def _reboot
    @pointer = 0
    _load
  end

  def _step
    puts "#{@opcode}(#{@data})"
    case @opcode
      when :M
        # TODO: move guy in heading
        _move
        @data -= 1
        _increment and _load if @data == 0
        false
      when :T
        _turn(@data)
        # TODO: set heading
        _increment and _load
        true
      when :Z
      when :U
      when :D
      when :W
      when :L
        @pointer = @label
        _load
        true
      when :X
      when :N
        @label = @pointer
        _increment and _load
        true
      else
        raise
    end
  end

  def _load
    @opcode, @data = @code[@pointer].to_a.flatten
  end

  def _move
    case @heading
      when 1
        @cell[1] -= 1
      when 2
        @cell[0] += 1
      when 3
        @cell[1] += 1
      when 4
        @cell[0] -= 1
      else
        raise
    end
    @cell[0] = 14 if @cell[0] < 0
    @cell[0] = 0 if @cell[0] > 14
    @cell[1] = 9 if @cell[1] < 0
    @cell[1] = 0 if @cell[1] > 9
  end

  def _turn(data)
    case data
      when 1
        @heading = 1
      when 2
        @heading = 2
      when 3
        @heading = 3
      when 4
        @heading = 4
      when 5
      when 6
        @heading += 1
        @heading = 1 if @heading > 4
      when 7
        @heading = 5 - @heading
      when 8
        @heading -= 1
        @heading = 4 if @heading < 1
      else
        raise
    end
  end

  def _increment
    @pointer += 1
  end

end

if __FILE__ == $0
  Game.new.show
end
