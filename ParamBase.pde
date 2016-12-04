public abstract class ParamBase {
  abstract PGraphics draw(PGraphics pGraphics);
  abstract ParamBase randomize(); //should return this
  abstract ParamBase merge(ParamBase other);
}