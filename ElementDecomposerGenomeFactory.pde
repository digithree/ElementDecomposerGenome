public class ElementDecomposerGenomeFactory extends GenomeFactory {
  
  public static final int DIVS_X = 16;
  public static final int DIVS_Y = 16;
  
  PImage sourceImage;
  int []srcDivs = new int[DIVS_X * DIVS_Y]; 
  
  public ElementDecomposerGenomeFactory(PImage sourceImage) {
      this.sourceImage = sourceImage;
      calcDivs();
    }
  
  public Genome create() {
    Genome genome = new ElementDecomposerGenome(sourceImage, srcDivs);
    genome.randomize();
    return genome;
  }
  
  public void drawDivs() {
    int c = 0;
    int divWidth = IMAGE_WIDTH / DIVS_X;
    int divHeight = IMAGE_HEIGHT / DIVS_Y;
    noStroke();
    for (int j = 0 ; j < DIVS_Y ; j++) {
      for (int i = 0 ; i < DIVS_X ; i++) {
        int col = srcDivs[c++];
        fill(red(col), green(col), blue(col), 100);
        rect(i * divWidth, j * divHeight, divWidth, divHeight);
      }
    }
  }
  
  private void calcDivs() {
    sourceImage.loadPixels();
    int divWidth = sourceImage.width / DIVS_X;
    int divHeight = sourceImage.height / DIVS_Y;
    int blockSize = divWidth * divHeight;
    int c = 0;
    for (int j = 0 ; j < DIVS_Y ; j++) {
      for (int i = 0 ; i < DIVS_X ; i++) {
        // div
        int xOffset = i * divWidth;
        int yOffset = j * divHeight;
        double red = 0;
        double green = 0;
        double blue = 0;
        for (int y = 0 ; y < divHeight ; y++) {
          for (int x = 0 ; x < divWidth ; x++) {
            int pixel = sourceImage.pixels[((yOffset+y)*sourceImage.width)+xOffset+x];
            red += ((double)red(pixel));
            green += ((double)green(pixel));
            blue += ((double)blue(pixel));
          }
        }
        red /= (double) blockSize;
        green /= (double) blockSize;
        blue /= (double) blockSize;
        srcDivs[c++] = color((int)red, (int)green, (int)blue);
      }
    }
  }
}