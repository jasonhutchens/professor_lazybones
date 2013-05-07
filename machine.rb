#!/usr/bin/env ruby

module Computer

  class RuntimeError < Exception
  end

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
      @data = nil
      @done = true
    end

    def load
      @data = @value if @done
      @done = false
    end

    def execute!(cpu)
      puts "#{@opcode} #{@data}"
      case @opcode
        when :noop
          @done = true
          cpu.noop
        when :move
          @data -= 1
          @done = true if @data < 0
          cpu.move
        when :turn
          @done = true
          cpu.turn(data)
        when :sleep
          @data -= 1
          @done = true if @data < 0
          cpu.wait
        when :use
          @done = true
          cpu.use
        when :get
          @done = true
          cpu.get
        when :drop
          @done = true
          cpu.drop
        when :wield
          @done = true
          cpu.wield
        when :loop
          @done = true
          cpu.loop
        when :explode
          @done = true
          cpu.explode
        else
          raise RuntimeError, "? NO SUCH OPCODE"
      end
    end

    def done?
      @done
    end

    def to_s
      "#{@opcode} #{@value}"
    end

  end

  class Bus

    attr_accessor :position
    attr_accessor :heading
    attr_accessor :inventory
    attr_accessor :held

    def initialize
      @position = [0, 0]
      @heading = [0, -1]
      @inventory = Array.new(8, 0)
      @held = 0
    end

  end

  class Processor

    attr_accessor :bus

    def initialize
      @head = -1
      @tape = []
      @jump_table = []
      @instruction = nil
      @bus = Bus.new
    end

    def push(opcode, value = nil)
      @tape << Instruction.new(opcode, value)
    end

    def reset
      @head = 0
      _load
    end

    def step!
      @instruction.execute!(self)
      if @instruction.done?
        @head += 1
        _load
      end
    end

    def running?
      @head >= 0
    end

    def to_s
      @tape.join("\n")
    end

    def noop
      @jump_table << @head
    end

    def move
      @bus.move
    end

    def turn
      @bus.turn
    end

    def wait
      @bus.wait
    end

    private

    def _load
      @head = -1 if @head >= @tape.length
      return unless running?
      @instruction = @tape[@head]
      @instruction.load
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
    processor.step!
  end

end
