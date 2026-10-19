/*
 * Q1: Walk me through designing a class hierarchy for [some real-world system]
 * Answer:
 *
 * This is a LIVE/ON-SPOT question - they give you a random system (parking lot,
 * library, ATM, zoo, food delivery app, elevator...) and watch your THOUGHT PROCESS,
 * not just the final code. So don't just start typing, talk out loud step by step.
 *
 * MY GENERAL APPROACH (say this out loud in interview, step by step):
 *
 * STEP 1: Identify the NOUNS (these become your classes)
 * Listen to the problem, pick out the main "things" involved.
 *
 * STEP 2: Identify relationships between them
 * - IS-A -> inheritance (Dog IS-A Animal)
 * - HAS-A -> composition (Car HAS-A Engine)
 *
 * STEP 3: Identify common behavior -> goes in parent class / interface
 * If multiple classes share some behavior/fields, pull it up to a common
 * parent (abstract class) or interface.
 *
 * STEP 4: Decide abstract class vs interface
 * - Related classes sharing code/state -> abstract class
 * - Unrelated classes needing same capability -> interface
 *
 * STEP 5: Add the 4 pillars naturally as you go
 * - Encapsulation: private fields, public getters/setters with validation
 * - Abstraction: abstract methods for things that differ per subclass
 * - Inheritance: shared structure pulled into parent
 * - Polymorphism: overridden methods behave differently per subclass
 *
 * STEP 6: Keep it SIMPLE first, then mention you'd extend it
 * Don't over-engineer on the spot, build a basic version, then say
 * "this can be extended further with X, Y, Z if needed"
 *
 * -----------------------------------------------------------
 * EXAMPLE WALKTHROUGH: "Design a class hierarchy for a Parking Lot system"
 * (so you have a template, same steps apply to ANY system they give you)
 *
 * Step 1 - Nouns: ParkingLot, ParkingSpot, Vehicle, Car, Bike, Truck, Ticket
 * Step 2 - Relationships: Car/Bike/Truck IS-A Vehicle. ParkingLot HAS-A list of ParkingSpots.
 * Step 3 - Common behavior: all vehicles have licensePlate, type -> goes in Vehicle class
 * Step 4 - Vehicle = abstract class (related, shared fields+behavior)
 */

abstract class Vehicle {
    private String licensePlate;

    public Vehicle(String licensePlate) {
        this.licensePlate = licensePlate;
    }

    public String getLicensePlate() {
        return licensePlate;
    }

    abstract String getType(); // forces every vehicle to say what type it is
}

class Car extends Vehicle {
    public Car(String licensePlate) {
        super(licensePlate);
    }

    @Override
    String getType() {
        return "Car";
    }
}

class Bike extends Vehicle {
    public Bike(String licensePlate) {
        super(licensePlate);
    }

    @Override
    String getType() {
        return "Bike";
    }
}

class ParkingSpot {
    private int spotNumber;
    private boolean isOccupied;
    private Vehicle parkedVehicle;

    public ParkingSpot(int spotNumber) {
        this.spotNumber = spotNumber;
        this.isOccupied = false;
    }

    public boolean parkVehicle(Vehicle vehicle) {
        if (isOccupied) {
            return false;
        }
        this.parkedVehicle = vehicle;
        this.isOccupied = true;
        return true;
    }

    public void removeVehicle() {
        this.parkedVehicle = null;
        this.isOccupied = false;
    }

    public boolean isOccupied() {
        return isOccupied;
    }
}

class ParkingLot {
    private ParkingSpot[] spots;

    public ParkingLot(int totalSpots) {
        spots = new ParkingSpot[totalSpots];
        for (int i = 0; i < totalSpots; i++) {
            spots[i] = new ParkingSpot(i + 1);
        }
    }

    public boolean parkVehicle(Vehicle vehicle) {
        for (ParkingSpot spot : spots) {
            if (!spot.isOccupied()) {
                return spot.parkVehicle(vehicle);
            }
        }
        return false; // parking lot full
    }
}

/*
 * Step 5 - Pillars used here:
 * - Encapsulation: licensePlate, isOccupied are private, accessed thru methods
 * - Abstraction: getType() is abstract, each vehicle defines its own
 * - Inheritance: Car, Bike extend Vehicle, reuse licensePlate logic
 * - Polymorphism: getType() behaves differently per subclass (if called via
 * Vehicle ref)
 *
 * Step 6 - Say this at the end: "This is a basic version, in a real system I'd
 * also
 * add things like pricing strategy, different spot types for different vehicle
 * sizes,
 * a Ticket class to track entry/exit time, maybe a payment module etc."
 *
 * Interview line: "For live design questions, I talk through my process - first
 * I pick
 * out the nouns as classes, figure out IS-A vs HAS-A relationships, pull shared
 * behavior
 * into a parent abstract class or interface depending on whether the classes
 * are related
 * or just need a common capability, then apply encapsulation and polymorphism
 * naturally
 * as I build it out, keeping the first version simple and mentioning what I'd
 * extend later."
 */

/*
 * Q2: What design pattern would you use for X, and why? (Singleton asked
 * constantly)
 * Answer:
 *
 * This is also an "on the spot" type question - they describe a scenario (X)
 * and want
 * you to pick the RIGHT pattern and explain WHY. Singleton comes up the most,
 * so let's
 * go deep on that, then quickly cover a few other commonly asked ones so you
 * recognize
 * which pattern fits which scenario.
 *
 * -----------------------------------------------------------
 * SINGLETON PATTERN (most asked)
 *
 * WHAT: Ensures only ONE instance of a class exists in the entire application,
 * and gives a global point of access to it.
 *
 * WHEN to use it (say these out loud when asked "why"):
 * - Database connection manager -> don't want multiple separate connections
 * eating resources
 * - Logger class -> one single logger instance writing to the same log file
 * across app
 * - Configuration/Settings manager -> app-wide settings should be consistent,
 * one source of truth
 * - Thread pool manager -> managing a fixed set of threads, shouldn't have
 * multiple pools randomly
 *
 * Basic version (NOT thread-safe, mention this limitation):
 */

class Singleton {
    private static Singleton instance;

    private Singleton() {
        // private constructor stops 'new Singleton()' from outside
    }

    public static Singleton getInstance() {
        if (instance == null) {
            instance = new Singleton();
        }
        return instance;
    }
}

/*
 * PROBLEM with above: if two threads call getInstance() at the EXACT same time,
 * BOTH might see instance == null and create TWO separate objects -> breaks
 * singleton!
 *
 * THREAD-SAFE version (mention this, shows depth):
 */

class SingletonThreadSafe {
    private static volatile SingletonThreadSafe instance;

    private SingletonThreadSafe() {
    }

    public static SingletonThreadSafe getInstance() {
        if (instance == null) {
            synchronized (SingletonThreadSafe.class) {
                if (instance == null) {
                    instance = new SingletonThreadSafe();
                }
            }
        }
        return instance;
    }
}

/*
 * This is called "double-checked locking" - checks null twice, only locks when
 * actually needed (not every single call), so its efficient AND thread-safe.
 * 'volatile' keyword makes sure changes to 'instance' are visible to all
 * threads immediately.
 *
 * -----------------------------------------------------------
 * OTHER PATTERNS YOU SHOULD QUICKLY RECOGNIZE (just the "when to use" part):
 *
 * FACTORY PATTERN
 * - Use when: object creation logic is complex or depends on some condition,
 * and you want to hide that creation logic from the caller
 * - Ex: "Create a Shape based on user input (circle/square/triangle)"
 *
 * class ShapeFactory {
 * static Shape createShape(String type) {
 * if (type.equals("circle")) return new Circle();
 * if (type.equals("square")) return new Square();
 * return null;
 * }
 * }
 *
 * BUILDER PATTERN
 * - Use when: an object has MANY optional fields/parameters, avoids giant
 * constructors with 10 parameters (telescoping constructor problem)
 * - Ex: Building a complex object like a "Pizza" with many optional toppings
 *
 * OBSERVER PATTERN
 * - Use when: one object's state change needs to automatically notify multiple
 * other objects (like a publish-subscribe setup)
 * - Ex: "Notification system - when a new post is made, notify all subscribers"
 *
 * STRATEGY PATTERN
 * - Use when: you have multiple ways of doing something (algorithms) and want
 * to
 * switch between them at runtime without changing the class using them
 * - Ex:
 * "Different payment methods - credit card, UPI, wallet, all implement same interface"
 *
 * -----------------------------------------------------------
 * Simple way to answer in interview when they give you a random scenario X:
 * Ask yourself:
 * - "Should only ONE object ever exist?" -> Singleton
 * - "Is object creation complex/conditional?" -> Factory
 * - "Does object have tons of optional fields?" -> Builder
 * - "Do multiple things need to react when something changes?" -> Observer
 * - "Are there multiple interchangeable ways to do the same task?" -> Strategy
 *
 * Interview line: "For scenario X, I'd use [pattern] because [specific reason
 * tied to
 * the scenario]. For example, Singleton makes sense when you need exactly one
 * shared
 * instance across the app, like a database connection or logger - it saves
 * resources
 * and keeps state consistent everywhere, and I'd implement it with
 * double-checked locking
 * to make sure it's thread-safe too."
 */

