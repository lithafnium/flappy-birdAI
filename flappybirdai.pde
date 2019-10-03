float pipeGap = 400; 
float mutationRate = 0.2; 


class Pipe {
  float topHeight; 
  float gap = 300; 
  float pipeWidth = 150; 
  float x; 
  boolean closest; 
  public Pipe(float x) {
    topHeight = random(100, 500); 
    this.x = x;
  }

  void display() {
    if (closest) {
      fill(255, 0, 0);
    } else fill(0, 255, 0); 
    rect(x, 0, pipeWidth, topHeight); 
    rect(x, topHeight + gap, pipeWidth, height-(topHeight + gap));
  }
  void move() {
    x -= 2.5;
  }
}

class Bird {
  float x = 200; 
  float y = height/2; 
  float v = 0; 
  float a = 1; 
  PImage sprite; 

  boolean dead; 
  boolean stop; 

  float score; 
  float fitness; 
  NeuralNetwork brain; 
  public Bird(NeuralNetwork b ) {
    //String url = "https://www.spriters-resource.com/resources/sheet_icons/56/59537.png";
    sprite = loadImage("flappybirdsprite.png"); 
    dead = false; 
    if (b != null) {
      this.brain = b;
      this.brain.mutate();
    } else {
      this.brain = new NeuralNetwork(4, 16, 2);
    }
  }
  
  Bird copy(){
     return new Bird(this.brain);  
  }

  void display() {
    if (dead) {
      fill(255, 0, 0);
    } else {
      fill(0, 255, 255);
    }
    noStroke(); 
    rect(x, y, 51, 36); 
    image(sprite, x, y); 
    //ellipse(x, y, 50, 50);
  }

  void move() {
    y += v; 
    v += a;
  }

  void jump() {
    v = -14;
  }
  // pipe x position, top y, bottom y, bird y position
  void think(Pipe[] pipes) {
    Pipe closest = null; 
    float max = MAX_INT; 
    for (int j = 0; j < pipes.length; j++) {
      float diff = abs(pipes[j].x - 200); 
      if (diff < max) {
        max = diff; 
        closest = pipes[j];
      }
    }
    float d = closest.x; 
    float h1 = closest.topHeight; 
    float h2 = closest.topHeight + closest.gap; 
    float y = this.y;

    float[] inputs = new float[4]; 
    //map x position of closetst pipe 
    inputs[0] = map(d, this.x, width, -1, 1); 
    // map top of closest pipe opening
    inputs[1] = map(h1, 0, height, -1, 1); 

    // map bottom of closest pip opening 
    inputs[2] = map(h2, 0, height, -1, 1); 

    // map bird's y position y
    inputs[3] = map(y, 0, height, -1, 1); 

    float[] action = this.brain.query(inputs); 

    if (action[1] > action[0]) {
      this.jump();
    }
  }
}


Bird b;
Pipe p; 
Pipe[] pipes = new Pipe[5]; 
Bird[] birds = new Bird[300]; 
boolean allDead = false; 
int pipesCounter = 5; 
int current = 5; 
float difference = 0; 
int deadCount = 0; 
int cycles = 1; 
int generation = 1; 
PImage bckg;

void setup() {
  size(900, 900); 
  background(135, 206, 235);
  bckg = loadImage("flappybirdbackground.jpg");
  
  for (int i = 0; i < birds.length; i++) {
    birds[i] = new Bird(null);
  }

  for (int i = 0; i < 5; i++) {
    pipes[i] = new Pipe(500 + pipeGap * i);
  }
  //imageMode(CENTER); 
  //rectMode(CENTER);
}

