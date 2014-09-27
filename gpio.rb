# this runs on the raspberry pi to read the gpio pins

require 'pi_piper'
require 'redis'
include PiPiper

# you'll probably have to tell redis to listen on 0.0.0.0
redis_options = Hash[host: "REDIS_SERVER", db: 1]
$redis = Redis.new(redis_options)

# this was a PITA so we're only going to watch three pins
# off the 595 chip
@pins_watching = [ 4, 17, 22 ]
# @pins_watching = [ ]


def write_pin_state(pin, state)
  puts "PIN #{pin} GOING #{state}"
  $redis.set("pin_#{pin}", state)
end

def clear_states
  # sort of a transaction
  $redis.pipelined do
    @pins_watching.each do |pin|
      $redis.set("pin_#{pin}", "0")
    end
  end
end

@pins_watching.each do |pin_number|
  watch pin:pin_number do
    write_pin_state(pin_number, "#{value}")
  end
end

puts "Starting."
begin
  clear_states
  PiPiper.wait
rescue Interrupt
  @pins_watching.each do |pin|
    `echo #{pin} >/sys/class/gpio/unexport`
  end
  puts "   Ok bro.  We're done here."
  puts "NO CARRIER"
end
