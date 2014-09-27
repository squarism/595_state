require 'redis'
require 'terminal-table'

redis_options = Hash["127.0.0.1", db: 1]
$redis = Redis.new(redis_options)


def get_state
  state = {}

  # this is VERY bad for performance on
  # bigger problems because it blocks redis
  # don't use keys ever, this is just a toy
  $redis.keys("pin_*").each do |key|
    state[key] = $redis.get(key)
  end

  state
end

# pin_4 becomes pin_04
def pad_key string
  pin_text, number = string.split("_")
  padded_number = number.rjust(2, "0")
  [ pin_text, padded_number ].join("_")
end

def transform_off_on state
  formatted_state = {}
  state.each do |k, v|
    if v == "0"
      value = "off"
    elsif v == "1"
      value = "on"
    else
      value = "unknown"
    end

    formatted_state[k] = value
  end

  formatted_state.sort
end

# turn 0/1 into off/on in state hash
def format_table state
  Terminal::Table.new( headings:['Pin', 'State'], rows:transform_off_on(state) )
end

# take a hash of binary states and figure out the decimal number
def compute_number state
  binary_string = state.sort.reverse.collect {|k,v| v }.join
  binary_string.to_i(2)
end

def pad_state state
  padded_state = {}
  state.each {|k,v| padded_state[pad_key(k)] = v }
  padded_state
end


begin
  while true do
    state = pad_state(get_state)
    table = format_table state
    puts table
    puts "The 595 is spitting out: #{compute_number state}"
    sleep 1
  end
rescue Interrupt
  puts "   Ok bro.  We're done here too."
end

