require_relative '../spec_helper'
require_relative '../../lib/befunge/memory.rb'

describe Befunge::Memory do
  describe '#write' do
    it 'appends to the output' do
      subject.write('x')
      expect(subject.output).to eq 'x'
    end
  end

  describe '#[]=' do
    it 'changes the program' do
      subject.program = 'a'
      v = Befunge::Vector.new(0,0)
      expect { subject[v] = 'b' }.to change { subject[v] }.from('a').to('b')
    end
  end
end

