import beads.*;
import org.jaudiolibs.beads.*;
import java.util.*;
import controlP5.*;
import processing.sound.*;

ControlP5 cp5;
// radioButton
int myColorBackground = color(0,0,0);
int myColorBoxes = color(0,0,0);
RadioButton r1, r2;
// knob
int knobValue = 100;
Knob myKnobA;
Knob myKnobB;
// textlabel
Textlabel myTextlabelA;
Textlabel myTextlabelB;
Textlabel myTextlabel2ndBox;
Textlabel myTextlabelType;
Textlabel myTextlabelTimestamp;
Textlabel myTextlabelLocation;
Textlabel myTextlabelTag;
Textlabel myTextlabelFlag;
Textlabel myTextlabelPriority;
Textlabel myTextlabelNote;
// Sound
SoundFile balanced;
SoundFile counter;
SoundFile pressure;
SoundFile trap;
SoundFile defensive;
SoundFile offensive;
// JSONArray
String[] jsonArray;
JSONArray values;
int jsonIndex = 0;
String[] flag;
String[] location;
String[] tag;
String[] type;
String[] priority;
String[] timestamp;
String[] note;


//to use text to speech functionality, copy text_to_speech.pde from this sketch to yours
//example usage below

//IMPORTANT (notice from text_to_speech.pde):
//to use this you must import 'ttslib' into Processing, as this code uses the included FreeTTS library
//e.g. from the Menu Bar select Sketch -> Import Library... -> ttslib

TextToSpeechMaker ttsMaker; 

//<import statements here>

//to use this, copy notification.pde, notification_listener.pde and notification_server.pde from this sketch to yours.
//Example usage below.

//name of a file to load from the data directory
String eventDataJSON1 = "friendlygame1_tactics.json";
String eventDataJSON2 = "friendlygame2.json";
String eventDataJSON3 = "friendlygame3.json";
String eventDataJSON4 = "custom.json";
//String eventDataJSON2 = "smarthome2020_midday.json";
//String eventDataJSON3 = "smarthome2020_evening.json";

NotificationServer server;
ArrayList<Notification> notifications;

Example example;
ControlTimer c;
//Comparator<Notification> comparator;
//PriorityQueue<Notification> queue;
PriorityQueue<Notification> q2;