/*
 * Q3: How would you implement a Singleton class in Java, and what problems can
 * arise with it in multi-threaded code?
 * Answer:
 *
 * (We touched this in Q2, but here they want FULL focus on implementation +
 * threading
 * problems specifically, so let's go step by step properly)
 *
 * -----------------------------------------------------------
 * APPROACH 1: Basic/Lazy Singleton (NOT thread-safe)
 */

class Singleton {
    private static Singleton instance;

    private Singleton() {
    }

    public static Singleton getInstance() {
        if (instance == null) {
            instance = new Singleton();
        }
        return instance;
    }
}

/*
 * THE PROBLEM in multi-threading:
 *
 * Imagine Thread-1 and Thread-2 BOTH call getInstance() at almost the exact
 * same time,
 * when instance is still null.
 *
 * Thread-1: checks "instance == null" -> true -> about to create object...
 * Thread-2: checks "instance == null" -> ALSO true (Thread-1 hasn't finished
 * yet!) -> about to create object too...
 * Thread-1: creates object A, assigns to instance
 * Thread-2: creates object B, assigns to instance (OVERWRITES Thread-1's
 * object!)
 *
 * Result: TWO different Singleton objects got created at some point, breaking
 * the
 * whole purpose of Singleton (only one instance). Depending on timing, some
 * code
 * might even be holding a reference to the OLD object (A) while instance now
 * points to B
 * -> inconsistent state across the application, hard to debug bugs.
 *
 * -----------------------------------------------------------
 * APPROACH 2: Make getInstance() fully synchronized (fixes the problem, but
 * SLOW)
 */

class SingletonSynchronized {
    private static SingletonSynchronized instance;

    private SingletonSynchronized() {
    }

    public static synchronized SingletonSynchronized getInstance() {
        if (instance == null) {
            instance = new SingletonSynchronized();
        }
        return instance;
    }
}

/*
 * This works correctly - only one thread can enter getInstance() at a time.
 * PROBLEM: EVERY single call to getInstance() has to wait for the lock, even
 * AFTER the instance is already created and there's no real risk anymore.
 * This hurts performance if this method gets called A LOT (which it usually
 * does
 * since that's the whole point of a frequently-accessed singleton like a
 * logger).
 *
 * -----------------------------------------------------------
 * APPROACH 3: Double-Checked Locking (BEST - fixes both correctness AND
 * performance)
 */

class SingletonDoubleChecked {
    private static volatile SingletonDoubleChecked instance;

    private SingletonDoubleChecked() {
    }

    public static SingletonDoubleChecked getInstance() {
        if (instance == null) { // first check (no locking, fast)
            synchronized (SingletonDoubleChecked.class) {
                if (instance == null) { // second check (inside lock, safe)
                    instance = new SingletonDoubleChecked();
                }
            }
        }
        return instance;
    }
}

/*
 * WHY this is better:
 * - First "if (instance == null)" check happens WITHOUT locking -> fast for all
 * the
 * calls AFTER instance is already created (most calls in real life), no
 * unnecessary waiting
 * - Lock only triggers the FEW times instance might still be null (early on)
 * - Second check INSIDE the lock makes sure that even if two threads both got
 * past the
 * first check together, only ONE of them actually creates the object (second
 * thread
 * sees instance is no longer null once it gets the lock, so it skips creating
 * again)
 *
 * WHY 'volatile' is needed here (important interview detail):
 * Without volatile, due to how JVM can reorder instructions for optimization,
 * another thread might see a "partially constructed" object - meaning instance
 * is NOT null, but the Singleton object's internal fields aren't fully
 * initialized yet.
 * 'volatile' prevents this reordering and makes sure writes to 'instance' are
 * immediately visible to all threads in proper order.
 *
 * -----------------------------------------------------------
 * APPROACH 4: Easiest fix of all - Eager initialization (if object creation
 * isn't expensive)
 */

class SingletonEager {
    private static final SingletonEager instance = new SingletonEager();

    private SingletonEager() {
    }

    public static SingletonEager getInstance() {
        return instance;
    }
}

/*
 * This is automatically thread-safe because the JVM creates the instance when
 * the
 * CLASS itself is loaded (class loading is inherently thread-safe in Java),
 * before
 * any thread even gets a chance to race for it. No synchronized needed, no
 * checks needed.
 * ONLY DOWNSIDE: object gets created even if you never end up calling
 * getInstance(),
 * so not ideal if the object is heavy/expensive to create and might not always
 * be needed.
 *
 * -----------------------------------------------------------
 * Interview line: "The basic lazy singleton isn't thread-safe - two threads can
 * both
 * pass the null check at the same time and create two separate instances,
 * breaking the
 * singleton guarantee. You can fix it by synchronizing the whole method, but
 * that hurts
 * performance since every call gets locked even after the instance exists. The
 * better fix
 * is double-checked locking with a volatile instance variable - it only locks
 * on the rare
 * case the instance might still be null, and volatile prevents issues from
 * instruction
 * reordering during object construction. Alternatively, if the object isn't
 * expensive to
 * create, eager initialization avoids the threading problem entirely since the
 * JVM
 * guarantees thread-safe class loading."
 */

/*
 * Q4: Difference between composition and inheritance, and when to prefer one
 * over the other?
 * Answer:
 *
 * (We covered IS-A/HAS-A basics in section 2 Q9 - this question wants you to go
 * DEEPER on when to actually CHOOSE one over the other, which is what
 * interviewers
 * really care about here)
 *
 * QUICK RECAP of the difference:
 *
 * INHERITANCE (IS-A) -> subclass extends parent, gets its code/behavior
 * automatically
 * COMPOSITION (HAS-A) -> class contains an object of another class as a field,
 * uses its methods
 */

class Engine {
    void start() {
        System.out.println("Engine starting");
    }
}

// Inheritance example
class Vehicle {
    void move() {
        System.out.println("Vehicle moving");
    }
}

class Car extends Vehicle {
    // Car IS-A Vehicle, automatically gets move()
}

// Composition example
class CarComposed {
    private Engine engine = new Engine(); // Car HAS-A Engine

    void drive() {
        engine.start();
        System.out.println("Car driving");
    }
}

/*
 * -----------------------------------------------------------
 * PROBLEMS WITH INHERITANCE (why it's not always the best choice):
 *
 * 1. TIGHT COUPLING - child class is heavily dependent on parent's internal
 * implementation.
 * If parent class changes something, it can break child classes unexpectedly
 * ("fragile base class problem")
 *
 * 2. INHERITS EVERYTHING - even stuff you don't need or want. You can't
 * selectively
 * pick which methods to inherit, you get the whole package.
 *
 * 3. SINGLE INHERITANCE LIMIT - a class can only extend ONE class in Java, so
 * if you
 * need behavior from multiple sources, inheritance alone can't give you that.
 *
 * 4. BREAKS ENCAPSULATION sometimes - subclass can end up depending on parent's
 * internal behavior/implementation details, not just its public contract.
 *
 * -----------------------------------------------------------
 * WHY COMPOSITION IS OFTEN BETTER (the famous principle:
 * "favor composition over inheritance"):
 *
 * 1. LOOSE COUPLING - CarComposed just USES Engine thru a clean
 * interface/reference,
 * doesn't care how Engine works internally. Can even swap Engine for a
 * different
 * implementation (like ElectricEngine) easily.
 *
 * 2. MORE FLEXIBLE - you can combine MULTIPLE objects/behaviors freely
 * (Car can HAS-A Engine AND HAS-A GPS AND HAS-A SoundSystem - no
 * "single inheritance" limit)
 *
 * 3. CAN CHANGE AT RUNTIME - you can swap out the composed object dynamically,
 * inheritance relationship is fixed at compile time and can't change
 *
 * class CarFlexible {
 * private Engine engine;
 * CarFlexible(Engine engine) { this.engine = engine; } // inject any engine
 * type
 * void drive() { engine.start(); }
 * }
 * // Later: can pass PetrolEngine, ElectricEngine, anything that fits - true
 * flexibility
 *
 * -----------------------------------------------------------
 * WHEN TO ACTUALLY PREFER EACH:
 *
 * PREFER INHERITANCE when:
 * - There's a genuine, strong "IS-A" relationship (Dog IS-A Animal, truly makes
 * sense)
 * - You want polymorphism - treating different subclasses uniformly thru parent
 * reference
 * - The relationship is unlikely to change, and shared behavior is core to what
 * the class IS
 *
 * PREFER COMPOSITION when:
 * - Relationship is really "HAS-A" or "USES-A", not a true type relationship
 * - You want flexibility to change behavior at runtime
 * - You want to avoid tight coupling to a parent's implementation details
 * - You need to combine behaviors from multiple sources (since no multiple
 * inheritance of classes)
 *
 * Simple real test: say "X is a Y" out loud.
 * - Sounds natural and X truly behaves like a specialized version of Y ->
 * inheritance fine
 * - Sounds forced, or X just "uses"/"contains" Y -> composition is the better
 * choice
 *
 * Interview line: "Inheritance is an IS-A relationship where a subclass extends
 * a parent
 * and automatically gets its behavior, while composition is a HAS-A
 * relationship where a
 * class contains an instance of another class and uses it through its
 * interface. Inheritance
 * creates tight coupling to the parent's implementation and is fixed at compile
 * time, while
 * composition is more flexible - you can swap implementations, combine multiple
 * behaviors,
 * and avoid the fragile base class problem. The general guideline is to favor
 * composition
 * over inheritance unless there's a genuinely strong IS-A relationship where
 * polymorphism
 * is actually needed."
 */

