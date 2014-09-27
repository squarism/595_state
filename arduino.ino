//**************************************************************//
// Shift state into a 595 and then read out the state into
// pins on a Raspberry Pi (rpi).  This will flash 3 LEDs randomly
// although it can easily expand to 8 LEDs.  You would need
// many input pins set up on the rpi.
// -- @squarism
//****************************************************************

//Pin connected to ST_CP of 74HC595
int latchPin = 8;

//Pin connected to SH_CP of 74HC595
int clockPin = 12;

////Pin connected to DS of 74HC595
int dataPin = 11;

int inputPin = A0;


void setup() {
  //set pins to output so you can control the shift register
  pinMode(latchPin, OUTPUT);
  pinMode(clockPin, OUTPUT);
  pinMode(dataPin, OUTPUT);

  // the onboard led is going to light up right before it changes
  // if you don't set it as an output, it looks very dim
  pinMode(13, OUTPUT);

  // if pin 0 is disconnected, analog noise will make a good seed
  randomSeed(analogRead(0));

  // open up serial for debugging
  Serial.begin(9600);
}

void loop() {

  digitalWrite(latchPin, LOW);

  int temp = 1;
  int numberToDisplay = random(7);

  // shift out the bits:
  shiftOut(dataPin, clockPin, MSBFIRST, numberToDisplay);

  //take the latch pin high so the LEDs will light up:
  digitalWrite(latchPin, HIGH);

  // pause before next value but give us a status light
  digitalWrite(13, LOW);
  delay(4500);
  digitalWrite(13, HIGH);
  delay(500);

}
