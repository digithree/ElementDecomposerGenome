import java.util.List;

class Evolver {
    private int BREED_POOL_INC_FACTOR = 100;

    // parameters
    GenomeFactory genomeFactory;
    List<Genome> pool;
    Genome fittest;
    int poolSize;
    float mutationRate;
    float minFitness;

    // internal
    int iterations;

    Evolver(int poolSize, float mutationRate, float minFitness, GenomeFactory genomeFactory) {
      this.poolSize = poolSize;
      this.mutationRate = mutationRate;
      this.minFitness = minFitness;
      this.genomeFactory = genomeFactory;
    }

    // main operation
    void init() {
      println("Evovler init:");
      pool = new ArrayList<Genome>();
      for (int i = 0 ; i < this.poolSize ; i++) {
        Genome genome = genomeFactory.create();
        genome.randomize();
        genome.calcFitness();
        println(""+i+": f "+genome.getFitness());
        pool.add(genome);
      }
    }
    
    boolean run() {
      iterations++; //<>//
      println(""+iterations+": Evolver.run");
      println(" - starging pool size: "+pool.size());
      ArrayList<Genome> matingPool = new ArrayList<Genome>();
      for (Genome genome : pool) {
        float fitnessFactor = genome.getFitness() * BREED_POOL_INC_FACTOR;
        for (int i = 0 ; i < fitnessFactor ; i++) {
          matingPool.add(genome.copy());
        }
      }
      println(" - mating pool size: "+matingPool.size());
      int numMatingIterations = matingPool.size() / BREED_POOL_INC_FACTOR;
      println(" - num mating iterations: "+numMatingIterations);
      ArrayList<Genome> childPool = new ArrayList<Genome>();
      for (int i = 0 ; i < numMatingIterations ; i++) {
        Genome parent1 = matingPool.get((int)random(matingPool.size()-1));
        Genome parent2 = matingPool.get((int)random(matingPool.size()-1));
        childPool.add(parent1.mate(parent2));
      }
      println(" - num children: "+childPool.size());
      int numMutated = 0;
      for (int i = 0 ; i < childPool.size() ; i++) {
        if (random(1.f) < mutationRate) {
          childPool.get(i).mutate();
          numMutated++;
        }
      }
      println(" - num mutated: "+numMutated);
      pool.clear();
      float bestFitness = 0.f;
      if (childPool.isEmpty()) {
        println(" - no children! re-init");
        init();
      } else {
        for (int i = 0 ; i < poolSize ; i++) {
          int idx = (int) random(childPool.size()-1);
          Genome child = childPool.get(idx);
          child.calcFitness();
          pool.add(child);
          if (child.getFitness() > bestFitness) {
            bestFitness = child.getFitness();
            fittest = child;
          }
        }
      }
      println(" - pool now has children: "+pool.size());
      println(" - fittest child: "+(fittest != null ? fittest.toString() : "none"));
      return (fittest != null && fittest.getFitness() >= minFitness);
    }

    // accessors
    int getIterations() {
      return iterations;
    }
    
    Genome getFittest() {
      return fittest;
    }
}