/*
 * Q5: What is the "favor composition over inheritance" principle, and why does
 * it exist?
 * Answer:
 *
 * (This builds directly on Q5 - same core idea, but they want you to explain it
 * as its
 * OWN principle/concept, like a named design guideline you'd quote in
 * interview)
 *
 * WHAT IT MEANS:
 * When designing a class and deciding how to reuse code from another class,
 * prefer
 * using COMPOSITION (HAS-A, containing an object as a field) over INHERITANCE
 * (IS-A,
 * extending a class) - UNLESS there's a genuinely strong, natural "is-a"
 * relationship
 * AND you actually need polymorphism.
 *
 * It's not saying "never use inheritance", it's saying "don't reach for
 * inheritance
 * by default just to reuse code - think if composition fits better first."
 *
 * -----------------------------------------------------------
 * WHY THIS PRINCIPLE EXISTS - the real problems inheritance causes when
 * overused:
 *
 * 1. FRAGILE BASE CLASS PROBLEM
 * If parent class changes its internal implementation (even without changing
 * its
 * public contract), it can silently break subclasses that depended on the old
 * behavior.
 * Child classes are tightly bound to parent's internals, not just its public
 * API.
 */

class Parent {
    void process() {
        step1();
        step2();
    }

    void step1() {
        System.out.println("Parent step1");
    }

    void step2() {
        System.out.println("Parent step2");
    }
}

class Child extends Parent {
    @Override
    void step1() {
        System.out.println("Child custom step1");
    }
    // Child silently depends on process() calling step1() then step2() internally.
    // If Parent later changes process() to call step2() BEFORE step1(), Child
    // breaks,
    // even though Child never touched that code itself.
}

/*
 * 2. INHERITING STUFF YOU DON'T WANT
 * Classic example: in some older designs, Square extends Rectangle (since
 * mathematically a square IS a rectangle), but Rectangle has separate
 * setWidth()
 * and setHeight() methods. Square breaks this - if you setWidth() on a Square,
 * height should also change to keep it a square, but it inherited two
 * independent
 * setters that don't make sense together for a Square's actual behavior.
 * This is called violating the "Liskov Substitution Principle" - subclass
 * should
 * be usable wherever parent is expected, without breaking things.
 *
 * 3. TIGHT COUPLING = HARD TO CHANGE LATER
 * Inheritance relationship is locked in at compile time. If you realize later
 * that
 * the design doesn't fit, refactoring deep inheritance chains is painful and
 * risky.
 * Composition just needs you to swap which object you're holding - way less
 * disruptive.
 *
 * 4. NO MULTIPLE INHERITANCE OF CLASSES
 * If a class needs behavior from TWO different sources, inheritance alone
 * physically cannot do that in Java. Composition can combine as many behaviors
 * as needed since you're just holding multiple object references.
 *
 * -----------------------------------------------------------
 * HOW COMPOSITION AVOIDS THESE PROBLEMS:
 *
 * With composition, a class only depends on another class's PUBLIC
 * methods/interface,
 * not its internal step-by-step logic. So internal changes to the composed
 * class
 * don't ripple out and break anything, as long as the public method signatures
 * stay the same.
 */

class Logger {
    void log(String msg) {
        System.out.println("LOG: " + msg);
    }
}

class OrderService {
    private Logger logger = new Logger(); // composition, OrderService HAS-A Logger

    void placeOrder() {
        logger.log("Order placed");
        // OrderService doesn't care HOW Logger logs internally, just calls log()
        // Logger's internals can change freely without breaking OrderService
    }
}

/*
 * Interview line: "Favor composition over inheritance means when you want to
 * reuse code,
 * default to containing an object as a field (HAS-A) rather than extending a
 * class (IS-A),
 * unless there's a genuinely strong is-a relationship that actually needs
 * polymorphism.
 * It exists because heavy inheritance creates tight coupling to a parent's
 * internal
 * implementation - known as the fragile base class problem - makes it easy to
 * violate
 * Liskov Substitution by inheriting behavior that doesn't truly fit, and locks
 * the
 * relationship at compile time. Composition only depends on the other class's
 * public
 * interface, so internal changes don't break things, and you can combine or
 * swap
 * behaviors much more flexibly."
 */

/*
 * Q6: Explain the difference between static and dynamic binding with an
 * example.
 * Answer:
 *
 * (This connects back to overloading vs overriding stuff from earlier sections,
 * but asked directly as "binding" terminology this time, so know both ways of
 * phrasing it)
 *
 * STATIC BINDING (a.k.a Compile-time binding / Early binding)
 * - The compiler decides WHICH method to call at COMPILE time itself
 * - Happens with: method overloading, private methods, static methods, final
 * methods
 * - Based on the REFERENCE TYPE (declared type), not the actual object
 *
 * DYNAMIC BINDING (a.k.a Runtime binding / Late binding)
 * - The call is resolved at RUNTIME, based on the ACTUAL OBJECT type
 * - Happens with: method overriding (instance methods that are overridden)
 * - This is what makes runtime polymorphism possible
 *
 * -----------------------------------------------------------
 * EXAMPLE showing BOTH together:
 */

class Animal {
    void sound() { // instance method - dynamic binding
        System.out.println("Some generic sound");
    }

    static void staticInfo() { // static method - static binding
        System.out.println("Animal class info");
    }
}

class Dog extends Animal {
    @Override
    void sound() {
        System.out.println("Bark");
    }

    static void staticInfo() {
        System.out.println("Dog class info");
    }
}

class BindingDemo {
    public static void main(String[] args) {
        Animal a = new Dog();

        a.sound(); // DYNAMIC binding -> "Bark" (decided at runtime, based on actual object = Dog)
        a.staticInfo(); // STATIC binding -> "Animal class info" (decided at compile time, based on
                        // reference type = Animal)
    }
}

/*
 * -----------------------------------------------------------
 * WHY this happens - the core reasoning:
 *
 * a.sound() -> JVM waits until RUNTIME, checks
 * "what object does 'a' actually point to?"
 * -> sees Dog object -> calls Dog's overridden sound(). This is dynamic
 * dispatch, the whole mechanism behind runtime polymorphism.
 *
 * a.staticInfo() -> since its static, there's no "object" involved in the
 * decision at all.
 * Compiler just looks at 'a' being DECLARED as Animal type, and directly
 * binds the call to Animal.staticInfo() at compile time itself.
 * Doesn't even check what 'a' is actually pointing to.
 *
 * -----------------------------------------------------------
 * ANOTHER SIMPLE EXAMPLE - overloading = static binding:
 */

class Calculator {
    void add(int a, int b) {
        System.out.println("int add: " + (a + b));
    }

    void add(double a, double b) {
        System.out.println("double add: " + (a + b));
    }
}

/*
 * Calculator c = new Calculator();
 * c.add(2, 3); // compiler KNOWS at compile time which add() to call (int
 * version)
 * // just by looking at argument types - no object/runtime check needed
 * // this is STATIC binding, resolved purely by method signature matching
 *
 * -----------------------------------------------------------
 * QUICK TABLE to remember:
 *
 * | Static Binding | Dynamic Binding |
 * |--------------------------|---------------------------|
 * | Compile time | Runtime |
 * | Based on reference type | Based on actual object type|
 * | Overloading, static, | Overriding (instance |
 * | private, final methods | methods) |
 * | Faster (decided early) | Slightly slower (decided |
 * | | at runtime, needs lookup) |
 *
 * Interview line: "Static binding resolves which method to call at compile
 * time, based
 * on the reference type - this is what happens with overloading, static
 * methods, private
 * and final methods. Dynamic binding resolves the method call at runtime, based
 * on the
 * actual object type - this is what happens with method overriding, and it's
 * the mechanism
 * that makes runtime polymorphism possible."
 */

