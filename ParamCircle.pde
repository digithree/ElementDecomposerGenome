
class ParamCircle extends ParamBase {
  
  private static final int MAX_RND_ALPHA = 160;
  private static final int MIN_RADIUS = 2;
  private static final int MAX_RADIUS = 150;
  
  int centerX;
  int centerY;
  int radius;
  int col;
  
  public ParamCircle() {
    randomize();
  }
  
  public ParamCircle(ParamCircle other) {
    centerX = other.getCenterX();
    centerY = other.getCenterY();
    radius = other.getRadius();
    col = other.getCol();
  }
  
  public ParamCircle(int centerX, int centerY, int radius, int col) {
    setData(centerX, centerY, radius, col);
  }
  
  public void setData(int centerX, int centerY, int radius, int col) {
    this.centerX = centerX;
    this.centerY = centerY;
    this.radius = radius;
    this.col = col;
  }
  
  public int getCenterX() {
    return centerX;
  }
  
  public int getCenterY() {
    return centerY;
  }
  
  public int getRadius() {
    return radius;
  }
  
  public int getCol() {
    return col;
  }
  
  public PGraphics draw(PGraphics pGraphics) {
    pGraphics.fill(col);
    //println(" -- -- * ParamCircle.draw: "+centerX+", "+centerY+", "+radius+", "+col);
    pGraphics.ellipse(centerX, centerY, radius, radius);
    return pGraphics;
  }
  
  public ParamBase randomize() {
    centerX = (int) random(IMAGE_WIDTH);
    centerY = (int) random(IMAGE_HEIGHT);
    radius = MIN_RADIUS + (int) random(MAX_RADIUS - MIN_RADIUS);
    col = color(
        (int) random(255),
        (int) random(255),
        (int) random(255),
        (int) random(MAX_RND_ALPHA)
        );
    return this;
  }
  
  public ParamBase merge(ParamBase other) {
    if (!(other instanceof ParamCircle)) {
      return (new ParamCircle()).randomize();
    }
    ParamCircle otherParamCircle = (ParamCircle) other;
    return new ParamCircle(
        (int) lerp((float)centerX, (float)otherParamCircle.getCenterX(), 0.5f),
        (int) lerp((float)centerY, (float)otherParamCircle.getCenterY(), 0.5f),
        (int) lerp((float)radius, (float)otherParamCircle.getRadius(), 0.5f),
        lerpColor(col, otherParamCircle.getCol(), 0.5f)
    );
  }
}