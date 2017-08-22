require_relative '../befunge'
require 'rspec'

RSpec::describe Befunge do
  it { is_expected.to be_a Befunge }

  (0..9).each do |i|
    it { is_expected.to respond_to :"_#{i}" }
  end

  it { is_expected.to respond_to :write }

  (0..9).each do |i|
    context "after pushing #{i}" do
      before :each { subject.send "_#{i}" }

      it "outputs the pushed value" do
        expect(subject.write.output).to eq "#{i}"
      end
    end
  end

  [:+, :-, :*, :/, :%].each do |operator|
    describe "#_#{operator}" do
      context "after pushing two operands" do
        before :each { subject._2._3 }

        it "pushes #{2.send(operator, 3)}" do
          subject.send("_#{operator}")
          expect(subject.write.output).to eq (3.send(operator, 2)).to_s
        end
      end
    end
  end

  describe "#!" do
    context "after pushing 1" do
      before :each { subject._1 }

      it "pushes 0" do
        subject.!
        expect(subject.write.output).to eq '0'
      end
    end
  end
end
