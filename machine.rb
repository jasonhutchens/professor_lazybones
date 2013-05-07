#!/usr/bin/env ruby

module Computer

  class RuntimeError < Exception
  end

  class Instruction
    
    attr_reader :opcode, :value

    OPCODES = [ :noop, :move, :turn, :sleep, :use, :get, :drop, :wield, :loop, :explode ]

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
          raise RuntimeError, "? BAD DATA" if @data <= 0
          memory.move
          cpu.block!
          @data -= 1
          @done = true if @data == 0
        when :turn
          _turn(memory)
          @done = true
        when :sleep
          raise RuntimeError, "? BAD DATA" if @value <= 0
          cpu.block!
          @data -= 1
          @done = true if @data == 0
        when :use
          raise RuntimeError, "? BAD DATA" if @value <= 0
          memory.use
          cpu.block!
          @data -= 1
          @done = true if @data == 0
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

    private

    DIRECTIONS = [ :here, :north, :east, :south, :west, :front, :right, :behind, :left ]

    def _turn(memory)
      heading = case @data
        when :here
          memory.heading
        when :north
          1
        when :east
          2
        when :south
          3
        when :west
          4
        when :front
          memory.heading
        when :right
          heading = memory.heading + 1
          heading = heading - 4 if heading > 4
          heading
        when :behind
          heading = memory.heading + 2
          heading = heading - 4 if heading > 4
          heading
        when :left
          heading = memory.heading - 1
          heading = heading + 4 if heading < 1
          heading
        else
          raise RuntimeError, "? BAD DIRECTION"
      end
      memory.face(heading)
    end

  end

  class Memory

    attr_accessor :position
    attr_accessor :heading
    attr_accessor :inventory
    attr_accessor :held

    def initialize
      @position = [0, 0]
      @heading = 1
      @inventory = Array.new(8, 0)
      @held = 0
    end

    def move
      puts "MOV"
      case @heading
        when 1
          @position[1] -= 1
        when 2
          @position[0] += 1
        when 3
          @position[1] += 1
        when 4
          @position[0] -= 1
      end
    end

    def face(heading)
      puts "ROT #{heading}"
      @heading = heading
    end

    def to_s
      "#{@heading}:[#{@position[0]}, #{@position[1]}]"
    end

  end

  class Processor

    attr_accessor :memory

    def initialize(memory)
      @head = -1
      @tape = []
      @jump_table = []
      @instruction = nil
      @memory = memory
      @blocked = false
    end

    def push(opcode, value = nil)
      @tape << Instruction.new(opcode, value)
    end

    def reset
      @head = 0
      _load
    end

    def step!
      puts "+++ STEP +++"
      @blocked = false
      while running? && !@blocked
        @instruction.execute!(self, @memory)
        if @instruction.done?
          @head += 1
          _load
        end
      end
    end

    def block!
      @blocked = true
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
  processor.push(:move, 2)
  processor.push(:loop, 2)
  processor.push(:turn, :left)
  processor.push(:loop, 1)

  processor.reset

  while processor.running?
    processor.step!
    puts processor.memory
  end

end