/*
 * Q7: If you had to refactor a tightly-coupled class into something following
 * SOLID
 * principles, how would you approach it?
 * Answer:
 *
 * Don't just start rewriting. Say your STEPS out loud, because they want to see
 * your process. Here's how I'd say it:
 *
 * STEP 1: Find what's wrong. Ask
 * "how many reasons does this class have to change?"
 * and look for `new` keywords inside it, big if-else chains, and fat classes.
 * STEP 2: Split responsibilities -> S (Single Responsibility)
 * STEP 3: Replace if-else with polymorphism -> O (Open/Closed)
 * STEP 4: Make sure subclasses behave right -> L (Liskov Substitution)
 * STEP 5: Keep interfaces small -> I (Interface Segregation)
 * STEP 6: Depend on interfaces, inject them -> D (Dependency Inversion)
 *
 * Quick meaning of SOLID in simple words:
 * S - one class, one job
 * O - add new features by adding new code, not editing old code
 * L - child class should work anywhere the parent works, without surprises
 * I - many small interfaces are better than one giant one
 * D - depend on interfaces, not on concrete classes
 *
 * -----------------------------------------------------------
 * BEFORE: the tightly-coupled mess
 */

class MySQLDatabase {
    void save(double amount) {
        System.out.println("Saved to MySQL: " + amount);
    }
}

class GmailSender {
    void send(String msg) {
        System.out.println("Gmail sent: " + msg);
    }
}

class OrderServiceBad {
    private MySQLDatabase db = new MySQLDatabase(); // creates its own dependency
    private GmailSender mail = new GmailSender(); // same here

    void placeOrder(String customerType, double amount) {
        double finalAmount;
        if (customerType.equals("regular")) {
            finalAmount = amount;
        } else if (customerType.equals("premium")) {
            finalAmount = amount * 0.9;
        } else {
            finalAmount = amount;
        }
        db.save(finalAmount);
        mail.send("Order placed: " + finalAmount);
    }
}

/*
 * WHAT'S WRONG with it (say these out loud):
 * - S broken: one class does discount calculation, DB saving AND emailing
 * - O broken: new customer type (like "student") means editing this if-else
 * again
 * - D broken: it does `new MySQLDatabase()` and `new GmailSender()` itself,
 * so you can't switch to Postgres/SMS or test it with a fake
 *
 * -----------------------------------------------------------
 * AFTER: refactored
 *
 * Step 2 + 6: pull each job out behind an interface (small, focused = I as
 * well)
 */

interface OrderRepository {
    void save(double amount);
}

interface Notifier {
    void notify(String msg);
}

/*
 * Step 3: discount logic becomes a strategy. New customer type = new class,
 * no existing code touched (Open/Closed)
 */

interface DiscountStrategy {
    double apply(double amount);
}

class RegularDiscount implements DiscountStrategy {
    @Override
    public double apply(double amount) {
        return amount;
    }
}

class PremiumDiscount implements DiscountStrategy {
    @Override
    public double apply(double amount) {
        return amount * 0.9;
    }
}

class StudentDiscount implements DiscountStrategy { // added later, nothing else edited
    @Override
    public double apply(double amount) {
        return amount * 0.8;
    }
}

/* Concrete details live in their own classes now */

class MySQLOrderRepository implements OrderRepository {
    @Override
    public void save(double amount) {
        System.out.println("Saved to MySQL: " + amount);
    }
}

class EmailNotifier implements Notifier {
    @Override
    public void notify(String msg) {
        System.out.println("Email sent: " + msg);
    }
}

class SmsNotifier implements Notifier { // swap in with zero change to OrderService
    @Override
    public void notify(String msg) {
        System.out.println("SMS sent: " + msg);
    }
}

/*
 * The refactored service only knows interfaces, and gets them from outside
 * (constructor injection). It has one job: coordinate placing an order.
 */

class OrderService {
    private final OrderRepository repository;
    private final Notifier notifier;

    OrderService(OrderRepository repository, Notifier notifier) {
        this.repository = repository;
        this.notifier = notifier;
    }

    void placeOrder(DiscountStrategy discount, double amount) {
        double finalAmount = discount.apply(amount);
        repository.save(finalAmount);
        notifier.notify("Order placed: " + finalAmount);
    }
}

class SolidRefactorDemo {
    public static void main(String[] args) {
        OrderService service = new OrderService(new MySQLOrderRepository(), new SmsNotifier());
        service.placeOrder(new PremiumDiscount(), 1000);
        service.placeOrder(new StudentDiscount(), 1000);
    }
}

/*
 * HOW EACH PRINCIPLE SHOWS UP NOW:
 * S - OrderService only coordinates. Saving, notifying, discounting each have
 * their own class.
 * O - new discount type = new class. OrderService never changes.
 * L - any DiscountStrategy or Notifier can replace another without breaking
 * OrderService.
 * (This only holds if each implementation really honors the contract, e.g. a
 * Notifier that throws "not supported" would break LSP.)
 * I - Notifier and OrderRepository each have just one method, so nobody is
 * forced
 * to implement stuff they don't need.
 * D - OrderService depends on interfaces, concrete classes are plugged in from
 * outside.
 * Bonus: in testing you can pass a fake repository and fake notifier.
 *
 * Tip: don't say "I'd apply all 5 blindly." Say "I'd apply them only where the
 * pain is real," because over-engineering is also a red flag.
 *
 * Interview line: "I'd first find the pain points: classes with multiple
 * reasons to change,
 * `new` keywords inside the class, and big if-else chains. Then I'd split
 * responsibilities
 * into separate classes (SRP), replace the if-else with a strategy so new cases
 * are added
 * without editing old code (OCP), make sure implementations are truly
 * substitutable (LSP),
 * keep interfaces small (ISP), and finally depend on interfaces and inject them
 * through
 * the constructor (DIP). The result is loosely coupled, easy to extend and easy
 * to test."
 */

/*
 * Q8: What's the Open/Closed Principle (from SOLID), and how does abstraction
 * help you satisfy it?
 * Answer:
 *
 * (Q7 showed OCP in action with the discount strategy. Here they want the
 * principle itself explained, plus the link to abstraction.)
 *
 * WHAT IT MEANS, in simple words:
 * A class should be OPEN for extension but CLOSED for modification.
 * - Open for extension: you can add new behavior
 * - Closed for modification: you do it WITHOUT editing old, working, tested
 * code
 *
 * Why it matters: every time you edit old code, you risk breaking something
 * that
 * was already working. Better to add new code and leave the old stuff alone.
 *
 * -----------------------------------------------------------
 * VIOLATING it: the classic if-else on type
 */

class AreaCalculatorBad {
    double calculateArea(String shape, double a, double b) {
        if (shape.equals("circle")) {
            return 3.14 * a * a;
        } else if (shape.equals("rectangle")) {
            return a * b;
        }
        return 0;
        // Want to add a triangle? You must EDIT this method again.
        // That's modification, which is what OCP says to avoid.
    }
}

/*
 * -----------------------------------------------------------
 * FOLLOWING it: use abstraction
 *
 * Step 1: make an abstraction (interface or abstract class) for the thing that
 * varies.
 * Step 2: each variation becomes its own class.
 * Step 3: the calculator depends only on the abstraction.
 */

interface Shape {
    double area();
}

class Circle implements Shape {
    private double radius;

    Circle(double radius) {
        this.radius = radius;
    }

    @Override
    public double area() {
        return 3.14 * radius * radius;
    }
}

class Rectangle implements Shape {
    private double width;
    private double height;

    Rectangle(double width, double height) {
        this.width = width;
        this.height = height;
    }

    @Override
    public double area() {
        return width * height;
    }
}

class AreaCalculator {
    double totalArea(Shape[] shapes) {
        double total = 0;
        for (Shape s : shapes) {
            total += s.area(); // doesn't care which shape, just calls area()
        }
        return total;
    }
}

/*
 * Now add a Triangle later, just write a NEW class. AreaCalculator is
 * untouched.
 */

class Triangle implements Shape {
    private double base;
    private double height;

    Triangle(double base, double height) {
        this.base = base;
        this.height = height;
    }

    @Override
    public double area() {
        return 0.5 * base * height;
    }
}

class OcpDemo {
    public static void main(String[] args) {
        Shape[] shapes = { new Circle(5), new Rectangle(4, 6), new Triangle(3, 8) };
        AreaCalculator calc = new AreaCalculator();
        System.out.println(calc.totalArea(shapes));
    }
}