void setup() {
  size(1200,600);
  c = new ControlTimer();
  c.setSpeedOfTime(1);
  jsonArray = new String[7];
  
  flag = new String[77];
  location = new String[77];
  tag = new String[77];
  type = new String[77];
  priority = new String[77];
  timestamp = new String[77];
  note = new String[77];
  
  // load sound
  balanced = new SoundFile(this, "balanced.wav");
  counter = new SoundFile(this, "counter.wav");
  pressure = new SoundFile(this, "pressure.wav");
  trap = new SoundFile(this, "trap.wav");
  defensive = new SoundFile(this, "defensive.wav");
  offensive = new SoundFile(this, "offensive.wav");
  
  NotificationComparator priorityComp = new NotificationComparator();
  
  q2 = new PriorityQueue<Notification>(10, priorityComp);
  
  //comparator = new NotificationComparator();
  //queue = new PriorityQueue<Notification>(10, comparator);
  
  ac = new AudioContext(); //ac is defined in helper_functions.pde
  ac.start();
  
  //this will create WAV files in your data directory from input speech 
  //which you will then need to hook up to SamplePlayer Beads
  ttsMaker = new TextToSpeechMaker();
  
  String exampleSpeech = "Welcome to Soccer Training Simulator, Choose game or toggle custom.";
  
  ttsExamplePlayback(exampleSpeech); //see ttsExamplePlayback below for usage
  
  //START NotificationServer setup
  server = new NotificationServer();
  
  //instantiating a custom class (seen below) and registering it as a listener to the server
  example = new Example();
  server.addListener(example);
  
  
  
  //END NotificationServer setup
  
  // UI Setup Start
  cp5 = new ControlP5(this);
  
  
  // radioButton
  cp5 = new ControlP5(this);
  r1 = cp5.addRadioButton("radioButton")
   .setPosition(100,150)
   .setSize(50,20)
   .setColorForeground(color(120))
   .setColorActive(color(255))
   .setColorLabel(color(255))
   .setItemsPerRow(1)
   .setSpacingColumn(50)
   .addItem("PauseAll",0)
   .addItem("Game1",1)
   .addItem("Game2",2)
   .addItem("Game3",3)
   .addItem("Custom",4)
   ;
     
   for(Toggle t:r1.getItems()) {
     t.getCaptionLabel().setColorBackground(color(255,80));
     t.getCaptionLabel().getStyle().moveMargin(-7,0,0,-3);
     t.getCaptionLabel().getStyle().movePadding(7,0,0,3);
     t.getCaptionLabel().getStyle().backgroundWidth = 45;
     t.getCaptionLabel().getStyle().backgroundHeight = 13;
   }
  
  // knob
 // cp5 = new ControlP5(this);
 // smooth();
 // noStroke(); 
 // myKnobA = cp5.addKnob("knob")
 //  .setRange(0,255)
 //  .setValue(50)
 //  .setPosition(100,70)
 //  .setRadius(50)
 //  .setDragDirection(Knob.VERTICAL)
 // ;
                     
 // myKnobB = cp5.addKnob("knobValue")
 //  .setRange(0,255)
 //  .setValue(220)
 //  .setPosition(100,210)
 //  .setRadius(50)
 //  .setNumberOfTickMarks(10)
 //  .setTickMarkLength(4)
 //  .snapToTickMarks(true)
 //  .setColorForeground(color(255))
 //  .setColorBackground(color(0, 160, 100))
 //  .setColorActive(color(255,255,0))
 //  .setDragDirection(Knob.HORIZONTAL)
 //;
 
 // icon
 //cp5 = new ControlP5(this);
 //cp5.addIcon("icon",10)
 //    .setPosition(100,10)
 //    .setSize(70,50)
 //    .setRoundedCorners(20)
 //    .setFont(createFont("fontawesome-webfont.ttf", 40))
 //    .setFontIcons(#00f205,#00f204)
 //    //.setScale(0.9,1)
 //    .setSwitch(true)
 //    .setColorBackground(color(255,100))
 //    .hideBackground()
 //    ;
     
  // textlabel
  cp5 = new ControlP5(this);
  
  myTextlabelA = cp5.addTextlabel("label")
                    .setText("Select your game")
                    .setPosition(75,50)
                    .setColorValue(0xffffff00)
                    .setFont(createFont("Georgia",20))
                    ;
                    
  myTextlabelB = new Textlabel(cp5,
  "Try preselected games or simulate your own!",50,125,400,200);
  
  myTextlabel2ndBox = cp5.addTextlabel("label2")
                    .setText("Custom User Input")
                    .setPosition(310,50)
                    .setColorValue(0xffffff00)
                    .setFont(createFont("Georgia",20))
                    ;
  
     
  
  
  // scrollableList
  cp5 = new ControlP5(this);
  List type = Arrays.asList("Balanced", "Defensive", "Offensive", "Counter", "Pressure", "Trap");
  List location = Arrays.asList("A", "B", "C", "D", "E");
  List flag = Arrays.asList("on", "off");
  List priority = Arrays.asList("1","2","3");
  
  // Textlabels
  myTextlabelType = new Textlabel(cp5,
  "Tactic Type: ",310,110,400,200);
  myTextlabelTimestamp = new Textlabel(cp5,
  "Timestamp: ",310,160,400,200);
  myTextlabelLocation = new Textlabel(cp5,
  "Location: ",310,210,400,200);
  myTextlabelTag = new Textlabel(cp5,
  "Tag: ",310,260,400,200);
  myTextlabelFlag = new Textlabel(cp5,
  "Flag: ",310,310,400,200);
  myTextlabelPriority = new Textlabel(cp5,
  "Priority: ",310,360,400,200);
  myTextlabelNote = new Textlabel(cp5,
  "Note: ",310,410,400,200);
  
  // ScrollableList
  cp5.addScrollableList("selectType")
     .setPosition(385, 105)
     .setSize(100, 100)
     .setBarHeight(20)
     .setItemHeight(20)
     .addItems(type)
     .close()
     ;
  cp5.addTextfield("selectTimestamp")
     .setPosition(385, 155)
     .setAutoClear(true)
     .setSize(100,20)
     ;
  cp5.addTextfield("selectLocation")
     .setPosition(385, 205)
     .setAutoClear(true)
     .setSize(100,20)

     ;
  cp5.addTextfield("selectTag")
     .setPosition(385, 255)
     .setAutoClear(true)
     .setSize(100,20)
     ;
  cp5.addTextfield("selectFlag")
     .setPosition(385, 305)
     .setAutoClear(true)
     .setSize(100,20)
     ;
  cp5.addTextfield("selectPriority")
     .setPosition(385, 355)
     .setAutoClear(true)
     .setSize(100,20)
     ;
  cp5.addTextfield("selectNotes")
     .setPosition(385, 405)
     .setAutoClear(true)
     .setSize(100,20)
     ;
     
  cp5.addButton("pushTheseInputs")
     .setPosition(310,480)
     .setSize(180,19)
     ;
     
  cp5.addButton("makeJsonFile")
     .setPosition(310,520)
     .setSize(180,19)
     ;
  
  // https://processing.org/reference/JSONArray.html
  //JSONObject animal = new JSONObject();

    //animal.setInt("id", selectType);
    //animal.setString("species", species[i]);
    //animal.setString("name", names[i]);
   
}

