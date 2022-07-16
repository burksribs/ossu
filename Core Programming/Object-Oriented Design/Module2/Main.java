import java.sql.Date;
import java.util.ArrayList;

public class Main {
	
	/* Abstraction */
	
	public class Food {
		public String groceryID;
		public String name;
		public String manufacturer;
		public Date expiryDate;
		public double price;
		
		public boolean isOnSale() {
			return true;
		}
	}
	
	public class ClickCounter {
		private int count;
		
		public ClickCounter() {
			count = 0;
		}
		
		public void click() {
			count++;
		}
		
		public void setClickCount(int clickCount) {
			count = clickCount;
		}
		
		public int getClickCount() {
			return count;
		}
	}
	/* ====================================== */
	
	/* Encapsulation */
	
	public class Student {
		private float gpa;
		private String degreeProgram;
		
		public float getGPA() {
			return gpa;
		}
		
		public void setGPA(float newGpa) {
			gpa = newGpa;
		}
		
		public String getDegreeProgram() {
			return degreeProgram;
		}
		
		public void setdegreeProgram(String newDegreeProgram) {
			if (gpa > 2.7) {
				degreeProgram = newDegreeProgram;
			}
		}
	}
	
	/* ====================================== */
	
	/* Decomposition */
	// Association
	public class Wine {
		public void pair(Food food) {}
	}
	
	// Aggregation
	public class Pet {}
	public class PetStore {
		private ArrayList<Pet> pets;
		
		public PetStore() {
			pets = new ArrayList<Pet>();
		}
		
		public void add(Pet pet) {}
	}
	
	// Composition
	public class Brain{}
	public class Human {
		private Brain brain;
		
		public Human() {
			brain = new Brain();
		}
	}
	
	/* ====================================== */
	
	/* Generalization w/inheritance */
	
	public abstract class Animal {
		protected int numberOfLegs;
		protected int numberOfTails;
		protected String name;
		
		public Animal(String petName, int legs, int tails) {
			this.name = petName;
			this.numberOfLegs = legs;
			this.numberOfTails = tails;
		}
		
		public void walk() {
			System.out.println("Animal is walking");
		}
		public void run() {}
		public void eat() {}
	}
	
	public class Dog extends Animal {
		public Dog(String name, int legs, int tails) {
			super(name, legs, tails);
		}
		
		public void playFetch() {}
		public void walk() {
			System.out.println("Dog is walking");
		}
	}
	
	/* ====================================== */
	
	/* Generalization w/interfaces */
	
	
	public interface IAnimal {
		public void move();
		public void speak();
		public void eat();
	}
	
	public class Cat implements IAnimal {
		public void move() {}
		public void speak() {}
		public void eat() {}
	}
	//-
	public interface IVehicleMovement {
		public void moveOnX();
		public void moveOnY();
	}
	
	public interface IVehicleMovement3D extends IVehicleMovement{
		public void moveOnZ();
	}
	//-
	public interface IPublicSpeaking {
		public void givePresentation();
		public void speak();
	}
	
	public interface IPrivateConversation {
		public void lowerVoiceVolume();
		public void speak();
	}
	
	public class Person implements IPublicSpeaking, IPrivateConversation {
		public void lowerVoiceVolume() {}
		public void givePresentation() {}
		public void speak() {
			System.out.println("This is fine");
		}
	}
	

	public static void main(String[] args) {
		// TODO Auto-generated method stub

	}

}