/*
 * -----------------------------------------------------------
 * HOW ABSTRACTION HELPS (the actual link they're asking for):
 *
 * 1. Abstraction gives the calculator a stable contract (area()). The
 * calculator
 * only depends on that contract, never on concrete shapes, so it never needs to
 * change.
 *
 * 2. Extension happens by adding new implementations of the abstraction.
 * That's the "open for extension" part.
 *
 * 3. Polymorphism does the work at runtime. s.area() calls the right version
 * based
 * on the actual object, so no if-else is needed. The if-else chain is the usual
 * red flag that OCP is being violated.
 *
 * Simple way to remember: if you keep editing the same class every time a new
 * "type" or "case" comes in, that's an OCP smell. Fix = find what varies, put
 * it
 * behind an abstraction.
 *
 * Small honest note: you can never make a class 100% closed to every possible
 * change.
 * You pick the likely points of change (new shapes, new payment types) and
 * abstract those. Mentioning this shows you're not applying it blindly.
 *
 * Interview line: "Open/Closed Principle says a class should be open for
 * extension but
 * closed for modification, meaning you add new behavior by writing new code,
 * not by
 * editing existing tested code. Abstraction helps because you put the varying
 * part
 * behind an interface or abstract class, the main code depends only on that
 * abstraction, and new cases are added as new implementations. Polymorphism
 * then picks
 * the right behavior at runtime, so you avoid growing if-else chains."
 */

/*
 * Q9: What is a "God class" / God object anti-pattern, and how does OOP help
 * avoid it?
 * Answer:
 *
 * WHAT IT IS, in simple words:
 * A God class is one giant class that knows too much and does too much. It
 * handles
 * a bit of everything: business logic, database stuff, validation, emailing,
 * formatting, you name it. Everything else in the app ends up depending on it.
 *
 * How to spot one:
 * - Hundreds or thousands of lines
 * - Tons of unrelated fields and methods
 * - Class name is vague, like Manager, Helper, Utils, SystemController
 * - Changing one small thing risks breaking something totally unrelated
 *
 * WHY it's bad:
 * 1. Breaks Single Responsibility. The class has many reasons to change.
 * 2. Hard to understand, test and debug, since everything is tangled together.
 * 3. Tight coupling. Other classes depend on this one blob.
 * 4. Teams step on each other, because everyone edits the same file (merge
 * conflicts).
 * 5. Can't reuse a small part of it without dragging the whole thing along.
 *
 * -----------------------------------------------------------
 * EXAMPLE of a God class:
 */

class ShopManager {
    void addProduct(String name, double price) {
        /* inventory logic */ }

    void removeProduct(String name) {
        /* inventory logic */ }

    void registerCustomer(String name, String email) {
        /* customer logic */ }

    boolean validateEmail(String email) {
        return email.contains("@");
    }

    double calculateDiscount(String customerType, double amount) {
        return amount;
    }

    double calculateTax(double amount) {
        return amount * 0.18;
    }

    void saveOrderToDatabase(String order) {
        /* db logic */ }

    void sendConfirmationEmail(String email, String msg) {
        /* email logic */ }

    String generateInvoicePdf(String order) {
        return "pdf";
    }
}

/*
 * One class doing inventory, customers, pricing, database, email and invoices.
 * That's the anti-pattern.
 *
 * -----------------------------------------------------------
 * HOW OOP HELPS AVOID IT:
 *
 * 1. ENCAPSULATION + CLASSES: model each real concept as its own class, with
 * its
 * own data and behavior together. (Product, Customer, Order, Invoice...)
 *
 * 2. ABSTRACTION: put things like database and email behind interfaces, so the
 * core logic doesn't need to know the details.
 *
 * 3. SINGLE RESPONSIBILITY (from SOLID): each class gets one job.
 *
 * 4. COMPOSITION: small classes get combined to do bigger work, instead of one
 * class doing everything. (A class that only coordinates is fine, as long as
 * the real work stays inside the small classes.)
 *
 * 5. INHERITANCE / POLYMORPHISM: shared stuff goes in parents or interfaces,
 * different variations become their own classes instead of if-else inside one
 * blob.
 *
 * -----------------------------------------------------------
 * REFACTORED: split by responsibility
 */

class Product {
    private String name;
    private double price;

    Product(String name, double price) {
        this.name = name;
        this.price = price;
    }

    double getPrice() {
        return price;
    }
}

class Customer {
    private String name;
    private String email;

    Customer(String name, String email) {
        this.name = name;
        this.email = email;
    }

    String getEmail() {
        return email;
    }
}

class PriceCalculator {
    double calculateTax(double amount) {
        return amount * 0.18;
    }
}

interface OrderStorage {
    void save(String order);
}

interface EmailService {
    void send(String to, String msg);
}

class InvoiceGenerator {
    String generate(String order) {
        return "Invoice for " + order;
    }
}

class CheckoutService {
    private final PriceCalculator priceCalculator;
    private final OrderStorage storage;
    private final EmailService emailService;

    CheckoutService(PriceCalculator priceCalculator, OrderStorage storage, EmailService emailService) {
        this.priceCalculator = priceCalculator;
        this.storage = storage;
        this.emailService = emailService;
    }

    void checkout(Customer customer, Product product) {
        double total = product.getPrice() + priceCalculator.calculateTax(product.getPrice());
        storage.save("Order total: " + total);
        emailService.send(customer.getEmail(), "Order confirmed: " + total);
    }
}

/*
 * Now each class has one clear job. CheckoutService just coordinates. Want to
 * change
 * how emails are sent? Touch only the EmailService implementation. Want to test
 * checkout? Pass fake storage and fake email. Two developers can work on
 * different
 * classes without clashing.
 *
 * Quick rule of thumb: if you struggle to describe what a class does without
 * using the word "and" a lot, it's probably heading toward God class territory.
 *
 * Interview line: "A God class is a giant class that knows and does too much,
 * mixing
 * unrelated responsibilities like business logic, database access and emailing.
 * It's an
 * anti-pattern because it's hard to test, hard to change and tightly coupled to
 * everything. OOP helps avoid it by letting me model each concept as its own
 * class
 * with a single responsibility, hide details behind abstractions like
 * interfaces, and
 * combine small classes through composition, so no single class becomes the
 * center
 * of everything."
 */

/*
 * Q10: Explain the diamond problem and how Java's interface-only multiple
 * inheritance avoids it.
 * Answer:
 *
 * (You already saw this in Section 2 Q5. Here they want it as the main
 * question,
 * and the key phrase is "interface-only", so focus on WHY interfaces are safe.)
 *
 * WHAT THE DIAMOND PROBLEM IS, in simple words:
 * If a class could extend TWO classes that both inherit from the same
 * grandparent,
 * and both parents changed (overrode) the same method, then the bottom class
 * would get two different versions of that method. Java would have no way to
 * know
 * which one to use. That's the ambiguity.
 *
 * ClassA
 * show() -> "A"
 * / \
 * ClassB ClassC
 * show() -> "B" show() -> "C"
 * \ /
 * ClassD <-- extends B and C? Which show() does D get?
 *
 * Java's answer: a class can extend only ONE class. So this shape is simply
 * not possible with classes. The code below does NOT compile:
 *
 * class D extends B, C { } // COMPILE ERROR
 *
 * -----------------------------------------------------------
 * WHY INTERFACES ARE ALLOWED TO DO IT:
 *
 * 1. Plain abstract methods have no body, so there's nothing to conflict.
 * If two interfaces both declare move(), the class writes ONE move()
 * and that satisfies both. No ambiguity.
 *
 * 2. Interfaces have no instance state (fields are just constants), and no
 * constructors, so there's no "which parent's data/constructor" confusion
 * either.
 *
 * 3. Since Java 8, interfaces can have default methods (with a body), so the
 * diamond CAN technically appear. But Java has clear rules to settle it:
 *
 * Rule 1: Class wins. If a class in the hierarchy defines the method, that
 * beats any interface default.
 * Rule 2: More specific interface wins. If one interface extends the other and
 * overrides the default, the sub-interface's version is used.
 * Rule 3: If still unclear, COMPILE ERROR. You must override the method in your
 * class and explicitly pick one using InterfaceName.super.method().
 *
 * So Java never silently guesses. Either the rules decide it clearly, or it
 * forces YOU to decide.
 *
 * -----------------------------------------------------------
 * THE DIAMOND WITH INTERFACES, in code:
 */

interface Greeter {
    default void show() {
        System.out.println("Greeter show");
    }
}

interface FriendlyGreeter extends Greeter {
    @Override
    default void show() {
        System.out.println("FriendlyGreeter show");
    }
}

interface FormalGreeter extends Greeter {
    @Override
    default void show() {
        System.out.println("FormalGreeter show");
    }
}

