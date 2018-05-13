class KVStore
  def initialize
    @hash = Hash.new()
  end

  def get(key)
    get2(key, Time.now)
  end

  def put(key, value)
    put2(key, value, Time.now)
  end

  def remove(key)
    remove2(key, Time.now)
  end


  def remove2(key, t)
    # If the key and time matches, delete it
    # Otherwise insert a nil entry for that key and time
    put2(key, nil, t)
  end

  def put2(key, value, time)
    if @hash.include?(key)
      found = @hash[key].find { |n| n.time == time}
      if not found.nil?
        found.value = value
        return
      end

      @hash[key] << Value.new(time, value)
      @hash[key].sort!
      return
    end

    # Key doesn't exist in the hash
    @hash[key] = []
    @hash[key] << Value.new(time, value)
  end

  # time < earliest time  => nil
  # time > latest_time => latest value
  def get2(key, time)
    return nil if not @hash.include?(key) or @hash[key].empty?

    found = @hash[key].find_index { |n| n.time >= time }

    return @hash[key][-1].value if found.nil?
    return @hash[key][found].value if @hash[key][found].time == time

    # No equal time => found time is greater so we want the one before.
    return nil if found == 0
    return @hash[key][found-1].value
  end

  def to_s
    @hash.to_s
  end

  private

  class Value
    attr_accessor :time, :value

    def initialize(t, v)
      @time = t
      @value = v
    end

    def <=>(other)
      @time <=> other.time
    end

    def to_s
      "{time: #{@time}, value: #{@value}}"
    end
  end
end

h  = KVStore.new()
#puts "Intial: #{h.get(:test)}"

#h.put(:test, "value")
#puts "Put: #{h.get(:test)}"

#h.remove(:test)
#puts "Remove: #{h.get(:test)}"


h.put2('foo', 1, 100)
h.put2('foo', 2, 200)

puts "get2(0): #{h.get2('foo', 0)}" # => nil
puts "get2(100): #{h.get2('foo', 100)}" # => 1

puts "150: #{h.get2('foo', 150)}" # => 1

puts "200: #{h.get2('foo', 200)}" # => 2
puts "201: #{h.get2('foo', 201)}" # => 2
# 202 => 2
h.remove2('foo', 202)
puts "100: #{h.get2('foo', 100)}" # => 1
puts "201: #{h.get2('foo', 201)}" # => 2
puts "202: #{h.get2('foo', 202)}" # => nil
#h.get_at_time('foo', 300) # => nil
