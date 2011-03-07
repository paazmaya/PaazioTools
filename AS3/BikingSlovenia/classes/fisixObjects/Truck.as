package fisixObjects
{
	import com.fileitup.fisixengine.core.FisixObject;
	import com.fileitup.fisixengine.collisions.DetectionModes;
	import com.fileitup.fisixengine.particles.WheelParticle;
	import com.fileitup.fisixengine.constraints.StickConstraint;
	import com.fileitup.fisixengine.particles.CircleParticle;
	import com.fileitup.fisixengine.constraints.SpringConstraint;
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import com.fileitup.fisixengine.primitives.Surface;
	import com.fileitup.fisixengine.core.Vector;

	public class Truck extends FisixObject
	{
		
		private var _leftWheel:WheelParticle;
		private var _rightWheel:WheelParticle;
		
		private var _bodyBum:CircleParticle;
		private var _bodyNose:CircleParticle;
		
		public function Truck(x:Number, y:Number)
		{
			bounce = 0.2;
			friction = 0.5;
			this.collidable = true;
			this.dynamicObjectCollisions = true;
			innerCollisions = true;
			setDetectionMode(DetectionModes.HYBRID_RAYCAST);
			
			//wheels
			_leftWheel = newWheelParticle(0, 0, 21);
			_rightWheel = newWheelParticle(72, 0, 21);
			
			//body
			var leftBumber:CircleParticle = newCircleParticle(-13, -24, 9);
			leftBumber.mass = 0.3;
			var rightBumber:CircleParticle = newCircleParticle(80, -24, 8);
			rightBumber.mass = 0.3;
			var leftRoof:CircleParticle = newCircleParticle(31, -46, 6);
			leftRoof.mass = 0.2;
			var rightRoof:CircleParticle = newCircleParticle(51, -44, 6);
			rightRoof.mass = 0.2;
			
			//between wheels
			var cntrw:SpringConstraint = new SpringConstraint(_leftWheel, _rightWheel, 1, 72);
			cntrw.max = 72;
			cntrw.min = 72;
			
			//between wheels and body
			var cntr_wl_bl:SpringConstraint = new SpringConstraint(_leftWheel, leftBumber, 0.5, 46);
			var cntr_wr_bl:StickConstraint = new StickConstraint(_rightWheel, leftBumber, 85);
			var cntr_wr_br:SpringConstraint = new SpringConstraint(_rightWheel, rightBumber, 0.7, 44);
			var cntr_wl_br:StickConstraint = new StickConstraint(_leftWheel, rightBumber, 85);
			var cntr_wr_fl:StickConstraint = new StickConstraint(_rightWheel, leftRoof, 50);
			var cntr_wl_fr:StickConstraint = new StickConstraint(_leftWheel, rightRoof, 55);
			
			//between body
			var cntr_bl_br:StickConstraint = new StickConstraint(leftBumber, rightBumber, 100);
			var cntr_fl_fr:StickConstraint = new StickConstraint(leftRoof, rightRoof, 20);
			var cntr_bl_fl:StickConstraint = new StickConstraint(leftBumber, leftRoof, 46);
			var cntr_br_fr:StickConstraint = new StickConstraint(rightBumber, rightRoof, 32);
			var cntr_bl_fr:StickConstraint = new StickConstraint(leftBumber, rightRoof, 65);
			var cntr_br_fl:StickConstraint = new StickConstraint(rightBumber, leftRoof, 54);
			
			_bodyBum = leftBumber;
			_bodyNose = rightBumber;
			
			addConstraint(cntrw);
			addConstraint(cntr_wl_bl);
			addConstraint(cntr_wr_bl);
			addConstraint(cntr_wr_br);
			addConstraint(cntr_wl_br);
			addConstraint(cntr_bl_br);
			addConstraint(cntr_fl_fr);
			addConstraint(cntr_bl_fl);
			addConstraint(cntr_br_fr);
			addConstraint(cntr_bl_fr);
			addConstraint(cntr_br_fl);
			addConstraint(cntr_wr_fl);
			addConstraint(cntr_wl_fr);
			
			setCenter(x, y);
		}
		
		public function get leftWheel():WheelParticle {
			return _leftWheel;
		}
		
		public function get rightWheel():WheelParticle {
			return _rightWheel;
		}
		
		public function get bum():CircleParticle {
			return _bodyBum;
		}
		
		public function get nose():CircleParticle {
			return _bodyNose;
		}
		
	}
}