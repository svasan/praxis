# Internal iterator. Goes through each enumerable one at a time.
def sequence(*enumerables, &block)
  enumerables.each do |e|
    e.each(&block)
  end
end


# Goes through each in parallel but one at a time.
def interleave(*enumerables, &block)
  enumerators = enumerables.map { |e| e.to_enum }
  until enumerators.empty?
    begin
      e = enumerators.shift
      yield e.next
    rescue StopIteration
    else
      enumerators << e
    end
  end
end

# Goes through each in parallel all at the same time.
# Stops after the smallest is done.
def bundle(*enumerables, &block)
  enumerators = enumerables.map {|e| e.to_enum }
  loop { yield enumerators.map { |e| e.next } }
end

# Goes through each in parallel all at the same time
# Doesn't stop at the smallest but goes on till everything is done.
def bundle2(*enumerables, &block)
  enumerators = enumerables.map { |e| e.to_enum }
  until enumerators.empty?
    values = []
    done = []
    enumerators.map do |e|
      begin
        values << e.next
      rescue StopIteration
        done << e
      end
    end
    yield values if not values.empty?
    done.each do |e|
      enumerators.delete(e)
    end
  end
end

def test_hash
  fact = Hash.new { |h,k| h[k] = if k > 1 then k*h[k-1]  else 1 end }
  fact.each { |k,v| puts "#{k} => #{v}"}
  puts "#{fact[7]}"
  fact.each { |k,v| puts "#{k} => #{v}"}
end

def test_enumerators
  a,b,c  = [1,2,3], 4..7, 'a'..'e'
  puts "sequence: "
  sequence(a, b, c) { |x| print x }
  puts
  puts "interleave: "
  interleave(a,b,c) {|x| print x}
  puts
  puts "bundle: "
  bundle(a,b,c) { |x| print x}
  puts
  puts "bundle2: "
  bundle2(a,b,c) { |x| print x}
  puts
end

def test_arg
  ARGV.each_with_index do |arg, i|
    puts "#{i} : #{arg}"
  end
  ARGF.each do |l|
    puts l
  end
end

if __FILE__ == $0
  test_enumerators
  test_arg
  test_hash
end
