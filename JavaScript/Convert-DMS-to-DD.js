
/* Written by Sparky Spider (http://sparkyspider.blogspot.com) */

function Coordinates() {

// Properties

this._latitude = 0;
this._longitude = 0;

this.LATITUDE = 0;
this.LONGITUDE = 1;

// Constuctor

this.latitude = new DMSCalculator(this.LATITUDE, this);
this.longitude = new DMSCalculator(this.LONGITUDE, this);

// Methods

this.setLatitude = function setLatitude(lat) {
	this._latitude = lat;
};

this.setLongitude = function setLongitude(lng) {
this._longitude = lng;
}

this.getLatitude = function getLatitude() {
return this._latitude;
}

this.getLongitude = function getLongitude() {
return this._longitude;
}

// SubClasses

function DMSCalculator (coordSet, object) {

var degrees = [0, 0];
var minutes = [0, 0];
var seconds = [0, 0];
var direction = [' ', ' '];
var lastValue = [0, 0];
var hundredths = [0.0, 0.0];

var calc = function calc(object) {

var val = 0;

if (coordSet == object.LATITUDE) {
val = object._latitude;
} else {
val = object._longitude;
}

if (lastValue[coordSet] != val) {

lastValue[coordSet] = val;

if (val > 0) {
direction[coordSet] = (coordSet == object.LATITUDE)?'N':'E';
}
else {
direction[coordSet] = (coordSet == object.LATITUDE)?'S':'W';
}
val = Math.abs(val);
degrees[coordSet] = parseInt (val);
var leftover = (val - degrees[coordSet]) * 60;
minutes[coordSet] = parseInt (leftover)
leftover = (leftover - minutes[coordSet]) * 60;
seconds[coordSet] = parseInt (leftover)
hundredths[coordSet] = parseInt ((leftover - seconds[coordSet]) * 100);

}
}

this.getDegrees = function getDegrees() {
calc(object);
return degrees[coordSet];
}

this.getMinutes = function getMinutes() {
calc(object);
return minutes[coordSet];
}

this.getSeconds = function getSeconds() {
calc(object);
return seconds[coordSet];
}

this.getDirection = function getDirection() {
calc(object);
return direction[coordSet];
}

this.getHundredths = function getHundredths() {
calc(object);
return hundredths[coordSet];
}

this.getSecondsDecimal = function getSecondsDecimal() {
calc(object);
return seconds[coordSet] + (hundredths[coordSet] / 100);
}

this.setDMS = function setDMS (degrees, minutes, seconds, direction) {
var val = degrees + (minutes / 60) + (seconds / 3600);
if (direction == 'W' || direction == 'S') {
val *=-1;
}
if (coordSet == object.LATITUDE) {
object._latitude = val;
}
else {
object._longitude = val;
} // if
} // this.setDMS
} // DMSCalculator
} // Coordinates


It's really easy to use too. Here are 2 examples:


function test() {
var coords = new Coordinates();
coords.longitude.setDMS(33, 46, 16.68, 'S');
coords.latitude.setDMS(18, 44, 24.19, 'E');

alert (coords.getLatitude() + ' ' + coords.getLongitude());

coords.setLatitude (-33.7713);
coords.setLongitude (18.7400527778);

DMSStringLat = coords.latitude.getDegrees() + ' ' + coords.latitude.getMinutes() + ' ' + coords.latitude.getSecondsDecimal() + ' ' + coords.latitude.getDirection();
DMSStringLng = coords.longitude.getDegrees() + ' ' + coords.longitude.getMinutes() + ' ' + coords.longitude.getSecondsDecimal() + ' ' + coords.longitude.getDirection();

alert (DMSStringLat + ' ' + DMSStringLng);
}