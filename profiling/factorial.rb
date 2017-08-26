#!/usr/bin/ruby

require_relative '../befunge.rb'
require 'ruby-prof'

result = RubyProf.profile do
  b = Befunge::Interpreter.new
  b.run("08>:1-:v v *_$.@ \n  ^    _$>\\:^  ^    _$>\\:^")
end

# print a graph profile to text
printer = RubyProf::GraphPrinter.new(result)
printer.print(STDOUT, {})
