595 Timer Chip State
--------------------

This is a toy app where a 595 chip on an arduino
pushes its state (random number) to a bunch of
LEDs.  A raspberry pi reads the state (voltages)
and sends the state as key/value pairs to redis.

This was a learning project on grok'ing how a 595 works.
You can read more at [BLOG LINK].

![monitor picture](!/state_table.png?raw=true)

