import java.util.*;

// Defines the world and holds all the instances of sparks.
public static class World {
  public static float matingDivisor;
  public static float offspringDivisor;
  public static boolean canJump;
  public static boolean dieOnTrapped;
  public static float trappedDivisor; 
  public static float zombifyDivisor;
  public static float zombifiedDivisor;
  public static float zombieBrains;
  public static float spawnChance;
  public static float zombieChance;
  public static float dragonChance;
  public static float fireDivisor;
  public static float healDivisor;
  
  public static int turn = 0;
  public static int total = 0;
  public static int alive = 0;
  public static int zombies = 0;
  public static int dragons = 0;
  
  public static Spark[] population;
  public static ArrayList<Spark> living;

  public static void reset() {
    matingDivisor = 4;
    offspringDivisor = 2;
    canJump = false;
    dieOnTrapped = true;
    trappedDivisor = 6; 
    zombifyDivisor = 1.2;
    zombifiedDivisor = 1.2;
    zombieBrains = 200;
    spawnChance = 0.2;
    zombieChance = 0.5;
    dragonChance = 0.05;
    fireDivisor = 15;
    healDivisor = 20;
    
    print("RESET! ");
    printWorldSettings();
  }
  
  public static void setup(int size) {
    reset();
    population = new Spark[size];
    for (int i=0; i<population.length; i++) {
      population[i] = null;
    }
    living = new ArrayList<Spark>();
  }
  
  public static boolean add(Spark c) {
    if (population[c.pos] == null) {
      population[c.pos] = c;
      alive++;
      if (c instanceof Zombie) zombies++;
      if (c instanceof Dragon) dragons++;
      living.add(c);
      return true;
    }
    
    throw new RuntimeException("Couldn't add " + c.number + " because " + population[c.pos].number + " occupies that spot.");
  }
  
  public static boolean kill(Spark c) {
    if (c == null) {
      println("Cannot kill null");
      return false;
    }
    
    if (c.isDead) {
//      println(c.number + " is already dead.");
//      throw new RuntimeException();
      return true;
    }
    
    if (population[c.pos] != c) {
      int pos = find(c);
      if (pos >= 0) {
        println("Corrected " + c.number + " from " + c.pos + " to " + c.pos + ", will kill.");
        c.pos = pos;
      }
      else { 
        println("Cannot kill " + c.number + " because is not where expected: " + c.pos + "=" + population[c.pos]);
        return false;
      }
    }
    
    c.dad = null;
    c.mom = null;
    population[c.pos] = null;
    living.remove(c);
    
    for (Spark child : population) {
      if (child != null) {
        if (child.dad == c) child.dad = null;
        if (child.mom == c) child.mom = null;
      }
    }
    
    c.isDead = true;
    alive--;
    if (c instanceof Zombie) zombies--;
    if (c instanceof Dragon) dragons--;
    //println("Killed " + c.number + " now " + alive + " alive");
    return true;
  }

  public static int find(Spark target) {
    for (int i=0; i<population.length; i++) {
      if (population[i] == target) return i;
    }
    return -1;
  }
      
  public static int bound(int i) {
    while(i>=population.length) i-= population.length;
    while(i<0) i+= population.length;
    return i;
  }  
  
  public static Spark get(int i) {
    return population[World.bound(i)];
  }
  
  public static int move(Spark c, int delta) {
    int newpos = bound(c.pos+delta);
    if (get(newpos) == null) {
      population[c.pos] = null;
      population[newpos] = c;
      return newpos;
    }
    
    throw new RuntimeException("Cannot move " + c.number + " to " + newpos + " because " + population[newpos].number + " is there");
  }
  
  public static void swap(int l, int r) {
    Spark tmp = population[l];
    population[l] = population[r];
    population[r] = tmp;
  }
  