void draw() {
  // knob
  background(myColorBackground); // black background
  //fill(0,100);
  fill(100); // grey
  // rect(x,y,width,height,corner radius)
  int boxwidth = 200;
  int boxlength = 400;
  int boxradius = 10;
  rect(50,40,boxwidth,boxlength,boxradius);
  rect(300,40,boxwidth,boxlength,boxradius);
  rect(550,40,boxwidth,boxlength,boxradius);
  rect(800,40,boxwidth,boxlength,boxradius);

  //rect(150,90,190,370);
  //rect(500,height/2,width,height/2);
  //fill(0,100);
  
  // textlabel
  myTextlabelB.draw(this); 
  myTextlabelType.draw(this); 
  myTextlabelTimestamp.draw(this);
  myTextlabelLocation.draw(this);
  myTextlabelTag.draw(this);
  myTextlabelFlag.draw(this);
  myTextlabelPriority.draw(this);
  myTextlabelNote.draw(this);  
}

void radioButton(int a) {

  if (a == 0) {
    server.stopEventStream(); //always call this before loading a new stream
    println("Stopped all event streams");
  }
  if (a == 1) {
    println("Game", + a, "json data loaded");
    server.stopEventStream(); //always call this before loading a new stream
    server.loadEventStream(eventDataJSON1);
    //println("**** New event stream loaded: " + eventDataJSON1 + " ****");
  }
  if (a == 2) {
    println("Game", + a, "json data loaded");
    server.stopEventStream(); //always call this before loading a new stream
    server.loadEventStream(eventDataJSON2);
    //println("**** New event stream loaded: " + eventDataJSON1 + " ****");
  }
  if (a == 3) {
    println("Game", + a, "json data loaded");
    server.stopEventStream(); //always call this before loading a new stream
    server.loadEventStream(eventDataJSON3);
    //println("**** New event stream loaded: " + eventDataJSON1 + " ****");
  }
  if (a == 4) {
    server.stopEventStream();
    server.loadEventStream(eventDataJSON4);
    println("Try it your own!");
  }
  
  
}
// textfield
void controlEvent(ControlEvent theEvent) {
  if(theEvent.isAssignableFrom(Textfield.class)) {
    if (theEvent.getName() == "selectTimestamp") {
      timestamp[jsonIndex] = theEvent.getStringValue();
      println("this is my json 1", timestamp[jsonIndex]);
    }
    if (theEvent.getName() == "selectLocation") {
      location[jsonIndex] = theEvent.getStringValue();
      println("this is my json 1", timestamp[jsonIndex]);
    }
    if (theEvent.getName() == "selectTag") {
      tag[jsonIndex] = theEvent.getStringValue();
      println("this is my json 3", tag[jsonIndex]);
    }
    if (theEvent.getName() == "selectFlag") {
      flag[jsonIndex] = theEvent.getStringValue();
      println("this is my json 4", flag[jsonIndex]);
    }
    if (theEvent.getName() == "selectPriority") {
      priority[jsonIndex] = theEvent.getStringValue();
      println("this is my json 5", priority[jsonIndex]);
    }
    if (theEvent.getName() == "selectNote") {
      note[jsonIndex] = theEvent.getStringValue();
      println("this is my json 6", note[jsonIndex]);
    }
    
    println("controlEvent: accessing a string from controller '"
            +theEvent.getName()+"': "
            +theEvent.getStringValue()
            );
  }
}

