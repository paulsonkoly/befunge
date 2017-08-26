require_relative '../spec_helper'
require_relative '../../lib/befunge/controller'

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

