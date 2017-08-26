require_relative '../spec_helper'
require_relative '../../befunge'

describe "integration" do
  subject { Befunge::Interpreter.new(">987v>.v\nv456<  :\n>321 ^ _@") }

  it 'return the correct result' do
    subject.run
    expect(subject.output).to eq '123456789'
  end
end
