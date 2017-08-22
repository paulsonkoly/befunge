class Befunge
  (0..9).each do |i|
    define_method("_#{i}") { push(i) }
  end

  private

  def push(elem)
    @stack << elem
  end
end
