import controlP5.*;
import beads.*;
import org.jaudiolibs.beads.*;

//declare global variables at the top of your sketch
//AudioContext ac; is declared in helper_functions
Reverb rev;
Gain g;
Glide gG;
ControlP5 p5;
SamplePlayer s;
//end global variables

//runs once when the Play button above is pressed
void setup() {
  size(320, 240); //size(width, height) must be the first line in setup()
  ac = new AudioContext(); //AudioContext ac; is declared in helper_functions 
  p5 = new ControlP5(this);
  s = getSamplePlayer("Nani.wav");
  rev = new Reverb(ac, 1);
  gG = new Glide(ac, 1.0, 50);
  g = new Gain(ac, 1, gG);
  rev.setLateReverbLevel(0);
  rev.addInput(s);
  s.setKillOnEnd(false);
  g.addInput(rev);
  ac.out.addInput(g);
  
  p5.addSlider("Gain Slider")
    
    .setValue(50)
    .setPosition(50, 50)
    .setSize(25, 100)
    .setRange(10, 100);
    
   p5.addSlider("Reverb Slider")
    
    .setValue(0)
    .setPosition(125, 50)
    .setSize(25, 100)
    .setRange(0, 100);
    
   p5.addSlider("Play Sound")
   
    .setPosition(210, 60)
    .setSize(75, 75);
    
    ac.start();
}


void draw() {
  background(0);  //fills the canvas with black (0) each frame
  
}
void Play() {
  s.reset();
}
void Reverb(int n) {
  //rev.pause(false);
  rev.setLateReverbLevel((int) n / 20);
}
void Gain(int n) {
  gG.setValue((int) n / 20);
}
