private static final String SRC_IMAGE_FILENAME = "/Users/simonkenny/Pictures/YouKnow/yo-dawg-i-heard-you-like-dogs-so-we-put-a-dog-in-your-dog-so-you.jpg";

private static final int IMAGE_WIDTH = 400;
private static final int IMAGE_HEIGHT = 400;

private static final int MAX_ITERATIONS = 500;

Evolver evolver;
boolean finished = false;

ElementDecomposerGenomeFactory factory;

PImage sourceImage;

PGraphics tempPGraphics;

void setup() {
  size(800, 400);
  
  PImage tempSourceImage = loadImage(SRC_IMAGE_FILENAME);
  if (tempSourceImage.width >= IMAGE_WIDTH && tempSourceImage.height >= IMAGE_HEIGHT) {
    sourceImage = tempSourceImage.get(0, 0, IMAGE_WIDTH, IMAGE_HEIGHT);
  } else {
    image(tempSourceImage, 0, 0);
    sourceImage = get(0, 0, IMAGE_WIDTH, IMAGE_HEIGHT);
  }
  
  tempPGraphics = createGraphics(IMAGE_WIDTH, IMAGE_HEIGHT);
  
  factory = new ElementDecomposerGenomeFactory(sourceImage);
  evolver = new Evolver(100, 0.3f, 0.95f, factory);
  evolver.init();
  
  println("==> Evolver with ElementDecomposerGenome, evolve best match to ");
}

void draw() {
  update(); //<>//
  
  // draw
  //background(0);
  image(sourceImage, 0, 0);
  factory.drawDivs();
  
  ElementDecomposerGenome genome = (ElementDecomposerGenome) evolver.getFittest();
  if (genome != null) {
    genome.drawImageOnTempContext();
    image(tempPGraphics, IMAGE_WIDTH, 0, IMAGE_WIDTH, IMAGE_HEIGHT);
  }
}

void update() {
  if (!finished) {
    if (evolver.run() || evolver.getIterations() > MAX_ITERATIONS) {
      println("==> Evolver completed in "+evolver.getIterations()+" iterations");
      Genome genome = evolver.getFittest();
      println("==> Fittest: "+genome.toString());
      finished = true;
    }
  }
}