require_relative '../spec_helper'
require_relative '../../lib/befunge/interpreter.rb'

def expect_cell(controller, memory, *cell)
  expect(controller).to receive(:position).at_least(:once) # .exactly(cell.count).times
  expect(memory).to receive(:[]).and_return(*cell)
end

describe Befunge::Interpreter do
  let(:alu) { double('alu') }
  let(:controller) { double('controller') }
  let(:memory) { double('memory') }
  subject { Befunge::Interpreter.new(alu, controller, memory) }

  (0..9).each do |i|
    describe "opcode #{i}" do
      it "sends _#{i} to the alu" do
        expect_cell(controller, memory, i.to_s)
        expect(alu).to receive(:"_#{i}")
        subject.send(:dispatch)
      end
    end
  end

  %w(+ - * / %).each do |op|
    describe "opcode #{op}" do
      it "sends #{op} to the alu" do
        expect_cell(controller, memory, op)
        expect(alu).to receive(op)
        subject.send(:dispatch)
      end
    end
  end

  {'$' => :pop, '\\' => :swap,
   ':' => :dupl, '`' => :compare,
   '!' => :! }.each do |op, message|
    describe "opcode #{op}" do
      it "sends #{message} to the alu" do
        expect_cell(controller, memory, op)
        expect(alu).to receive(message)
        subject.send(:dispatch)
      end
    end
  end

 {'<' => :direction=, '>' => :direction=,
  '^' => :direction=, 'v' => :direction=,
  '?' => :_?, '#' => :trampoline! }.each do |op, message|
    describe "opcode #{op}" do
      it "sends #{message} to the controller" do
        expect_cell(controller, memory, op)
        expect(controller).to receive(message)
        subject.send(:dispatch)
      end
    end
  end

  ['_', '|'].each do |op|
    describe "opcode #{op}" do
      it "sends pop to the alu, and forwards the popped value to the controller" do
        expect_cell(controller, memory, op)
        expect(alu).to receive(:pop).and_return(:dummy)
        expect(controller).to receive(op).with(:dummy)
        subject.send(:dispatch)
      end
    end
  end

  describe "opcode ." do
    it "sends pop to the alu and writes that value" do
      expect_cell(controller, memory, '.')
      expect(alu).to receive(:pop).and_return(3)
      expect(memory).to receive(:write).with("3")
      subject.send(:dispatch)
    end
  end

  describe "opcode ," do
    it "sends pop to the alu and writes the ASCII of that value" do
      expect_cell(controller, memory, ',')
      expect(alu).to receive(:pop).and_return('a'.ord)
      expect(memory).to receive(:write).with('a')
      subject.send(:dispatch)
    end
  end

  describe "opcode \"a\"" do
    it "sets itself to string mode, pushes 'a' and comes out of string mode" do
      expect_cell(controller, memory, '"', 'a', '"')
      expect(alu).to receive(:push).with('a'.ord)
      3.times { subject.send(:dispatch) }
    end
  end

  describe 'opcode p' do
    it "sends 3 pops to the ALU and writes to the program" do
      expect_cell(controller, memory, 'p')
      expect(alu).to receive(:pop).exactly(3).times.and_return(10, 20, 30)
      expect(memory).to receive(:[]=).with(Befunge::Vector.new(20, 10), 30.chr)
      subject.send(:dispatch)
    end
  end

  describe 'opcode g' do
    it "sends 2 pops to the ALU and pushes the value from the program" do
      expect(controller).to receive(:position).at_least(:once).and_return(Befunge::Vector.new(0, 0))
      expect(memory).to receive(:[])
        .ordered.with(Befunge::Vector.new(0, 0)).and_return('g')
      expect(memory).to receive(:[])
        .ordered.with(Befunge::Vector.new(20, 10)).and_return('x')
      expect(alu).to receive(:pop).exactly(2).times.and_return(10, 20)
      expect(alu).to receive(:push).with('x'.ord)
      subject.send(:dispatch)
    end
  end
end
