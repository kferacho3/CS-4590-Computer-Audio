import controlP5.*;
import beads.*;
import org.jaudiolibs.beads.*;

import controlP5.*;
import beads.*;
import org.jaudiolibs.beads.*;


ControlP5 p5;
Gain duckG;
Glide duckGGlide;
BiquadFilter filter;
Glide filterGlide;
Gain bgmG;
Glide bgmGG;
SamplePlayer bgm;
SamplePlayer voice1;
SamplePlayer voice2;



void setup() {
  size(320, 240);
  ac = new AudioContext();
  p5 = new ControlP5(this);
  
  bgm = getSamplePlayer("intermission_1.wav"); // source material
  voice1 = getSamplePlayer("vo1.wav");
  voice2 = getSamplePlayer("vo2.wav");

  duckGGlide = new Glide(ac, 1.0, 100);
  duckG = new Gain(ac, 1, duckGGlide);
  
  // triggers bgm to unduck at the end of voice clips
  Bead endListener = new Bead() {
    public void messageReceived(Bead msg) {
      SamplePlayer sp = (SamplePlayer) msg;
      sp.pause(true);
      sp.setToLoopStart();
      bgmGG.setValue(1.0);
      if (isTalking()) {
        filterGlide.setValue(400);
      } else {
        filterGlide.setValue(1.0);
      }
    }
  };
  
  voice1.setEndListener(endListener);
  voice2.setEndListener(endListener);
  
  bgm.setLoopType(SamplePlayer.LoopType.LOOP_FORWARDS);

  bgmGG = new Glide(ac, 1.0, 300);
  bgmG = new Gain(ac, 1, bgmGG);
  
  filter = new BiquadFilter(ac, BiquadFilter.Type.HP, filterGlide, 0.8); // frequency as a UGen and Q as a float
  filterGlide = new Glide(ac, 1.0, 800);
  
  voice1.setKillOnEnd(false);
  voice1.pause(true);
  
  voice2.setKillOnEnd(false);
  voice2.pause(true);
  
  filter.addInput(bgm);
  bgmG.addInput(filter);
  duckG.addInput(bgmG);
  duckG.addInput(voice1);
  duckG.addInput(voice2);
  ac.out.addInput(duckG);
  
  p5.addSlider("GainSlider")
    .setRange(10, 100)
    .setValue(50)
    .setPosition(80, 80)
    .setSize(50, 100)
    .setLabel("Master Gain");
   
  p5.addButton("Voice1")
    .setPosition(150, 75)
    .setSize(50, 50)
    .setLabel("Voice 1");
  
  p5.addButton("Voice2")
    .setPosition(150, 150)
    .setSize(50, 50)
    .setLabel("Voice 2");
    
  ac.start();
}


void draw() {
  background(0);
}
void play(SamplePlayer sp) {
  sp.setToLoopStart();
  sp.start();
}
void GainSlider(int val) {
  System.out.println("gain slider test");
  duckGGlide.setValue((int) val / 35);
}
boolean isTalking() {
  return !voice1.isPaused() || !voice2.isPaused();
}
void Voice1() {
  bgmGG.setValue(0.2);
  voice2.pause(true);
  play(voice1);
  filterGlide.setValue(400);
}
void Voice2() {
  bgmGG.setValue(0.2);
  voice1.pause(true);
  play(voice2);
  filterGlide.setValue(400);
}
