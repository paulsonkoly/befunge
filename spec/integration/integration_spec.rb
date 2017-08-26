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

  it 'runs erastothenes' do
    sieve = "2>:3g\" \"-!v\\  g30          <\n"  <<
            " |!`\"&\":+1_:.:03p>03g+:\"&\"`|\n" <<
            " @               ^  p3\\\" \":<\n"  <<
            "2 2345678901234567890123456789012345678"
    subject.run(sieve)
    expect(subject.output).to eq "23571113171923293137"
  end
end
