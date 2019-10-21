import processing.sound.*;

SoundFile file;
FFT fft;
int bands = 64;
float[] spectrum = new float[bands];
float duration = 0;
float theta = 0;

float step = 2*PI/180;
void setup() {
  size(800, 800);
  background(0);
  hint(ENABLE_STROKE_PURE);
  colorMode(HSB, 255);
    
  //file = new SoundFile(this, "miss_you.mp3");
  file = new SoundFile(this, "twelve.wav");
  file.loop();
  duration = file.duration();
  println(file.duration());
  
  int totalFrames = ceil(frameRate * file.duration());
  //step = 2*PI/totalFrames;
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
  int radius = 300;
  float oldX = width/2;
  float oldY = height/2;
  int normBands = bands;
  for(int i = 0; i <normBands; i++){
    
    float amp = spectrum[i];
    
    //stroke(0,255*amp, 0);
    stroke(0,0,0, .1);
    strokeWeight(1);
    
    int segment = radius - ((radius / normBands) * i);
    x = width/2 + segment*sin(theta);
    y = height/2 + segment*cos(theta);
    
    line(oldX, oldY, x, y);
    
    //if(amp > 0.01) {
    //  noStroke();
    //  color c = color(theta, 255, 150, 102);
    //  fill(c);
    //  circle(x, y, (amp *25)); 
    //}
    
    noStroke();
    color c = color(120+(120*amp), 255, 255, 102);
    fill(c);
    circle(x, y, 10*amp); 
    
    oldX = x;
    oldY = y;
  }
  theta+=step; 
 
  
  fill(0, 0, 0, 5);
  rect(0, 0, width, height);
  //rect(0, 0, bands, 200);
  //for(int i= 0; i < bands; i++){
  //// The result of the FFT is normalized
  //// draw the line for frequency band i scaling it up by 5 to get more amplitude.
  //stroke(0);
  //line( i, 200, i, 200 - spectrum[i]*200*5 );
  //} 
}
