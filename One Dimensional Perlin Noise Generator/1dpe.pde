//Pseudo Random Number Generator

//LCG (Linear Congruential Generator)

/*

M - Modulus
A - Multiplier
C - Increment

X(n+1) = (A * X(n) + C) % M
X(0) = SEED

*/

class LCG {
  
  long M = 4294967296L;
  long A = 1664525;
  long C = 1;
  long seed;
  
  LCG(int seed) {
    if(seed < 0) {
      abs(seed);
    }
    this.seed = seed;
  }
  
  LCG() {
    seed = 0;
  }
  
  float getRand() {
    long num = (A * seed + C) % M;
    seed = num;
    return (float)num/M;
  }
  
};

double cosineInterpolate(double a, double b, double x) {
 double ft = (1 - cos((float)(x * PI))) / 2;
 return ((a * (1 - ft)) + (b * ft));
}

LCG generator;
double x;
double y;
int amplitude;
int frequency;
int wavelength;
double a;
double b;
int scale = 100;

void setup() {
 size(640, 360);
 x = 0;
 y = height / 2;
 amplitude = 100;
 wavelength = 50;
 frequency = 1 / wavelength;
 generator = new LCG(100);
 a = generator.getRand()*scale;
 b = generator.getRand()*scale;
 stroke(0);
 strokeWeight(2);
}

void draw() {

 if(x % wavelength == 0) {
   a = b;
   b = generator.getRand()*scale;
   y = (height / 2 + a * amplitude);
 } else {
   y = (height / 2 + cosineInterpolate(a, b, (x % wavelength) / wavelength));
 }
 point((int)x, (int)y);
 x++;
   
  
}

