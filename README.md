# Synthesis of banjo like instrument using Karplus-Strong algorithm

## Getting started

Get the source code using the 'Clone or download' button or download and extract this [zip](https://github.com/andrew-rogers/OctaveBanjoSynth/archive/master.zip) file.

Download [BeverlyHillbillys.mid](https://freemidi.org/getter-701) into the source folder alongside synthmidi.m and run the following Octave commands:

```
>> fs=44100;
>> y=synthmidi('BeverlyHillbillys.mid',[1 2 4 5 6 7]);
>> soundsc(y,fs);
```

Notice that track three is not synthesised as the bass is a little over powering. You can try with it included if you like.

## Acknowledgements

Many thanks Ken Schutte for his [readmidi.m](https://github.com/kts/matlab-midi/blob/master/src/readmidi.m) that saved me hours of midi file parsing.

