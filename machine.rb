#!/usr/bin/env ruby

# A computer runs a program tape. You load, run, step, reset. It had inputs and
# outputs.

module Computer

  class RuntimeError < Exception
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
  class Instruction
    
    attr_reader :opcode, :value

    OPCODES = [
      :noop,
      :move,
      :turn,
      :sleep,
      :use,
      :get,
      :drop,
      :wield,
      :loop,
      :explode
    ]

    DIRECTIONS = [
      :here,
      :north,
      :south,
      :east,
      :west,
      :front,
      :right,
      :behind,
      :left
    ]

    def initialize(opcode, value)
      @opcode, @value = opcode, value
    end

    def load
    end

    def execute
    end

    def done?
      false
    end

    def to_s
      "#{@opcode} #{@value}"
    end

  end

  class Processor

    def initialize
      @head = -1
      @tape = []
      @instruction = nil
      reset
    end

    def push(opcode, value = nil)
      @tape << Instruction.new(opcode, value)
    end

    def reset
    end

    def step
    end

    def running?
      true
    end

    def to_s
      @tape.join("\n")
    end

  end

end

if __FILE__ == $0

  processor = Computer::Processor.new  

  processor.push(:move, 7)
  processor.push(:noop)
  processor.push(:turn, :left)
  processor.push(:move, 3)
  processor.push(:loop, 2)
  processor.push(:get, :north)
  processor.push(:wield, 1)
  processor.push(:use, 2)

  processor.reset

  while processor.running?
    processor.step
  end

end