/*
 * Both sub-interfaces overrode show(). Now a class implements both. This is
 * the exact diamond shape. Java refuses to guess, so the class MUST resolve it:
 */

class Person implements FriendlyGreeter, FormalGreeter {
    @Override
    public void show() {
        FriendlyGreeter.super.show(); // explicitly pick one
        FormalGreeter.super.show(); // or call both, or write fresh logic
    }
}

/*
 * If Person did NOT override show(), the compiler error would be something
 * like:
 * "class Person inherits unrelated defaults for show() from types
 * FriendlyGreeter and FormalGreeter".
 *
 * -----------------------------------------------------------
 * RULE 2 in action (no conflict, more specific wins):
 */

interface Base {
    default void hello() {
        System.out.println("Base hello");
    }
}

interface Specific extends Base {
    @Override
    default void hello() {
        System.out.println("Specific hello");
    }
}

class Worker implements Base, Specific {
    // no override needed, Specific is more specific than Base, so it wins
}

class DiamondDemo {
    public static void main(String[] args) {
        new Person().show();
        new Worker().hello(); // prints "Specific hello"
    }
}

/*
 * Easy way to remember:
 * - Classes: only one parent, so the diamond can't even be drawn
 * - Interfaces: can have many parents, and if there's a real clash, the
 * compiler
 * makes you resolve it explicitly instead of guessing
 *
 * Interview line: "The diamond problem is when a class inherits the same method
 * from
 * two parents that both derive from a common ancestor, so it's unclear which
 * version
 * to use. Java avoids it for classes by allowing only single inheritance.
 * Interfaces
 * can be implemented multiple times because abstract methods have no body to
 * conflict,
 * and interfaces carry no instance state. With default methods the clash can
 * still
 * happen, but Java handles it with clear rules, class wins, then the more
 * specific
 * interface, and otherwise a compile error that forces me to override the
 * method and
 * pick one explicitly using Interface.super.method()."
 */

/*
 * Q11: What's the difference between shallow copy and deep copy of an object?
 * Answer:
 *
 * The whole difference is what happens to the REFERENCE fields (fields that
 * point
 * to other objects) inside the object you're copying.
 *
 * SHALLOW COPY
 * - Creates a new outer object, copies each field's value as it is.
 * - Primitives (int, double...) get copied properly, no issue.
 * - But for reference fields, only the ADDRESS gets copied, not the actual
 * object.
 * So the original and the copy both point to the SAME inner object (shared).
 * - Change the inner object through one, the other sees the change too.
 *
 * DEEP COPY
 * - Creates a new outer object AND new copies of all the inner objects too (all
 * the
 * way down).
 * - Original and copy are fully independent. Change one, the other stays
 * untouched.
 *
 * Real life way to say it: shallow copy is like photocopying a page that says
 * "see the file in cabinet #5". Both pages point to the same file. Deep copy is
 * like photocopying the page AND the file, so everyone has their own.
 *
 * Also note: `Employee b = a;` is NOT a copy at all. It just gives the same
 * object
 * a second name. Both a and b are the same object.
 *
 * -----------------------------------------------------------
 * EXAMPLE: Employee has-a Address
 */

class Address {
    String city;

    Address(String city) {
        this.city = city;
    }

    Address(Address other) { // copy constructor, makes a fresh Address
        this.city = other.city;
    }
}

class Employee {
    String name;
    Address address;

    Employee(String name, Address address) {
        this.name = name;
        this.address = address;
    }

    // SHALLOW: reuses the same Address object
    static Employee shallowCopy(Employee e) {
        return new Employee(e.name, e.address);
    }

    // DEEP: builds a brand new Address too
    static Employee deepCopy(Employee e) {
        return new Employee(e.name, new Address(e.address));
    }
}

class CopyDemo {
    public static void main(String[] args) {
        Employee original = new Employee("Ravi", new Address("Goa"));

        Employee shallow = Employee.shallowCopy(original);
        shallow.address.city = "Mumbai";
        System.out.println(original.address.city); // Mumbai <- original got changed!

        Employee original2 = new Employee("Ravi", new Address("Goa"));
        Employee deep = Employee.deepCopy(original2);
        deep.address.city = "Mumbai";
        System.out.println(original2.address.city); // Goa <- original is safe
    }
}

/*
 * Why original changed in the shallow case: shallow.address and
 * original.address
 * are the same Address object, so changing city through one shows up in the
 * other.
 *
 * Note on Strings: `name` is a String, and Strings are immutable, so sharing
 * them
 * in a shallow copy is totally safe. The danger is only with MUTABLE reference
 * fields (other objects, arrays, lists...).
 *
 * -----------------------------------------------------------
 * HOW TO MAKE COPIES IN JAVA:
 *
 * 1. Copy constructor (shown above). Simple and clear, most recommended.
 * 2. clone() method. The default Object.clone() is SHALLOW. For a deep copy you
 * have to override it and clone the inner objects yourself. Also the class must
 * implement Cloneable. Many people avoid it because it's awkward.
 * 3. Serialization: write the object to a stream and read it back, which
 * creates a
 * full deep copy (slow, and needs Serializable).
 * 4. Libraries like Jackson or Apache Commons Lang (SerializationUtils.clone).
 *
 * Gotcha to mention: most built-in collection copies are shallow. For example
 * `new ArrayList<>(list)` gives a new list, but the elements inside are still
 * the same objects as in the original list.
 *
 * When to use which:
 * - Shallow: fine when inner objects are immutable, or sharing is intended.
 * - Deep: when you need a fully independent copy that can be changed safely.
 *
 * Interview line: "Shallow copy creates a new object but copies the references
 * of any
 * inner objects, so the original and the copy share them, and changing an inner
 * object
 * through one affects the other. Deep copy also creates new copies of the inner
 * objects, so the two are completely independent. In Java, the default clone()
 * is
 * shallow, so for a deep copy I'd use a copy constructor or override clone() to
 * copy
 * the mutable fields as well."
 */

/*
 * Q12: How does Java's garbage collector interact with objects that no longer
 * have any references?
 * Answer:
 *
 * SIMPLE VERSION:
 * Java manages heap memory for you. When an object can no longer be reached by
 * any part of the running program, the garbage collector (GC) is free to delete
 * it and reclaim that memory. You never free objects yourself, unlike C/C++.
 *
 * KEY POINT (interviewers like this): GC doesn't really count references.
 * It checks REACHABILITY. It starts from GC ROOTS and follows references.
 * Anything it can reach is alive. Anything it can't reach is garbage.
 *
 * GC roots are things like:
 * - local variables on the stack of running threads
 * - static fields
 * - active threads themselves
 * - JNI references
 *
 * -----------------------------------------------------------
 * HOW AN OBJECT BECOMES UNREACHABLE:
 */

class Demo {
    static void example() {
        // 1. Reassigning the reference
        StringBuilder a = new StringBuilder("first");
        a = new StringBuilder("second"); // "first" has no reference now, eligible for GC

        // 2. Setting to null
        StringBuilder b = new StringBuilder("hello");
        b = null; // object is now unreachable

        // 3. Going out of scope
        {
            StringBuilder c = new StringBuilder("temp");
        } // c is gone after the block, object unreachable

        // 4. Anonymous object, never stored anywhere
        new StringBuilder("nobody holds me"); // unreachable right after this line
    }
}

/*
 * Important: "eligible for GC" does NOT mean "deleted immediately". The GC runs
 * when the JVM decides to (usually when memory is getting filled). You don't
 * control the exact moment.
 *
 * -----------------------------------------------------------
 * WHAT ABOUT CIRCULAR REFERENCES? (common follow-up)
 * Since GC uses reachability and not reference counting, cycles are NOT a
 * problem.
 */

class Node {
    Node other;
}

class CycleDemo {
    static void make() {
        Node x = new Node();
        Node y = new Node();
        x.other = y;
        y.other = x; // x and y point to each other
    } // after the method ends, nothing from a root reaches either,
      // so BOTH get collected even though they reference each other
}

