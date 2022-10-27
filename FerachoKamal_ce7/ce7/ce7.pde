// FFT_01.pde
// This example is based in part on an example included with
// the Beads download originally written by Beads creator
// Ollie Bown. It draws the frequency information for a
// sound on screen.
import beads.*;

PowerSpectrum ps;
color fore = color(255, 255, 255);
color back = color(0,0,0);
void setup()
{

 size(600,600);

 ac = new AudioContext();

 // set up a master gain object
 Gain g = new Gain(ac, 2, 0.3);
 ac.out.addInput(g);

 // load up a sample included in code download
 SamplePlayer player = null;
 try
 {
 // Load up a new SamplePlayer using an included audio
 // file.
 
 player = getSamplePlayer("techno.wav",false);
 // connect the SamplePlayer to the master Gain
 g.addInput(player);
 }
 catch(Exception e)
 {
 // If there is an error, print the steps that got us to
 // that error.
 e.printStackTrace();
 }
 // In this block of code, we build an analysis chain
 // the ShortFrameSegmenter breaks the audio into short,
 // discrete chunks.
 ShortFrameSegmenter sfs = new ShortFrameSegmenter(ac);
 sfs.addInput(ac.out);

 // FFT stands for Fast Fourier Transform
 // all you really need to know about the FFT is that it
 // lets you see what frequencies are present in a sound
 // the waveform we usually look at when we see a sound
 // displayed graphically is time domain sound data
 // the FFT transforms that into frequency domain data
 FFT fft = new FFT();
 // connect the FFT object to the ShortFrameSegmenter
 sfs.addListener(fft);

 // the PowerSpectrum pulls the Amplitude information from
 // the FFT calculation (essentially)
 ps = new PowerSpectrum();
 // connect the PowerSpectrum to the FFT
 fft.addListener(ps);
 // list the frame segmenter as a dependent, so that the
 // AudioContext knows when to update it.
 ac.out.addDependent(sfs);
 // start processing audio
 ac.start();
}
// In the draw routine, we will interpret the FFT results and
// draw them on screen.

void draw()
{
 background(back);
 stroke(fore);

 // The getFeatures() function is a key part of the Beads
 // analysis library. It returns an array of floats
 // how this array of floats is defined (1 dimension, 2
 // dimensions ... etc) is based on the calling unit
 // generator. In this case, the PowerSpectrum returns an
 // array with the power of 256 spectral bands.
 float[] features = ps.getFeatures();

 // if any features are returned
 if(features != null)
 {
 // for each x coordinate in the Processing window
 for(int x = 0; x < width; x++)
 {
 // figure out which featureIndex corresponds to this x-
 // position
 int featureIndex = (x * features.length) / width;
 // calculate the bar height for this feature
 int barHeight = Math.min((int)(features[featureIndex] *
 height), height - 1);
 // draw a vertical line corresponding to the frequency
 // represented by this x-position
 line(x, height, x, height - barHeight);
 }
 }
}