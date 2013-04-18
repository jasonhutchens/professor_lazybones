#!/usr/bin/env ruby

require 'rubygems'
require 'bundler'

Bundler.require(:default)

class Game < Chingu::Window
end

if __FILE__ == $0
  Game.new.show
end
