
public class Main {

	/* Coupling and Cohesion */
	
	// Sensor class has low cohesion, 
	//  since it has two purposes and therefore unclear.
	// Sensor class has tight coupling, 
	//  since its get method is not straightforward.
	public class Sensor {
		public void get (int controlFlag) {
			switch (controlFlag) {
				case 0:
					return this.humidity;
					break;
				case 1:
					return this.temperature;
					break;
				default:
					throw new Exception();
			}
		}
	}
	
	// Losely coupled
	public interface ISensor {
		public void get();
	}
	
	public class HumiditySensor implements ISensor{
		public void get() {}
	}
	
	public class TemperatureSensor implements ISensor{
		public void get() {}
	}
	
	//-
	// The class is highly cohesive because it is completely focused on Sprinkling. 
	//  turnOnWaterPump() is part of that responsibility, 
	//  although if it was outsourced to another class, 
	//  then users of sprinkle() would have no idea!
	// Despite having no parameter, it lacks ease due to its use of globals. 
	//  Therefore tightly coupled.
	public static class Globals {
		public static double Pressure = 0.0;
	}
	
	public class LawnSprinkler {
		public void sprinkle() {
			this._pressure = Globals.Pressure;
			this.turnOnWaterPump(this._pressure);
		}
		
		private void turnOnWaterPump(double pressure) {}
	}
		
	
	/* ================================================= */
	// Seperation of concerns
	
	//low cohesion
	public class SmartPhone {
		private byte camera;
		private byte phone;
		
		public SmartPhone() {}
		
		public void takePhoto() {}
		public void savePhoto() {}
		public void cameraFlash() {}
		
		public void makePhoneCall() {}
		public void encryptOutgoingSound() {}
		public void decipherIncomingSound() {}
	}
	
	public class SmartPhone2 {
		private ICamera myCamera;
		private IPhone myPhone;
		
		public SmartPhone2(ICamera aCamera, IPhone aPhone) {
			this.myCamera = aCamera;
			this.myPhone = aPhone;
		}
		
		public void useCamera() {
			this.myCamera.takePhoto();
		}
		
		public void usePhone() {
			this.myPhone.makePhoneCall();
		}
		
	}
	
	public interface IPhone{
		public void makePhoneCall();
		public void encryptOutgoingSound();
		public void decipherIncomingSound();
	}
	
	public interface ICamera{
		public void takePhoto();
		public void savePhoto();
		public void cameraFlash();
	}
	
	public class FirstGenCamera implements ICamera {
		public void takePhoto() {}
		public void savePhoto() {}
		public void cameraFlash() {}
	}
	
	public class TraditionalPhone implements IPhone {
		public void makePhoneCall() {}
		public void encryptOutgoingSound() {}
		public void decipherIncomingSound() {}
	}


	public static void main(String[] args) {
		

		

	}

}