  public static void act() {
    Collections.shuffle(living,new Random(System.nanoTime()));

    for (int i=0; i<living.size(); i++) {
      Spark c = living.get(i);
      
      if (!c.isDead) c.act();
    }    

    turn++;
    
    if (turn % 100 == 0) 
      println("Turn #"+turn + " " + total+" born " + alive+" alive " + zombies + " zombies " + dragons + " dragons");

  }
  
  public static void draw(PGraphics pg) {
    for (Spark c : population) 
      if (c != null && !c.isDead) 
        c.draw(pg);
        
  }

  public static int makeNumber() {
    return total++;
  }  
  
  public static void despawn() {
    Spark c = living.get(0);
    living.remove(0);
    World.kill(c);
  }
  
  public static float random(float n) {
    return (float)(Math.random() * n);
  }
  
  public static void entropy() {
    World.matingDivisor = World.matingDivisor * (0.9 + random(0.2));
    World.offspringDivisor = World.offspringDivisor * (0.9 + random(0.2));
    World.canJump = random(1) < 0.2 ? !World.canJump : World.canJump;
    World.dieOnTrapped = random(1) < 0.2 ? !World.dieOnTrapped : World.dieOnTrapped;
    World.trappedDivisor = World.trappedDivisor * (0.9 + random(0.2));
    World.zombifyDivisor = World.zombifyDivisor * (0.9 + random(0.2));
    World.zombifiedDivisor = World.zombifiedDivisor * (0.9 + random(0.2));
    World.zombieChance = World.zombieChance * (0.9 + random(0.2));
    World.zombieBrains = World.zombieBrains * (0.9 + random(0.2));
    World.dragonChance = World.dragonChance * (0.9 + random(0.2));
    World.fireDivisor = World.fireDivisor * (0.9 + random(0.2));
    World.healDivisor = World.healDivisor * (0.9 + random(0.2));
    World.fireDivisor = World.fireDivisor * (0.9 + random(0.2));
    
    print("Entropy! ");
    printWorldSettings();  
  }
  
  public static void printWorldSettings() {
        println("matingDivisor=" + World.matingDivisor + 
      " offSpringDivisor=" + World.offspringDivisor + 
      " canJump=" + World.canJump + 
      " dieOnTrapped=" + World.dieOnTrapped + 
      " trappedDivisor=" + World.trappedDivisor +
      " zombifyDivisor=" + World.zombifyDivisor + 
      " zombifiedDivisor=" + World.zombifiedDivisor +
      " zombieChance=" + World.zombieChance +
      " zombieBrains=" + World.zombieBrains +
      " dragonChance=" + World.dragonChance +
      " fireDivisor=" + World.fireDivisor + 
      " healDivisor=" + World.healDivisor
    ); 
  }
}

public class Spark {
  int number;
  int pos;
  float life;
  boolean isDead;
  Spark mom;
  Spark dad;
  
  public Spark(int pos, int life, Spark mom, Spark dad) {
    this.number = World.makeNumber();
    this.pos = pos;
    this.life = life;
    this.mom = mom;
    this.dad = dad;
    this.isDead = false;
  }
  
  public boolean actOn(Spark c) {
    if (canMate(c)) return mate(c);
    else if (canEat(c,false)) return eat(c);
    return false;
  }
  
  public boolean actOnTrapped(Spark c, Spark c2, int dir) {
    if (canEat(c,true)) return eat(c);
    else if (canEat(c2,true)) return eat(c2);
    else if (World.canJump && canMove(dir*2)) return move(dir*2);
    else if (World.canJump && canMove(dir*-2)) return move(dir*-2);
    else if (World.dieOnTrapped) return die();
    else return dlife((int)(-life/World.trappedDivisor));
  }
  
  public boolean moveOn(Spark c, int delta) {
    if ((canEat(c,true) || canMate(c)) && canMove(delta)) return move(delta);
    else if (c.canEat(this,true) && canMove(-delta) && life > 32) return move(-delta);
    else if (life < 32) return dlife(-1);
    return false;
  }
  
