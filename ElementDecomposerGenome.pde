class ElementDecomposerGenome extends Genome {
    private static final int MAX_ELEMENTS = 10;
    private static final float ELEMENT_MUTATION_CHANCE = 0.7;
    
    int []srcDivs;
    int []divs = new int[ElementDecomposerGenomeFactory.DIVS_X * ElementDecomposerGenomeFactory.DIVS_Y];
    
    private float fitnessVal = 0.f;
    
    PImage sourceImage;
    int bgCol;
    ArrayList<ParamBase> elements = new ArrayList<ParamBase>();
    
    public ElementDecomposerGenome(PImage sourceImage, int []srcDivs) {
      this.sourceImage = sourceImage;
      this.srcDivs = srcDivs;
      double r = 0.f;
      double g = 0.f;
      double b = 0.f;
      for (int i = 0 ; i < srcDivs.length ; i++) {
        r += red(srcDivs[i]);
        g += green(srcDivs[i]);
        b += blue(srcDivs[i]);
      }
      bgCol = color((float)r / srcDivs.length, (float)g / srcDivs.length, (float)b / srcDivs.length);
      for (int i = 0 ; i < MAX_ELEMENTS ; i++) {
        elements.add((new ParamCircle()).randomize());
      }
    }
    
    float getFitness() {
      return fitnessVal;
    }
    
    Genome copy() {
      ElementDecomposerGenome genome = new ElementDecomposerGenome(sourceImage, srcDivs);
      genome.sourceImage = this.sourceImage;
      //genome.bgCol = this.bgCol;
      genome.elements = this.elements;
      return genome;
    }

    void randomize() {
      /*
      bgCol = color(
        (int) random(255),
        (int) random(255),
        (int) random(255)
        );
        */
      if (!elements.isEmpty()) {
        for (ParamBase element : elements) {
          element.randomize();
        }
      } else {
        for (int i = 0 ; i < MAX_ELEMENTS ; i++) {
          elements.add((new ParamCircle()).randomize());
        }
      }
    }
    
    void calcFitness() {
      // TODO : add number of elements contraint on this to prefer lower numbers of elements
      drawImageOnTempContext();
      //fitnessVal = calcPixelsFitness();
      fitnessVal = calcDivsFitness();
    }
    
    private float calcDivsFitness() {
      calcDivs();
      double fit = 0;
      for (int i = 0 ; i < srcDivs.length ; i++) {
        float f = getPixelDiff(srcDivs[i], divs[i]);
        f = f + (f - ((pow(f-0.5,3)*4)+0.5));
        fit += f;
      }
      fit /= srcDivs.length;
      return (float) fit;
    }
    
    // calculates average minimum difference in raw image pixels
    private float calcPixelsFitness() { //<>//
      tempPGraphics.loadPixels();
      sourceImage.loadPixels();
      double longFitness = 0;
      for (int i = 0 ; i < sourceImage.pixels.length ; i++) {
        longFitness += getPixelDiff(sourceImage.pixels[i], tempPGraphics.pixels[i]);;
      }
      longFitness /= (double) sourceImage.pixels.length;
      return 1.f - (float) longFitness;
    }
    
    Genome mate(Genome other) {
      if (!(other instanceof ElementDecomposerGenome)) {
        return new ElementDecomposerGenome(sourceImage, srcDivs);
      }
      ElementDecomposerGenome newGenome = new ElementDecomposerGenome(sourceImage, srcDivs);
      ElementDecomposerGenome otherGenome = (ElementDecomposerGenome) other;
      
      // --- Background color
      // use one or other bakcground color
      /*
      if (random(1.f) < 0.5f) {
        newGenome.bgCol = this.bgCol;
      } else {
        newGenome.bgCol = otherGenome.bgCol;
      }
      */
      // alternative, interpolate between the two
       //newGenome.bgCol = lerpColor(this.bgCol, otherGenome.bgCol, 0.5f); // alternative, use random interpolation point instead of half
      
      // --- Elements (ParamBase)
      // use ordered half from each parent
      /*
      if (random(1.f) < 0.5f) {
        for (int i = 0 ; i < (MAX_ELEMENTS/2) ; i++) {
          newGenome.elements.add(this.elements.get(i));
        }
        for (int i = (MAX_ELEMENTS/2) ; i < MAX_ELEMENTS ; i++) {
          newGenome.elements.add(otherGenome.elements.get(i));
        }
      } else {
        for (int i = 0 ; i < (MAX_ELEMENTS/2) ; i++) {
          newGenome.elements.add(otherGenome.elements.get(i));
        }
        for (int i = (MAX_ELEMENTS/2) ; i < MAX_ELEMENTS ; i++) {
          newGenome.elements.add(this.elements.get(i));
        }
      }
      */
      // alternative, randomly take from each
      for (int i = 0 ; i < MAX_ELEMENTS ; i++) {
        if (random(1.f) < 0.5f) {
          newGenome.elements.add(this.elements.get(i));
        } else {
          newGenome.elements.add(otherGenome.elements.get(i));
        }
      }
      // alternative, interpolate between each item
      /*
      for (int i = 0 ; i < MAX_ELEMENTS ; i++) {
        newGenome.elements.add(this.elements.get(i).merge(otherGenome.elements.get(i)));
      }
      */
      return newGenome;
    }
    
    void mutate() {
      /*
      bgCol = color(
      (int) random(255),
      (int) random(255),
      (int) random(255)
      );
      */
      for (int i = 0 ; i < (MAX_ELEMENTS/2) ; i++) {
        if (random(1.f) < ELEMENT_MUTATION_CHANCE) {
          this.elements.get(i).randomize();
        }
      }
    }
    
    public String toString() {
      return "[ElementDecomposerGenome : score = " + getFitness() + "]";
    }
    
    // custom stuff
    
    public void drawImageOnTempContext() {
      // use tempPGraphics shared grpahics context
      tempPGraphics.beginDraw();
      tempPGraphics.background(bgCol);
      tempPGraphics.noStroke();
      for (ParamBase element : elements) {
        element.draw(tempPGraphics);
      }
      tempPGraphics.endDraw();
    }
    
    private float getPixelDiff(int p1, int p2) {
      /*
      float r = abs(red(p1) - red(p2)) / 255.f;
      float g = abs(green(p1) - green(p2)) / 255.f;
      float b = abs(blue(p1) - blue(p2)) / 255.f;
      float brightDiff = abs(brightness(p1) -brightness(p2)) / 255.f;
      return (r + g + b + (brightDiff * 2)) / 5.f;
      */
      /*
      float hueDiff = abs(hue(p1) - hue(p2)) / 255.f;
      float satDiff = abs(saturation(p1) - saturation(p2)) / 255.f;
      float brightDiff = abs(brightness(p1) -brightness(p2)) / 255.f;
      // TODO : weight these differently
      return ((hueDiff * 1.f) + satDiff + (brightDiff * 1)) / 3.f;
      */
      float d = dist(hue(p1), saturation(p1), brightness(p1), hue(p2), saturation(p2), brightness(p2));
      return 1.f - (d > 0.f  ? d / 255.f : 0.f);
    }
    
    private void calcDivs() {
    tempPGraphics.loadPixels();
    int divWidth = tempPGraphics.width / ElementDecomposerGenomeFactory.DIVS_X;
    int divHeight = tempPGraphics.height / ElementDecomposerGenomeFactory.DIVS_Y;
    int blockSize = divWidth * divHeight;
    int c = 0;
    for (int j = 0 ; j < ElementDecomposerGenomeFactory.DIVS_Y ; j++) {
      for (int i = 0 ; i < ElementDecomposerGenomeFactory.DIVS_X ; i++) {
        // div
        int xOffset = i * divWidth;
        int yOffset = j * divHeight;
        double red = 0;
        double green = 0;
        double blue = 0;
        for (int y = 0 ; y < divHeight ; y++) {
          for (int x = 0 ; x < divWidth ; x++) {
            int pixel = tempPGraphics.pixels[((yOffset+y)*tempPGraphics.width)+xOffset+x];
            red += ((double)red(pixel));
            green += ((double)green(pixel));
            blue += ((double)blue(pixel));
          }
        }
        red /= (double) blockSize;
        green /= (double) blockSize;
        blue /= (double) blockSize;
        divs[c++] = color((int)red, (int)green, (int)blue);
      }
    }
  }
}