import QtQuick 1.0
import Qt.labs.particles 1.0

/**
 * Particles seems to require a source image as a base for each particle.
 */
Rectangle {
	width: 800
	height: 600
	color: "black"

	Particles {
		y: 0
		width: parent.width
		height: 30
		lifeSpan: 5000
		count: 50
		angle: 70
		angleDeviation: 36
		velocity: 30
		velocityDeviation: 10
		ParticleMotionWander {
			xvariance: 30
			pace: 100
		}
	}

	Particles {
		y: 300
		x: 120
        width: 100
        height: 100
		lifeSpan: 5000
		count: 200
		angle: 270
		angleDeviation: 45
		velocity: 50
		velocityDeviation: 30
		ParticleMotionGravity {
			yattractor: 1000
			xattractor: 0
			acceleration: 25
		}
	}
}