  public boolean act() {
    if (this.isDead) {
      println(this.number + " should be dead.");
      return false;
    }
    
    int dir = number % 2 == 0 ? 1 : -1;
    Spark c; 
    Spark c2;
    
    // Try to act on first adjacent
    c = look(dir);
    if (c != null && actOn(c)) return true;
    
    // Try to act on second adjacent
    c2 = look(-dir);
    if (c2 != null && actOn(c2)) return true;

    // If trapped, act on being trapped
    if (c != null && c2 != null && actOnTrapped(c,c2,dir)) return true;
    
    // If no first adjacent, look further and plan
    if (c == null) {
      c = look(16*dir);
      
      if (c != null && moveOn(c,dir)) 
        return true;
    }
  
    // If no second adjacent, look further and plan
    if (c2 == null) {  
      c2 = look(-16*dir);
    
      if (c2 != null && moveOn(c2,-dir)) 
        return true;
    }
    
    // Otherwise just move
    return defaultAct(dir);
  }

  public boolean defaultAct(int dir) {
    if (canMove(dir)) return move(dir);
    else return move(-dir);
  }
  
  public boolean canEat(Spark victim, boolean trapped) {
    if (this == victim) {
      println(this.number + " is trying to eat itself");
      return false;
    }
    
    if (victim instanceof Dragon) return false;
    
    // Can eat if stronger, not family, or trapped/dying and not child.
    return  
      life >= victim.life && ( 
        !this.isFamily(victim) ||
        ((trapped || life < 32) && this.isParent(victim))
      );
  }
  
  public boolean canMate(Spark mate) {
    
    // Some safety checks, can remove
    if (this == mate) {
      println(this.number + " is trying to mate with itself");
      return false;
    }
    else if (this.pos == mate.pos) {
      println(this.number + " and " + mate.number + " occupy the same space!");
      return false;
    }
    
    if (mate instanceof Zombie) return false;
    if (this instanceof Zombie) return false;
    if (mate instanceof Dragon) return false;
    if (this instanceof Dragon) return false;

    // Figure out which direction would need to move
    int delta = this.pos-mate.pos/abs(this.pos-mate.pos);
    
    // If we're both healthy and can make room for baby
    return this.life >= 128 && mate.life >= 128 && 
      canMove(delta);
  }
  
  public boolean isChild(Spark c) {
    return c.dad == this || c.mom == this;
  }
  
  public boolean isParent(Spark c) {
    return dad == c || mom == c;
  }
  
  public boolean isFamily(Spark c) {
    return this.isParent(c) || this.isChild(c);
  }
  
  public boolean die() {
    World.kill(this);
    return true;
  }
  
  public boolean eat(Spark victim) {
    if (!(victim instanceof Zombie)) this.dlife(victim.life);
    World.kill(victim);
    return true;    
  }
  
  public boolean mate(Spark dad) {
    int delta = this.pos-dad.pos/abs(this.pos-dad.pos);
    int babypos = this.pos;
    
    // Mom moves out of the way
    move(delta);
    
    // Add baby in moms old position
    Spark baby = new Spark(babypos,(int)((dad.life+this.life)/World.offspringDivisor),this,dad);
    
    // Making babies takes work
    this.dlife((int)(-this.life/World.matingDivisor));
    dad.dlife((int)(-dad.life/World.matingDivisor));
    
    // Add the baby into the world
    World.add(baby);
    
    return true;
  }
  
  public Spark look(int delta) {
    int sign = delta/abs(delta);
    Spark c;
    
    for (int i=1; i<=abs(delta); i++) {
      c = World.get(pos+i*sign);
      if (c != null) return c; 
    }
    
    return null;
  }
  
  public boolean dlife(float delta) {
    life += delta;
    if (life<1)
      this.die();
    else if (life>255)
      life=255;
      
    return true;
  }
  
