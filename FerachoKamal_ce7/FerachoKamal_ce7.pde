// FFT_01.pde
// This example is based in part on an example included with
// the Beads download originally written by Beads creator
// Ollie Bown. It draws the frequency information for a
// sound on screen.
import beads.*;
import controlP5.*;
import processing.sound.AudioIn;
import processing.sound.Amplitude;


private static final int BIQUAD_MIN = 100;
private static final int BIQUAD_MAX = 800;

PowerSpectrum ps;
ControlP5 p5;



RadioButton filterMode;
RadioButton micButton;
RadioButton reverbButton;
Slider reverbSlider;
Slider cof;
AudioIn input;
Amplitude analyzer;
int currFM = 0;

//UGen micInput;
boolean micOn = false;
boolean revOn = false;
int currentFilter = 0;
float cofVAL;
color fore = color(255, 255, 255);
color back = color(0,0,0);

Glide lpfGlide;
BiquadFilter lpf;
Glide hpfGlide;
BiquadFilter hpf;
Glide bpfGlide;
BiquadFilter bpf;
Reverb rev;

void setup() {

  size(600,600);
  input = new AudioIn(this, 0);
  analyzer = new Amplitude(this);
  ac = new AudioContext();
  p5 = new ControlP5(this);
  input = new AudioIn(this, 0);
  
  filterMode = p5.addRadioButton("FilterMode")
    .setPosition(50, 50)
    .setSize(45, 20)
    .setColorActive(color(160))
    .setSpacingColumn(75)
    .setItemsPerRow(8)
    .setSpacingRow(18)
    .addItem("No Filter", 0)
    .addItem("Low Pass Filter", 1)
    .addItem("High Pass Filter", 2)
    .addItem("Band Pass Filter", 3);
    
  filterMode.activate(0);
  
  micButton = p5.addRadioButton("Mic")
    .setPosition(50, 100)
    .setSize(40, 20)
    .setColorForeground(color(120))
    .setColorActive(color(160))
    .setColorLabel(color(80))
    .addItem("Use Mic", 0);

  reverbButton = p5.addRadioButton("Reverb")
    .setSize(40, 20)
    .setColorForeground(color(120))
    .setColorActive(color(160))
    .setColorLabel(color(80))
    .setPosition(50, 125)
    .addItem("Use REverb", 0);

  reverbSlider = p5.addSlider("reverbSlider")
    .setPosition(300, 125)
    .setSize(150, 20)
    .lock()
    .setLabel("ReverbSlider Slider");
    
  cof = p5.addSlider("cof")
    .setPosition(300, 100)
    .setSize(150, 20)
    .setRange(BIQUAD_MIN, BIQUAD_MAX)
    .lock()
    .setLabel("Cut Off Frequency");
  
  // set up a master gain object
  Gain g = new Gain(ac, 2, 0.3);
  ac.out.addInput(g);
  
 //low, high, and band pass filter set up
  lpfGlide = new Glide(ac, BIQUAD_MIN);
  lpf = new BiquadFilter(ac, BiquadFilter.Type.LP, lpfGlide, 0.75);
  hpfGlide = new Glide(ac, BIQUAD_MIN);
  hpf = new BiquadFilter(ac, BiquadFilter.Type.HP, hpfGlide, 0.75);
  bpfGlide = new Glide(ac, BIQUAD_MIN);
  bpf = new BiquadFilter(ac, BiquadFilter.Type.BP_SKIRT, bpfGlide, 0.75);
  
  // load up a sample included in code download
  SamplePlayer player = null;
  
  try {
    player = getSamplePlayer("calmHYPE.wav", false);
     
    g.addInput(player); // connect the SamplePlayer to the master Gain
  } catch(Exception e) { 
    e.printStackTrace();
  }
  
  lpf.addInput(player);
  hpf.addInput(player);
  bpf.addInput(player);
  
  //micInput = ac.getAudioInput();

  
  rev = new Reverb(ac);
  rev.setSize(0);
  rev.addInput(player);
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



  
void FilterMode(int a) {
  if (a != 0) {
    cof.unlock();
  } else {
    cof.lock();
  }
  if (a == 0) {
    filterMode.activate(0);
  } else if (a == 1) {
    filterMode.activate(1);
    lpfGlide.setValue(BIQUAD_MIN);
  } else if (a == 2) {
    filterMode.activate(2);
    hpfGlide.setValue(BIQUAD_MIN);
  } else if (a == 3) {
    filterMode.activate(3);
  }
}

// In the draw routine, we will interpret the FFT results and
// draw them on screen.

void Mic(int i) {
  if (i == 0) {
    micOn = true;
    input.play();
    analyzer.input(input);
  } else {
    micOn = false;
  }
}

void Reverb(int i ) {
  if (i == 0) {
    revOn = true;
  } else {
    revOn = false;
  }

  if (revOn) {
    reverbSlider.unlock();
  } else {
    reverbSlider.lock();
    reverbSlider.setValue(0);
  }
}
void filterMode(int i) {
  if (i != -1) {
    cof.unlock();
  }

  if (i == 0 || i == -1) {
    i = 0;
    cof.setValue(BIQUAD_MIN);
    cof.lock();
    filterMode.activate(0);
  }
  currFM = i;
}
  
  void reverbSlider(float i) {
  if (rev == null) return; // edge case on setup
  rev.setSize(i / 100);
}
void cof(float i) {
  cofVAL = i;
  
}
void draw() {
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
  if(features != null) {
  // for each x coordinate in the Processing window
    for (int x = 0; x < width; x++) {
       // figure out which featureIndex corresponds to this x-
       // position
       int featureIndex = (x * features.length) / width;
       
       // calculate the bar height for this feature
       int barHeight = Math.min((int)(features[featureIndex] * height), height - 1);
       
       // draw a vertical line corresponding to the frequency
       // represented by this x-position
       line(x, height, x, height - barHeight);
    }
  }
    //fill(127);
  //stroke(0);
  //float vol = analyzer.analyze();
  // Draw an ellipse with size based on volume
 // ellipse(width/2, height/2, 10*50, 10*50);
}
