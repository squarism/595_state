#!/bin/bash

# if this doesn't work and you get "Device or resource busy"
# unplug everything from gpio and reboot
# also check your grounding.

# customize to the gpio pins you have wired.
echo 4 > /sys/class/gpio/unexport
echo 17 > /sys/class/gpio/unexport
echo 21 > /sys/class/gpio/unexport

echo "Done clearing gpio pins."