  public boolean canMove(int delta) {
    return World.get(pos+delta) == null;
  }
  
  public boolean move(int delta) {
    int newpos = World.move(this,delta);
    
    if (newpos >= 0) {
      pos = newpos;
      this.dlife(-abs(delta));
      return true;
    }
    
    return false;
  }
  
  public void draw(PGraphics pg) {
    int y = pos / pg.width;
    int x = pos % pg.width;
    
    pg.stroke(life);
    pg.point(x,y);    
  }
}

public class Zombie extends Spark {
  int brains;
  Zombie lastswap;
  
  public Zombie(int pos, int life, Zombie zombifier) {
    super(pos,life,zombifier,null);

    brains = (int)World.zombieBrains;
  }

  public boolean act() {
    if (brains-- < 0) dlife(-1);
    if (this.isDead) return true;
    return super.act();
  }
  
  public boolean canMate() {
    return false;
  }
  
  public boolean canEat(Spark victim, boolean trapped) {
    return life >= victim.life && !(victim instanceof Zombie) && !(victim instanceof Dragon);
  }
    
  public boolean eat(Spark victim) {
    int oldpos = victim.pos;
    
    dlife((int)(victim.life/World.zombifyDivisor));
    World.kill(victim);
    
    Zombie zombie = new Zombie(oldpos,(int)(life/World.zombifiedDivisor),this);
    World.add(zombie);
    
    brains = (int)World.zombieBrains;
    
    return true;
  }
  
  public boolean canMove(int delta) {
    Spark c = World.get(pos+delta);
    
    return (c == null || (c instanceof Zombie && c != lastswap));
  }
  
  public boolean move(int delta) {
    Spark c = World.get(pos+delta);
    
    if (c == null) {
      int newpos = World.move(this,delta);
    
      if (newpos >= 0) {
        pos = newpos;
        return true;
      }
    
      return false;
    }
    else {
      lastswap = (Zombie)c;
      World.swap(this.pos, c.pos);
      int tmp = this.pos;
      this.pos = c.pos;
      c.pos = tmp;
      return true;
    }
  }
  
  public void draw(PGraphics pg) {
    int y = pos / pg.width;
    int x = pos % pg.width;
    pg.stroke(life,(int)(life/255.0*178),(int)(life/255.0*63));
    pg.point(x,y);    
  }
}

public class Dragon extends Spark {
  int dir;
  int fireTimer = 0;
  int turnaroundTimer = 0;
  ArrayList<Float> fire = new ArrayList<Float>();
  
  public Dragon(int pos, int life) {
    super(pos,life,null,null);
    
    dir = number % 2 == 0 ? 1 : -1;
    turnaroundTimer = 10 + (int)random(10);
    for (int i=0; i<10; i++) {
      fire.add(0.0);
    }    
  }
  
  public boolean canEat(Spark victim, boolean trapped) { return true; }
  public boolean canMate(Spark mate) { return false; }

  public boolean act() {
    Spark c = look(dir*10);
    Spark c2 = look(-dir*10);
    
    if (c != null) {
      fireTimer = 10;
    }
    else if (c2 != null) {
      dir = -dir;
      fireTimer = 10;
    }
    else if (fireTimer > 0) {
      fireTimer--;
    }
    
    if (fireTimer > 0) {
      burn();
      dlife(-life/World.fireDivisor);
    }
    else dlife(life/World.healDivisor);
    
    move(dir);
    
    if (turnaroundTimer-- < 1) {
      turnaroundTimer = 50 + (int)random(50);
      dir = -dir;
    }
    
    return true;
  }
  
  public boolean burn() {
    for (int i=0; i<10; i++) {
      if (fire.get(i) > 0) {
        Spark s = World.get(pos+(i+1)*dir);
        if (s != null) s.die();
      }
    }
    
    return true;
  }
  