void draw() {
  background(135, 206, 235);
  

  for (int k = 0; k < cycles; k++) {
    for (int i = 0; i < pipes.length; i++) {
      Pipe p = pipes[i]; 
      p.display(); 
      p.move(); 



      if (p.x < -200) {
        pipes[i] = new Pipe(1800);
        pipes[i].closest = false;
      }
    }
    //if(pipes[(pipesCounter-1) % 5].x < -200){

    //}



    //closest.closest = true; 


    for (int i = 0; i < birds.length; i++) {

      Bird b = birds[i]; 
      Pipe p; 

      b.display(); 
      b.move(); 

      // collision code 

      if (!b.dead) { 
        b.think(pipes); 

        for (int j = 0; j < pipes.length; j++) {
          if (pipeCollision(200, b.y, pipes[j])) {
            deadCount++;
            b.dead = true; 
            b.score = frameCount;
          }
        }
        Pipe closest = null; 
        float max = MAX_INT; 
        for (int j = 0; j < pipes.length; j++) {
          float diff = abs(pipes[j].x - 200); 
          if (diff < max) {
            max = diff; 
            closest = pipes[j];
          }
        }
        if (b.y < 0 && abs(closest.x - b.x) < 51 && !b.dead) {
          deadCount++;
          b.dead = true; 
          b.score = frameCount;
        }



        if (b.y + 50 > height && !b.dead) {
          deadCount++; 

          b.v = 0; 
          b.a = 0; 
          b.y = height-25; 
          b.dead = true; 
          b.score = frameCount;
        }
      }
    }

    //println("dead:", deadCount); 
    if (countDead(birds) == birds.length) {
      generation++; 
      reset();
    }
  }
  fill(0); 
  textSize(32); 
  text("Generation: " + generation, 50, 100); 
  text("Alive: " + (birds.length - countDead(birds)), 50, 150); 
  text("Speed: " + cycles, 50, 200); 
}

boolean pipeCollision(float bx, float by, Pipe p) {
  if (bx + 51 >= p.x && bx <= p.x + p.pipeWidth && by + 36 >= 0 && by <= 0 + p.topHeight) {
    //println("dead"); 
    return true;
  } 
  if (bx + 51 >= p.x && bx <= p.x + p.pipeWidth && by + 36 >= p.topHeight + p.gap && by <= height) {
    //println("dead"); 
    return true;
  }
  return false;
}



void reset() {
  for (int i = 0; i < 5; i++) {
    pipes[i] = new Pipe(500 + pipeGap * i);
  }
  nextGeneration();
}
int countDead(Bird[] birds) {
  int count = 0;
  for (int i = 0; i < birds.length; i++) {
    if (birds[i].dead) count++; 
    //println(birds[i].score);
  }
  //println(count); 
  return count;
}

void nextGeneration() {
  Bird[] nextGen = new Bird[birds.length]; 
  calculateFitness(birds); 
  //pick(); 

  for (int i = 0; i < birds.length; i++) {
    Bird b = pick(birds); 
    nextGen[i] = b;
  }

  birds = nextGen;
}
Bird pick(Bird[] birds) {
  int index = 0; 
  float r = random(1); 

  while (r > 0) {
    //println("index", index); 
    //println("r", r); 
    //println("fitness", birds[index].fitness); 
    r -= birds[index].fitness; 
    index++;
  }
  index--; 


  return birds[index].copy(); 

}
void calculateFitness(Bird[] birds) {

  for (Bird b : birds) {
    b.score = pow(b.score, 2);
  }
  float sum = 0; 
  for (Bird b : birds) {
    sum += b.score;
  }
  println("sum", sum); 
  float fitnessSum = 0; 
  for (Bird b : birds) {
    b.fitness = b.score / sum;  
    println(b.fitness); 
    fitnessSum += b.fitness;
  } 

  println("fitnessSum", fitnessSum);
}



void keyPressed(){
   if(keyCode == UP){
      cycles++;  
   }
   if(keyCode == DOWN){
      if(!(cycles == 1)) cycles--;  
   }
}
//void mousePressed(){
//  if(!b.dead){
//     b.v = -18;
//  }
//}

//void keyPressed(){
//  if(!b.dead){
//     b.v = -18; 
//  }
//}