require 'simplecov'

SimpleCov.start do |c|
  add_filter 'spec/'
end

require_relative '../befunge'
require 'rspec'

RSpec::describe Befunge do
  (0..9).each do |i|
    context "after pushing #{i}" do
      subject { Befunge.new("#{i}.") }

      it "outputs the pushed value" do
        expect(subject.step.step.output).to eq "#{i}"
      end
    end
  end

  describe Befunge::ALU do
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
    end
  end
end
