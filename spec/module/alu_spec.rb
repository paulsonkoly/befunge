require_relative '../spec_helper'
require_relative '../../lib/befunge/alu.rb'

describe Befunge::ALU do
  (0..9).each do |i|
    describe "_#{i}" do
      it "pushes the value #{i}" do
        subject.send("_#{i}")
        expect(subject.pop).to eq i
      end
    end
  end

  [:+, :-, :*, :/, :%].each do |operator|
    describe "##{operator}" do
      context "after pushing 2 and 3" do
        before :each { subject._2._3 }

        it "pushes #{2.send(operator, 3)}" do
          subject.send(operator)
          expect(subject.pop).to eq 2.send(operator, 3)
        end
      end
    end
  end

  describe "#!" do
    context "after pushing 1" do
      before :each { subject._1 }

      it "pushes 0" do
        subject.!
        expect(subject.pop).to eq 0
      end
    end
  end

  context "after pushing 0" do
    before :each { subject._0 }

    it "pushes 0" do
      subject.!
      expect(subject.pop).to eq 1
    end
  end

  describe "#compare" do
    context "after pushing 1 and 2" do
      before :each { subject._1._2 }

      it "pushes 1" do
        subject.compare
        expect(subject.pop).to eq 1
      end
    end
  end

  describe '#dupl' do
    context 'if the stack is empty' do
      it 'pushes two zeros' do
        subject.dupl
        expect(subject.pop).to eq 0
        expect(subject.pop).to eq 0
      end
    end

    context 'if the stack contains 13' do
      before :each { subject.push 13 }

      it 'pushes two 13s' do
        subject.dupl
        expect(subject.pop).to eq 13
        expect(subject.pop).to eq 13
      end
    end
  end

  describe '#swap' do
    context 'if the stack has only one elem' do
      before :each { subject.push 13 }

      it 'pushes a zero' do
        subject.swap
        expect(subject.pop).to eq 0
        expect(subject.pop).to eq 13
      end
    end

    context 'if the stack contains 13, 14' do
      before :each do
        subject.push 13
        subject.push 29
      end

      it 'swaps the order' do
        subject.swap
        expect(subject.pop).to eq 13
        expect(subject.pop).to eq 29
      end
    end
  end
end