/*
 * (This is called an "island of isolation". Reference-counting systems would
 * leak
 * it, Java's GC doesn't.)
 *
 * -----------------------------------------------------------
 * WHAT GC ACTUALLY DOES, step by step:
 * 1. MARK: start from the roots, mark every reachable object as alive.
 * 2. SWEEP: free the memory of everything not marked.
 * 3. COMPACT (in many collectors): move live objects together so free memory
 * isn't
 * scattered in small gaps.
 *
 * GENERATIONAL IDEA (worth mentioning):
 * Most objects die young, so the heap is split into regions:
 * - Young generation (Eden + survivor spaces): new objects start here. Cleaned
 * often and quickly (minor GC). Objects that survive a few rounds get promoted.
 * - Old generation: long-lived objects. Cleaned less often, but a cleanup is
 * more
 * expensive (major / full GC).
 * This makes GC efficient, because it focuses on the area where most garbage
 * is.
 *
 * Also: GC may briefly pause your application threads ("stop-the-world") during
 * some phases. Modern collectors (G1, which is the default in recent Java
 * versions,
 * and ZGC) work hard to keep these pauses very short.
 *
 * -----------------------------------------------------------
 * THINGS PEOPLE GET WRONG (good to mention):
 *
 * 1. System.gc() is only a REQUEST. The JVM can ignore it. Don't rely on it.
 *
 * 2. finalize() is NOT a good cleanup tool. It's deprecated, runs at
 * unpredictable
 * times, may not run at all. For cleanup of files, sockets, DB connections, use
 * try-with-resources instead (shown below).
 *
 * 3. GC only handles MEMORY. Other resources (files, network, DB connections)
 * must be closed by you.
 *
 * 4. Memory leaks can STILL happen in Java. If you keep a reference to
 * something
 * you no longer need, it stays reachable, so GC can't touch it.
 */

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

class LeakDemo {
    private static final List<byte[]> cache = new ArrayList<>(); // static = root, lives forever

    static void leak() {
        cache.add(new byte[1024 * 1024]); // never removed, GC can never free it
    }
}

class ResourceDemo {
    static void read(String path) throws IOException {
        try (BufferedReader reader = new BufferedReader(new FileReader(path))) {
            System.out.println(reader.readLine());
        } // reader is closed automatically here, we don't wait on GC for this
    }
}

/*
 * Interview line: "The garbage collector automatically frees heap memory of
 * objects that
 * are no longer reachable. It doesn't count references, it starts from GC roots
 * like
 * local variables, static fields and active threads, marks everything
 * reachable, and
 * reclaims the rest, so even circular references get cleaned up. An object
 * becomes
 * eligible when it's reassigned, set to null, or goes out of scope, but the
 * exact timing
 * is decided by the JVM, and System.gc() is only a hint. Memory leaks can still
 * happen if
 * I accidentally keep references, for example in a static collection, and
 * non-memory
 * resources like files should be closed with try-with-resources, not left to
 * GC."
 */

/*
 * Q13: What is the `this` keyword used for, beyond just field name conflicts?
 * Answer:
 *
 * SIMPLE VERSION:
 * `this` is a reference to the CURRENT object, the one whose method or
 * constructor
 * is running right now. Everyone knows the name conflict use (this.name =
 * name).
 * The interviewer wants to see that you know the OTHER uses too.
 *
 * -----------------------------------------------------------
 * USE 1: Fix the name conflict (the basic one, quick recap)
 */

class Student {
    private String name;
    private int age;

    Student(String name, int age) {
        this.name = name; // left = field, right = parameter
        this.age = age;
    }

    /*
     * -----------------------------------------------------------
     * USE 2: Call another constructor of the SAME class: this(...)
     * (constructor chaining, from Section 2 Q7)
     * Must be the first line of the constructor.
     */

    Student() {
        this("Unknown", 18); // reuses the constructor above, no duplicate code
    }

    /*
     * -----------------------------------------------------------
     * USE 3: Return the current object, for METHOD CHAINING
     * Each setter returns `this`, so you can chain calls in one line.
     */

    Student setName(String name) {
        this.name = name;
        return this;
    }

    Student setAge(int age) {
        this.age = age;
        return this;
    }

    void print() {
        System.out.println(name + " - " + age);
    }

    /*
     * -----------------------------------------------------------
     * USE 4: Pass the current object as an argument to another method or class
     * "Here, take ME and do something with me."
     */

    void register(Registry registry) {
        registry.add(this); // hands the current Student object to the registry
    }
}

class Registry {
    void add(Student s) {
        System.out.println("Student registered");
    }
}

class ThisDemo {
    public static void main(String[] args) {
        // method chaining thanks to `return this`
        new Student().setName("Ravi").setAge(22).print();

        new Student("Anu", 20).register(new Registry());
    }
}

/*
 * -----------------------------------------------------------
 * USE 5: Refer to the OUTER object from an inner class: Outer.this
 * Inside an inner class, plain `this` means the inner object. To reach the
 * outer
 * object, you write OuterClassName.this
 */

class Outer {
    private String label = "outer";

    class Inner {
        private String label = "inner";

        void show() {
            System.out.println(label); // inner
            System.out.println(this.label); // inner (current Inner object)
            System.out.println(Outer.this.label); // outer (the enclosing Outer object)
        }
    }
}

/*
 * -----------------------------------------------------------
 * USE 6: Call another instance method of the same object explicitly
 * Optional, `this.helper()` and `helper()` do the same thing. Some people write
 * it for readability, but it's not required.
 *
 * -----------------------------------------------------------
 * USE 7: Inside a lambda, `this` means the ENCLOSING object
 * This is a nice gotcha. In an anonymous class, `this` is the anonymous object.
 * In a lambda, `this` is still the surrounding class's object.
 */

class LambdaThisDemo {
    private String name = "LambdaThisDemo object";

    void run() {
        Runnable lambda = () -> System.out.println(this.name); // refers to LambdaThisDemo

        Runnable anon = new Runnable() {
            @Override
            public void run() {
                // `this` here is the anonymous Runnable object, not LambdaThisDemo
                System.out.println(this.getClass().getName().contains("$"));
            }
        };

        lambda.run();
        anon.run();
    }
}

/*
 * -----------------------------------------------------------
 * RULES AND GOTCHAS:
 *
 * 1. `this` does NOT exist in a static context. Static methods belong to the
 * class,
 * not to any object, so there's no "current object". Using this in a static
 * method gives a compile error.
 *
 * 2. this(...) must be the FIRST statement in a constructor, and you can't use
 * this(...) and super(...) together in the same constructor.
 *
 * 3. Be careful about passing `this` out of a constructor (like
 * registry.add(this)
 * inside the constructor). The object isn't fully built yet, so other code
 * might
 * see it half-initialized. Fine in normal methods, risky inside constructors.
 *
 * 4. `this` is a reference, you can't reassign it (this = something is not
 * allowed).
 *
 * Quick summary of all uses:
 * - this.field -> access own field (name conflict fix)
 * - this(...) -> call another constructor in the same class
 * - return this -> method chaining
 * - pass this -> give current object to another method/class
 * - Outer.this -> reach the outer object from an inner class
 *
 * Interview line: "`this` refers to the current object. Apart from separating
 * fields from
 * parameters with the same name, I use it to call another constructor of the
 * same class
 * with this(...), to return the current object for method chaining like in
 * builders, and
 * to pass the current object to another method or class. In inner classes,
 * Outer.this
 * gives me the enclosing object, and it can't be used in static methods because
 * there's
 * no current object there."
 */

/*
 * Q14: How would you decide whether a new class should extend an existing one
 * or just
 * implement an interface?
 * Answer:
 *
 * (This ties together Section 2 Q8 (abstract class vs interface) and Section 4
 * Q4/Q5
 * (composition vs inheritance). Here they want to hear your DECISION PROCESS,
 * so ask
 * yourself these questions in order and say them out loud.)
 *
 * QUESTION 1: Is it a true IS-A relationship?
 * Say the sentence: "X is a Y". Does it sound natural, and does X behave like Y
 * in
 * every situation? If not, don't extend.
 *
 * QUESTION 2: Do I want to reuse code or state from the existing class?
 * Extending gives you its fields and method bodies. An interface only gives you
 * a
 * contract (what to do, not how). If I want the actual code, extend (or use
 * composition).
 *
 * QUESTION 3: Or do I just want to promise a capability?
 * If I only want the class to be able to do something (fly, compare, run),
 * interface.
 * Unrelated classes can share the same interface.
 *
 * QUESTION 4: Does the class already have a parent?
 * Java allows only ONE extended class. If I'm already extending something,
 * interface
 * is the only way to add more abilities.
 *
 * QUESTION 5: Can the existing class even be extended, and is it safe to?
 * If it's final, I can't. If it wasn't designed for extension, I'm tied to its
 * internals (fragile base class problem). Then I'd prefer an interface plus
 * composition.
 *
 * QUESTION 6: Can everything that works with the parent also work with my
 * class?
 * (Liskov Substitution.) If my class would break or throw "not supported" for
 * some
 * inherited method, it shouldn't extend.
 *
 * -----------------------------------------------------------
 * EXAMPLE: extend for shared state, interface for abilities
 */

interface Flyable {
    void fly();
}

abstract class LivingThing {
    protected String name;

    LivingThing(String name) {
        this.name = name;
    }

    void breathe() {
        System.out.println(name + " is breathing");
    }
}

// Sparrow IS-A LivingThing (extend, reuse name + breathe) and CAN fly
// (interface)
class Sparrow extends LivingThing implements Flyable {
    Sparrow(String name) {
        super(name);
    }

