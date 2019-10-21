import processing.sound.*;

SoundFile file;
FFT fft;
int bands = 512;
float[] spectrum = new float[bands];
float duration = 0;
float theta = 0;
float hueStep = 125;

float step = 2*PI/360;
void setup() {
  size(600, 600);
  background(255);
  hint(ENABLE_STROKE_PURE);
  colorMode(HSB, 255);
    
  //file = new SoundFile(this, "miss_you.mp3");
  file = new SoundFile(this, "twelve.wav");
  file.loop();
  duration = file.duration();
  println(file.duration());
  
  int totalFrames = ceil(frameRate * file.duration());
  step = 2*PI/totalFrames;
  print("total frames", totalFrames, file.duration());
  
  //// Create an Input stream which is routed into the Amplitude analyzer
  fft = new FFT(this, bands);
  //in = new AudioIn(this, 0);
  
  //// start the Audio Input
  //in.start();
  
  //// patch the AudioIn
  fft.input(file);
}      

void draw() { 
  fft.analyze(spectrum);
  
  float percentComplete = (millis()/1000) / duration;
  
  float x, y;
  int radius = 900;
  float oldX = width/2;
  float oldY = height/2;
  int normBands = bands / 2;
  
  float generalStrength = 0;
  for(int i = 0; i <normBands; i++){
    generalStrength += spectrum[i];
  }
  
  for(int i = 0; i <normBands; i++){
    
    float amp = spectrum[i];
   
    
    //stroke(0,255*amp, 0);
    
    
   int segment = 100 + i * (radius / normBands);
    
   //println(i, normBands);
     if(i-2 >= normBands) {
      //println(spectrum[i], amp);
      println(segment, segment);
    }
    
    //x = width/2 + segment*sin(theta);
    //y = height/2 + segment*cos(theta);
    
    //int segment = radius - ((radius / normBands) * i);
    x = width/2 + segment*sin(theta);
    y = height/2 + segment*cos(theta);
    
    stroke(0,0,0, 100*amp);
    strokeWeight(3*amp);
    
    //line(x, y, oldX, oldY);
     //line(x, y, oldX, oldY);
    
    if(amp >= 0.01) {
      noStroke();
      fill(hueStep,  255, 150*(generalStrength/3), 100);
      circle(x, y,  1.5 + (amp *10)); 
    }
    
    oldX = x;
    oldY = y;
  }
  theta+=step; 
  hueStep+=.01;
  if(hueStep > 255) {
    hueStep = 0;
  }
  
  if(theta > 2*PI) {
   noLoop(); 
  }
  else {
    saveFrame();
  }
 
  
  //fill(255, 255, 255, 10);
  //rect(0, 0, width, height);
  //rect(0, 0, bands, 200);
  //for(int i= 0; i < bands; i++){
  //// The result of the FFT is normalized
  //// draw the line for frequency band i scaling it up by 5 to get more amplitude.
  //stroke(0);
  //line( i, 200, i, 200 - spectrum[i]*200*5 );
  //} 
}

float normAmp(float amp) {
 float n = 0;
 n = amp / .2;
 if(n > 100) {
   n = 100;
 }
 return n;
}
