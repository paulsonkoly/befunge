require_relative '../befunge'
require 'rspec'

RSpec::describe Befunge do
  it { is_expected.to be_a Befunge }

  (0..9).each do |i|
    it { is_expected.to respond_to :"_#{i}" }
  end
end