    @Override
    public void fly() {
        System.out.println(name + " flaps wings and flies");
    }
}

// Airplane is NOT a LivingThing, but it can fly. Only an interface fits here.
class Airplane implements Flyable {
    @Override
    public void fly() {
        System.out.println("Airplane flies using engines");
    }
}

// Penguin IS-A LivingThing but can't fly, so it simply doesn't implement
// Flyable
class Penguin extends LivingThing {
    Penguin(String name) {
        super(name);
    }
}

class DecisionDemo {
    static void launch(Flyable f) { // works for ANY flying thing, related or not
        f.fly();
    }

    public static void main(String[] args) {
        launch(new Sparrow("Sparrow"));
        launch(new Airplane());
    }
}

/*
 * WHY the interface was the right call for flying:
 * If I had put fly() inside LivingThing, Penguin would inherit a method that
 * doesn't
 * make sense for it. That's the Liskov violation from Question 6. Making flying
 * an
 * interface lets only the classes that can really fly sign up for it.
 *
 * -----------------------------------------------------------
 * REAL JAVA MISTAKE to mention (interviewers love this):
 * `Stack` extends `Vector` in the JDK. A stack should only push/pop/peek, but
 * because
 * of inheritance it also exposes Vector methods like insertElementAt(), so
 * someone can
 * insert in the middle of a "stack" and break the idea of a stack. A Stack is
 * not
 * really a Vector. Composition would have been the better choice:
 */

class SimpleStack<T> {
    private final java.util.ArrayList<T> items = new java.util.ArrayList<>(); // HAS-A list

    void push(T item) {
        items.add(item);
    }

    T pop() {
        return items.remove(items.size() - 1);
    }

    boolean isEmpty() {
        return items.isEmpty();
    }
    // outside code can't touch the middle, only push/pop/isEmpty are exposed
}

/*
 * -----------------------------------------------------------
 * THE BEST OF BOTH, when it fits: interface + abstract class together
 * - The interface defines the contract.
 * - An abstract class gives a partial default implementation.
 * - Classes can extend the abstract class for convenience, or implement the
 * interface
 * directly if they already have a parent. (Java's List and AbstractList work
 * this way.)
 *
 * QUICK CHEAT SHEET:
 * - Strong IS-A + shared code/state + no other parent -> extend
 * - Capability / contract, unrelated classes -> implement interface
 * - Want to reuse behavior but it's not a true IS-A -> interface + composition
 * - Need both a contract and shared defaults -> interface + abstract class
 * - Not sure -> interface (easier to change later,
 * because inheritance locks you in)
 *
 * Interview line: "I first check if it's a true IS-A relationship where the new
 * class can
 * be used anywhere the parent is used, and whether I actually want to reuse the
 * parent's
 * code and state. If yes, I extend. If I only want to promise a capability, or
 * the classes
 * are unrelated, or I already extend another class, I implement an interface,
 * since Java
 * allows only single class inheritance. When I want to reuse behavior without a
 * real
 * IS-A, I use an interface plus composition, because inheritance creates tight
 * coupling.
 * If I'm unsure, I lean towards the interface, since it's easier to change
 * later."
 */

/*
 * Q15: Describe a real bug you've hit involving inheritance or polymorphism,
 * and how you found/fixed it.
 * Answer:
 *
 * This is a BEHAVIORAL question, not a theory one. They want a real story from
 * YOUR
 * experience, and I haven't debugged anything in your projects, so I can't give
 * you
 * a "real" bug of yours. If I invented one, the interviewer would ask
 * follow-ups
 * (which project? what did the stack trace say?) and it would fall apart.
 *
 * So here's what I can do:
 * 1. Give you the STRUCTURE to tell any bug story well.
 * 2. Give you a classic inheritance bug that you can run on your own machine,
 * so
 * when you tell it, it's genuinely something you've seen and fixed.
 *
 * -----------------------------------------------------------
 * STRUCTURE (say it in this order, about 1 minute total):
 * 1. Context - what were you building (1 line)
 * 2. Symptom - what went wrong, what did you see
 * 3. Debugging - how you tracked it down (this is what they care about most)
 * 4. Root cause - the OOP concept behind it
 * 5. Fix - what you changed
 * 6. Lesson - what you do differently now
 *
 * -----------------------------------------------------------
 * THE BUG: calling an overridable method from a parent constructor
 *
 * Symptom: NullPointerException (or a field mysteriously being null/0) inside a
 * subclass method, even though the field is clearly initialized in the
 * subclass.
 */

import java.util.ArrayList;
import java.util.List;

class Report {
    Report() {
        System.out.println("Report constructor running");
        init(); // calls an overridable method from the constructor
    }

    void init() {
        System.out.println("Report init");
    }
}

class SalesReport extends Report {
    private List<String> rows = new ArrayList<>(); // initialized AFTER parent constructor finishes
    private String title = "Sales";

    SalesReport() {
        super(); // parent constructor runs first
        System.out.println("SalesReport constructor running, title = " + title);
    }

    @Override
    void init() {
        System.out.println("SalesReport init, title = " + title); // prints null!
        rows.add("header"); // NullPointerException!
    }
}

class BugDemo {
    public static void main(String[] args) {
        new SalesReport(); // crashes with NullPointerException
    }
}

/*
 * -----------------------------------------------------------
 * HOW YOU'D FIND IT (the debugging part of your story):
 * 1. The stack trace points to init() in SalesReport, at rows.add(...). But
 * rows
 * "obviously" has a value, so that looks impossible at first.
 * 2. Put a breakpoint or print statements in both constructors and the init()
 * method.
 * 3. The output order shows the surprise:
 * Report constructor running
 * SalesReport init, title = null <-- title is still null here!
 * So init() runs BEFORE the subclass fields are initialized.
 *
 * ROOT CAUSE:
 * Object creation order in Java is:
 * 1. Parent constructor runs first
 * 2. THEN the child's field initializers run
 * 3. THEN the rest of the child's constructor body runs
 * Because of runtime polymorphism, the parent constructor's call to init() goes
 * to
 * the CHILD's override, but the child's fields haven't been set up yet (they're
 * still
 * null/0/false). So the overridden method runs on a half-built object.
 *
 * -----------------------------------------------------------
 * THE FIX (any one of these):
 *
 * Fix 1: Don't call overridable methods from constructors. Make init() private
 * or
 * final, so it can't be overridden.
 */

class ReportFixed {
    ReportFixed() {
        init();
    }

    private void init() { // private = cannot be overridden, no surprise
        System.out.println("ReportFixed init");
    }
}

/*
 * Fix 2: Let the child do its own setup, and call setup after construction is
 * done
 * (for example through a factory method).
 */

class ReportBase {
    void init() {
        System.out.println("ReportBase init");
    }
}

class SalesReportFixed extends ReportBase {
    private final List<String> rows = new ArrayList<>();

    private SalesReportFixed() {
    }

    static SalesReportFixed create() {
        SalesReportFixed r = new SalesReportFixed();
        r.init(); // called AFTER the object is fully built
        return r;
    }

    @Override
    void init() {
        rows.add("header"); // safe now, rows already exists
    }
}

/*
 * -----------------------------------------------------------
 * LESSON (end your story with this):
 * Never call an overridable method from a constructor, because the subclass
 * version
 * can run before the subclass is fully initialized. Mark such helper methods
 * private
 * or final, or move the setup out of the constructor.
 *
 * -----------------------------------------------------------
 * OTHER BUGS you could use instead (pick whichever you've actually seen or can
 * reproduce yourself):
 * - equals() overridden without hashCode(), duplicates in a HashSet
 * (Section 3 Q9 has the full example)
 * - static method "overridden" in the child, parent version kept running
 * (Section 3 Q4)
 * - ClassCastException from a wrong downcast, fixed with instanceof
 * (Section 3 Q10)
 * - Typo in an override, method didn't override at all, parent version ran.
 * Fixed by
 * adding @Override so the compiler catches it next time.
 *
 * IF YOU HAVE NO REAL STORY: it's fine to be honest. Say "In my practice
 * projects I
 * ran into this one," and then tell the constructor bug above. Interviewers
 * respect a
 * clearly explained bug you reproduced and understood far more than a vague "I
 * never
 * really had bugs" answer.
 *
 * Interview line (adapt to your own words and project): "In a practice project
 * I had a
 * base class whose constructor called an init() method that a subclass
 * overrode. The
 * subclass version threw a NullPointerException on a field that looked
 * initialized. I
 * added prints in both constructors and saw the overridden method was running
 * before the
 * subclass fields were initialized, because the parent constructor runs first.
 * I fixed
 * it by making the method private so it couldn't be overridden, and now I avoid
 * calling
 * overridable methods from constructors."
 */