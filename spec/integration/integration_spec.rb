require_relative '../spec_helper'
require_relative '../../befunge'

describe "integration" do
  subject { Befunge::Interpreter.new }

  it 'runs sesame street' do
    subject.run(">987v>.v\nv456<  :\n>321 ^ _@")
    expect(subject.output).to eq '123456789'
  end

  it 'runs the hello world' do
    subject.run(">25*\"!dlroW olleH\":v\n               v:,_@\n                >  ^")
    expect(subject.output).to be_empty
  end

  it 'runs quine' do
    quine = "01->1# +# :# 0# g# ,# :# 5# 8# *# 4# +# -# _@"
    subject.run(quine)
    expect(subject.output).to eq quine
  end
end
