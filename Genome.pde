public abstract class Genome {
    abstract void randomize();
    abstract void calcFitness();
    abstract float getFitness();
    abstract Genome mate(Genome other);
    abstract void mutate();
    abstract Genome copy();
}