  public boolean move(int delta) {
    Spark c = World.get(pos+delta);
    
    if (c == null) {
      int newpos = World.move(this,delta);
    
      if (newpos >= 0) {
        pos = newpos;
        return true;
      }
    }
    
    return false;
  }
  
  public void draw(PGraphics pg) {    
    int p;
    int x;
    int y;
    float l;
    
    if (fireTimer > 0) {
      fire.add(0, random(255));
      fire.remove(fire.size()-1);
    }
    else if (fire.get(fire.size()-1) > 0) {
      fire.add(0,0.0);
      fire.remove(fire.size()-1);
    }
    
    for (int i=0; i<10; i++) {      
      p = World.bound(pos-(i*dir));
      y = p / pg.width;
      x = p % pg.width;
      l = max(life,127)/(i/2+1.0);

      pg.stroke((int)l,(int)(l/255*23),(int)(l/255*218));
      pg.point(x,y);
      
      if (fireTimer > 0 || fire.get(fire.size()-1) > 0) {
        p = World.bound(pos+(i*dir));
        y = p / pg.width;
        x = p % pg.width;

        pg.stroke(fire.get(i).intValue(),(int)(fire.get(i)/255*23),(int)(fire.get(i)/255*218));        
        pg.point(x,y);
      }
    }
  }  
}

// Runs the game.
public class Game extends DisplayableStrips {  
   // We have to do this here because we cannot make a static in
   // Spark because it's inner and we cannot access Spark from
   // World because its static.
   public void spawn(int type) {
    int pos = int(random(World.population.length));
    Spark c;
    
    for (int i=0; i<10; i++) {
      c = World.get(pos+i);
      if (c == null) {
          if (type == 0)
            c = new Spark(pos+i, (int)(64+random(128)), null, null);
          else if (type == 1)
            c = new Zombie(pos+i, (int)(64+random(128)), null);
          else
            c = new Dragon(pos+i, 255);
            
        World.add(c);
        return;
      }
    }
    
    println("Couldn't find a home for spawn");
  }
  
  public void spawn(int n, int type) {
    for (int i=0; i<n; i++) {
      spawn(type);
    }
  }
  
  public void despawn() {
    World.despawn();
  }
  
  public void despawn(int n) {
    for (int i=0; i<n; i++) {
      despawn();
    }
  }
  
  public Game(PixelMap pixelMap, Structure structure) {
    super(pixelMap, structure);
    World.setup(pg.width*pg.height);
    spawn(300,0);
    spawn(30,1);
    spawn(3,2); 
  }
  
  public void display() {
    pg.beginDraw();
    pg.background(0);
    World.act();
    
    if (World.alive < 300) {
      World.matingDivisor = World.matingDivisor * 1.01;
      println("Mating divisor changed to " + World.matingDivisor);
      spawn(300-World.alive,0);
    }
    else if (World.alive > 1000) {
      World.matingDivisor = World.matingDivisor * 0.99;
      println("Mating divisor changed to " + World.matingDivisor);
      despawn(World.alive-1000);
    }
    
    if (1.0 * World.zombies / World.alive > 0.35) {
      World.zombieBrains = World.zombieBrains * 0.999;
      println("Zombie brains changed to " + World.zombieBrains);
    }
    else if (1.0 * World.zombies / World.alive < 0.10 && World.zombieBrains < 300) {
      World.zombieBrains = World.zombieBrains * 1.001;
      println("Zombie brains changed to " + World.zombieBrains);
    }
    
    if (random(1) < World.spawnChance) {
      if (World.dragons < 10 && random(1) < World.dragonChance) {
        spawn(2);
      }
      else if (random(1) < World.zombieChance)
        spawn(1);
      else
        spawn(0);
    }
    
    World.draw(pg);
    
    if (World.turn % 100000 == 0) World.reset();
    else if (World.turn % 1000 == 0) World.entropy();
    
    pg.endDraw();
    
    super.display();
  }
}
