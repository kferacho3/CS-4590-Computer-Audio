import controlP5.*;
import beads.*;
import org.jaudiolibs.beads.*;


ControlP5 p5;

SamplePlayer p;
SamplePlayer rw;
SamplePlayer s;
SamplePlayer ff;
SamplePlayer rs;
SamplePlayer music;
// store the length, in ms, of the music SamplePlayer
double musicLen; 
UGen musicRG; 
// endListener to detect beginning/end of music playback, rewind, FF
Bead musicEndListener; 




//runs once when the Play button above is pressed
void setup() {
  size(320, 260); //size(width, height) must be the first line in setup()
  
  ac = new AudioContext(); //AudioContext ac; is declared in helper_functions 
  p5 = new ControlP5(this);
  
  p = getSamplePlayer("p.wav");
  rw = getSamplePlayer("rw.wav");
  s = getSamplePlayer("s.wav");
  ff = getSamplePlayer("ff.wav");
  rs = getSamplePlayer("rs.wav");

  music = getSamplePlayer("music.wav"); 
  musicRG = new Glide(ac, 0, 250); 
  music.setRate(musicRG); 
  musicLen = music.getSample().getLength(); 
  music.setToLoopStart();
  
  p.setKillOnEnd(false);
  rw.setKillOnEnd(false);
  s.setKillOnEnd(false);
  ff.setKillOnEnd(false);
  rs.setKillOnEnd(false);
  music.setKillOnEnd(false);
  
  p.pause(true);
  rw.pause(true);
  s.pause(true);
  ff.pause(true);
  rs.pause(true);
  music.pause(true);
  
  //create an endListener event handler to detect when the end or beginning of the music sample has been reached
  musicEndListener =  new Bead() {
    public void messageReceived(Bead message) {
      SamplePlayer sp = (SamplePlayer) message;
      sp.setEndListener(null);
      setPBR(0);
    }
  };
  
  p5.addButton("Play")
    .setPosition(120, 25)
    .setSize(80, 25);

  p5.addButton("Stop")
    .setPosition(120, 65)
    .setSize(80, 25);

  p5.addButton("FastForward")
    .setPosition(120, 105)
    .setSize(80, 25);
   
  p5.addButton("Rewind")
    .setPosition(120, 145)
    .setSize(80, 25);
 
  p5.addButton("Reset")
    .setPosition(120, 185)
    .setSize(80, 25);

  ac.out.addInput(music);
  ac.out.addInput(p);
  ac.out.addInput(rw);
  ac.out.addInput(s);
  ac.out.addInput(rs);
  ac.out.addInput(ff);
  ac.start();
}
public void addEL() {
  if (music.getEndListener() == null) {
    music.setEndListener(musicEndListener);
  }
}


public void setPBR(float rate) {
    if (music.getPosition() < 0) {
    music.reset();
  }
  if (music.getPosition() >= musicLen) {
    music.setToEnd();
  }
  musicRG.setValue(rate);
}


void Play() {
  p.start();
  p.setToLoopStart();
  if (music.getPosition() < musicLen) {
    setPBR(1);
    addEL();
    music.start();
  }
}

void Stop() {
  s.start();
  s.setToLoopStart();
  music.pause(true);
}

void FastForward() {
  ff.start();
  ff.setToLoopStart();
  if (music.getPosition() < musicLen) {
    setPBR(2);
    addEL();
    music.start();
  }
}

void Rewind() {
  rw.start();
  rw.setToLoopStart();
  if (music.getPosition() > 0) {
    setPBR(-1.5);
    addEL();
    music.start();
  }
}

void Reset() {
  rs.start();
  rs.setToLoopStart();
  music.pause(true);
  music.reset();
}




void draw() {
  background(0);  //fills the canvas with black (0) each frame
}
