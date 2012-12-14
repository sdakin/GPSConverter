package com.sdakin.gps
{
	public class GPSParser
	{
		private static var dirStr:String = "nsew";
		private static var numStr:String = "0123456789.-";
		
		private static var DIR_UNKNOWN:int = -1;
		private static var DIR_NORTH:int = 0;
		private static var DIR_SOUTH:int = 1;
		private static var DIR_WEST:int = 2;
		private static var DIR_EAST:int = 3;
		
		public var parsedCoord:GPSCoordinate = new GPSCoordinate();
		private var parseNumStr:String = "";
		private var gpsDirection:int = DIR_UNKNOWN;
		private var degrees:Number = NaN;
		private var minutes:Number = NaN;
		private var seconds:Number = NaN;

		private function processNumber():Boolean {
			var result:Boolean = false;
			if (parseNumStr.length > 0) {
				if (isNaN(degrees)) { degrees = new Number(parseNumStr); result = true; }
				else if (isNaN(minutes)) { minutes = new Number(parseNumStr); result = true; }
				else if (isNaN(seconds)) { seconds = new Number(parseNumStr); result = true; }
				parseNumStr = "";
			}
			return result;
		}

		private function processCoord():void {
			if (!isNaN(degrees)) {
				if (isNaN(parsedCoord.latitude))
					parsedCoord.latitude = convertToDecimalDegrees(gpsDirection, degrees, minutes, seconds);
				else if (isNaN(parsedCoord.longitude))
					parsedCoord.longitude = convertToDecimalDegrees(gpsDirection, degrees, minutes, seconds);
				gpsDirection = DIR_UNKNOWN;
				degrees = NaN;
				minutes = NaN;
				seconds = NaN;
			}
		}

		// This function is based on information found here:
		//		http://en.wikipedia.org/wiki/Geographic_coordinate_conversion
		private static function convertToDecimalDegrees(gpsDirection:int, degrees:Number, 
														minutes:Number, seconds:Number):Number {
			var result:Number = NaN;
			
			// check formats in decreasing order of number of parameters
			if (!isNaN(seconds)) {
				// convert from degrees/minutes/seconds to decimal degrees
				var totalSeconds:Number = minutes * 60 + seconds;
				result = Math.floor(degrees) + (totalSeconds / 3600);
			} else if (!isNaN(minutes)) {
				// convert from degrees/decimal minutes to decimal degrees
				result = Math.floor(degrees) + (minutes / 60);
			} else {
				// input is already in decimal degrees format
				result = degrees;
			}
			
			// lastly, set the sign of the decimal degrees value
			if (!isNaN(result)) {
				if (gpsDirection == DIR_SOUTH || gpsDirection == DIR_WEST)
					result *= -1;
			}
			return result;
		}
		
		public function parseGPSCoordinate(coordStr:String):GPSCoordinate {
			if (coordStr) {
				for (var i:int = 0 ; i < coordStr.length ; i++) {
					var ch:String = coordStr.charAt(i).toLowerCase();
					if (dirStr.indexOf(ch) >= 0) {
						if (gpsDirection != DIR_UNKNOWN)
							processCoord();
						if (ch == "n") gpsDirection = DIR_NORTH;
						else if (ch == "s") gpsDirection = DIR_SOUTH;
						else if (ch == "e") gpsDirection = DIR_EAST;
						else if (ch == "w") gpsDirection = DIR_WEST;
					} else if (numStr.indexOf(ch) >= 0) {
						parseNumStr = ch;
						while (i + 1 < coordStr.length && numStr.indexOf(coordStr.charAt(i + 1)) >= 0) {
							parseNumStr += coordStr.charAt(++i);
						}
					} else if (ch == "°") {
						degrees = new Number(parseNumStr);
						parseNumStr = "";
					} else if (ch == "," || ch == ";") {		// latitude/longitude divider
						processNumber();
						processCoord();
					} else if (parseNumStr.length > 0) {
						if (!processNumber()) {
							processCoord();
						}
						parseNumStr = "";
					}
				}
				processNumber();
				processCoord();
			}
			return parsedCoord;
		}
	}
}