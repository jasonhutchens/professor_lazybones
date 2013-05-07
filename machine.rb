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

    def execute!(cpu, memory)
      case @opcode
        when :noop
          cpu.noop
          @done = true
        when :move
          raise RuntimeError, "? BAD DATA" if @value <= 0
          memory.move
          @data -= 1
          @done = true if @data == 0
        when :turn
          memory.turn(0)
          @done = true
        when :sleep
          raise RuntimeError, "? BAD DATA" if @value <= 0
          @data -= 1
          @done = true if @data == 0
        when :use
          memory.use
          @done = true
        when :get
          memory.get
          @done = true
        when :drop
          memory.drop(@data)
          @done = true
        when :wield
          memory.wield(@data)
          @done = true
        when :loop
          raise RuntimeError, "? BAD DATA" if @value <= 0
          @done = true if @data == 0
          @data -= 1
          cpu.loop unless @done
        when :explode
          memory.explode(@data)
          @done = true if @data == 0
          @data -= 1
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

  class Memory

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

    def move
      puts "MOV"
    end

    def turn(direction)
      puts "ROT #{direction}"
    end

  end

  class Processor

    attr_accessor :bus

    def initialize(memory)
      @head = -1
      @tape = []
      @jump_table = []
      @instruction = nil
      @memory = memory
    end

    def push(opcode, value = nil)
      @tape << Instruction.new(opcode, value)
    end

    def reset
      @head = 0
      _load
    end

    def step!
      @instruction.execute!(self, @memory)
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
      puts "NOP"
    end

    def loop
      puts "LOOP"
      @head = @jump_table.pop
      raise "? BAD ACCESS" if @head.nil?
      _load
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

  processor = Computer::Processor.new(Computer::Memory.new)

  processor.push(:noop)
  processor.push(:move, 3)
  processor.push(:loop, 2)
  processor.push(:turn, :left)
  processor.push(:loop, 1)

  processor.reset

  while processor.running?
    processor.step!
  end

end