void knob(int theValue) { // upper knob
  //myColorBackground = color(theValue);
  //println("a knob event. setting background to "+theValue);
}

void icon(boolean theValue) {
  println("got an event for icon", theValue);
} 

void selectType(int n) {
  /* request the selected item based on index n */
  println(cp5.get(ScrollableList.class, "selectType").getItem(n).get("text").toString());
  type[jsonIndex] = cp5.get(ScrollableList.class, "selectType").getItem(n).get("text").toString();
  //println("this my json", jsonArray);
}

void pushTheseInputs() {
  // save to json
  //values = new JSONArray();
 

  //JSONObject animal = new JSONObject();

  //animal.setString("type", type[jsonIndex]);
  //animal.setString("timestamp", timestamp[jsonIndex]);
  //animal.setString("location", location[jsonIndex]);
  //animal.setString("tag", tag[jsonIndex]);
  //animal.setString("flag", flag[jsonIndex]);
  //animal.setString("priority", priority[jsonIndex]);
  //animal.setString("note", note[jsonIndex]);

  //values.setJSONObject(jsonIndex, animal);
  jsonIndex++;
  
}

void makeJsonFile() {
  // save to json
  values = new JSONArray();
  for (int i = 0; i < jsonIndex; i++) {

    JSONObject animal = new JSONObject();

    animal.setString("type", type[jsonIndex]);
    animal.setInt("timestamp", Integer.valueOf(timestamp[jsonIndex]));
    animal.setString("location", location[jsonIndex]);
    animal.setString("tag", tag[jsonIndex]);
    animal.setString("flag", flag[jsonIndex]);
    animal.setString("priority", priority[jsonIndex]);
    animal.setString("note", note[jsonIndex]);

    values.setJSONObject(i, animal);
  }
  saveJSONArray(values, "data/custom.json");
}

void keyPressed() {
  //example of stopping the current event stream and loading the second one
  
    
}

//in your own custom class, you will implement the NotificationListener interface 
//(with the notificationReceived() method) to receive Notification events as they come in
class Example implements NotificationListener {
  
  public Example() {
    //setup here
  }
  
  //this method must be implemented to receive notifications
  public void notificationReceived(Notification notification) { 
    //println("<Example> " + notification.getType().toString() + " notification received at " 
    //+ Integer.toString(notification.getTimestamp()) + " ms");
    
    String debugOutput = ">>> ";
    switch (notification.getType()) {
      case Defensive:
        defensive.play();
        debugOutput += "Door moved: ";
        break;
      case Offensive:
        offensive.play();
        debugOutput += "Person moved at home: ";
        break;
      case Counter:
        counter.play();
        debugOutput += "Person moved at work: ";
        break;
      case Balanced:
        balanced.play();
        debugOutput += "Co-worker changed their free/busy status: ";
        break;
      case Pressure:
        pressure.play();
        debugOutput += "Meeting time: ";
        break;
      case Trap:
        trap.play();
        debugOutput += "Object moved: ";
        break;
    }
    debugOutput += notification.toString();
    //debugOutput += notification.getLocation() + ", " + notification.getTag();
    
    //println(debugOutput);
    
   //You can experiment with the timing by altering the timestamp values (in ms) in the exampleData.json file
    //(located in the data directory)
  }
}

void ttsExamplePlayback(String inputSpeech) {
  //create TTS file and play it back immediately
  //the SamplePlayer will remove itself when it is finished in this case
  
  String ttsFilePath = ttsMaker.createTTSWavFile(inputSpeech);
  println("File created at " + ttsFilePath);
  
  //createTTSWavFile makes a new WAV file of name ttsX.wav, where X is a unique integer
  //it returns the path relative to the sketch's data directory to the wav file
  
  //see helper_functions.pde for actual loading of the WAV file into a SamplePlayer
  
  SamplePlayer sp = getSamplePlayer(ttsFilePath, true); 
  //true means it will delete itself when it is finished playing
  //you may or may not want this behavior!
  
  ac.out.addInput(sp);
  sp.setToLoopStart();
  sp.start();
  println("TTS: " + inputSpeech);
}
