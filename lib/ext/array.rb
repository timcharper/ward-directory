class Array
  def each_with_index(&block)
    0.upto(length - 1) do |i|
      yield self[i], i
    end
  end
end