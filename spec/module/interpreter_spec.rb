require_relative '../spec_helper'
require_relative '../../lib/befunge/interpreter.rb'

def move_two_cells(controller)
  allow(controller).to receive(:position).and_return(Befunge::Vector.new(0, 0),
                                                     Befunge::Vector.new(1, 0))
  allow(controller).to receive(:move!)
end

describe Befunge::Interpreter do
  let :alu { double('alu') }
  let :controller { double('controller') }
  subject { Befunge::Interpreter.new(alu, controller) }

  (0..9).each do |i|
    describe "#run(\"#{i}@\")" do
      it "sends _#{i} to the alu" do
        move_two_cells(controller)
        expect(alu).to receive(:"_#{i}")
        subject.run("#{i}@")
      end
    end
  end

  {'$' => :pop, '\\' => :swap,
   ':' => :dupl, '`' => :compare}.each do |op, message|
    describe "#run(\"#{op}@\")" do
      it "sends #{message} to the alu" do
        move_two_cells(controller)
        expect(alu).to receive(message)
        subject.run("#{op}@")
      end
    end
  end

 {'<' => :direction=, '>' => :direction=,
  '^' => :direction=, 'v' => :direction=,
  '?' => :_? }.each do |op, message|
    describe "#run(\"#{op}@\")" do
      it "sends #{message} to the controller" do
        move_two_cells(controller)
        expect(controller).to receive(message)
        subject.run("#{op}@")
      end
    end
  end

  ['_', '|'].each do |op|
    describe "#run(\"#{op}@\")" do
      it "sends pop to the alu, and forwards the popped value to the controller" do
        move_two_cells(controller)
        expect(alu).to receive(:pop).and_return(:dummy)
        expect(controller).to receive(op).with(:dummy)
        subject.run("#{op}@")
      end
    end
  end

  describe "#run(\".@\")" do |op|
    it "sends pop to the alu and writes that value" do
      move_two_cells(controller)
      expect(alu).to receive(:pop).and_return(3)
      subject.run(".@")
      expect(subject.output).to eq "3"
    end
  end

  describe "#run(\",@\")" do |op|
    it "sends pop to the alu and writes the ASCII of that value" do
      move_two_cells(controller)
      expect(alu).to receive(:pop).and_return('a'.ord)
      subject.run(",@")
      expect(subject.output).to eq 'a'
    end
  end

  describe "#run(\"\\\"a@\")" do
    it "sets itself to string mode and pushes 'a'" do
      allow(controller).to receive(:position).and_return(
        Befunge::Vector.new(0, 0),
        Befunge::Vector.new(1, 0),
        Befunge::Vector.new(2, 0))
      allow(controller).to receive(:move!).twice
      expect(alu).to receive(:push).with('a'.ord)
      subject.run("\"a@")
    end
  end
end
