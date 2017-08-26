require 'simplecov'

SimpleCov.start do |c|
  add_filter 'spec/'
end

require_relative '../befunge'
require 'rspec'

RSpec::describe Befunge do
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
            expect(subject.pop).to eq 3.send(operator, 2)
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

  describe Befunge::Controller do
    describe 'move' do
      context 'after setting direction to right' do
        before :each { subject.direction = :> }

        it 'moves to the right' do
          expect { subject.move! }.to change(subject, :x).by(1)
          expect { subject.move! }.not_to change(subject, :y)
        end
      end

      context 'after setting direction to left' do
        before :each { subject.direction = :< }

        it 'moves to the left' do
          expect { subject.move! }.to change(subject, :x).by(-1)
          expect { subject.move! }.not_to change(subject, :y)
        end
      end

      context 'after setting direction to down' do
        before :each { subject.direction = :v }

        it 'moves down' do
          expect { subject.move! }.not_to change(subject, :x)
          expect { subject.move! }.to change(subject, :y).by(1)
        end
      end

      context 'after setting direction to up' do
        before :each { subject.direction = :^ }

        it 'moves up' do
          expect { subject.move! }.not_to change(subject, :x)
          expect { subject.move! }.to change(subject, :y).by(-1)
        end
      end

      context 'after setting direction to random' do
        before :each { subject._? }

        it 'moves' do
          expect { subject.move! }.to change { subject }
        end
      end
    end
  end

  describe "integration" do
    subject { Befunge.new(">987v>.v\nv456<  :\n>321 ^ _@") }

    it 'return the correct result' do
      subject.run
      expect(subject.output).to eq '123456789'
    end
  end
end
