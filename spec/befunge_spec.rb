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

  describe '#_+' do
    context "after pushing two operands" do
      before :each { subject._2._3 }

      it "pushes the sum" do
        subject.plus
        expect(subject.write.output).to eq '5'
      end
    end
  end
end
