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

	public class TruckV2 extends FisixObject
	{
		
		private var _leftWheel:WheelParticle;
		private var _rightWheel:WheelParticle;
		
		private var _bodyBum:CircleParticle;
		private var _bodyNose:CircleParticle;
		
		public function TruckV2(x:Number, y:Number)
		{
			bounce = 0.2;
			friction = 0.5;
			innerCollisions = true;
			setDetectionMode(DetectionModes.HYBRID_RAYCAST);
			
			//wheels
			_leftWheel = newWheelParticle(0, 0, 21);
			_rightWheel = newWheelParticle(72, 0, 21);
			_leftWheel.mass = 1;
			_rightWheel.mass = 1;
			
			//body
			var mid:CircleParticle = newCircleParticle(38, -25, 19);
			var bumber:CircleParticle = newCircleParticle(74, -28, 12);
			var rear:CircleParticle = newCircleParticle(-15, -24, 10);
			var back:CircleParticle = newCircleParticle(14, -20, 13);
			mid.mass = 0.5;
			bumber.mass = 0.2;
			rear.mass = 0.2;
			back.mass = 0;
			
			
			//between wheels
			var cntrw:SpringConstraint = new SpringConstraint(_leftWheel, _rightWheel, 1, 72);
			var cntr_wl_bm:SpringConstraint = new SpringConstraint(_leftWheel, bumber, 0.3, 100);
			var cntr_wr_rr:SpringConstraint = new SpringConstraint(_rightWheel, rear, 0.3, 100);
			var cntr_wl_br:SpringConstraint = new SpringConstraint(_leftWheel, back, 0.3, 42);
			cntrw.max = 72;
			cntrw.min = 72;
			
			//between wheels and body
			var cntr_wl_md:SpringConstraint = new SpringConstraint(_leftWheel, mid, 0.7, 58);
			var cntr_wr_md:SpringConstraint = new SpringConstraint(_rightWheel, mid, 0.7, 52);
			
			var cntr_wr_bm:SpringConstraint = new SpringConstraint(_rightWheel, bumber, 0.7, 38);
			var cntr_md_bm:StickConstraint = new StickConstraint(mid, bumber, 35);
			
			var cntr_wl_rr:SpringConstraint = new SpringConstraint(_leftWheel, rear, 0.7, 40);
			var cntr_md_rr:StickConstraint = new StickConstraint(mid, rear, 55);
			var cntr_md_rr2:StickConstraint = new StickConstraint(mid, rear, 55);
			
			//back
			var cntr_rr_br:StickConstraint = new StickConstraint(rear, back, 18);
			var cntr_md_br:StickConstraint = new StickConstraint(mid, back, 36);
			
			
			_bodyBum = rear;
			_bodyNose = bumber;
			
			addConstraint(cntrw);
			addConstraint(cntr_wl_md);
			addConstraint(cntr_wr_md);
			addConstraint(cntr_wr_bm);
			addConstraint(cntr_md_bm);
			addConstraint(cntr_wl_rr);
			addConstraint(cntr_md_rr);
			addConstraint(cntr_md_rr2);
			addConstraint(cntr_wl_bm);
			addConstraint(cntr_wr_rr);
			addConstraint(cntr_rr_br);
			addConstraint(cntr_md_br);
			addConstraint(cntr_wl_br);
			
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