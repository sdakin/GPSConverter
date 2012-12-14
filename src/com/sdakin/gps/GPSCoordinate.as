package com.sdakin.gps
{
	public class GPSCoordinate
	{
		public static var FORMAT_DMS:int = 0;		// degrees, minutes and seconds: ddd/mm/ss.s
		public static var FORMAT_DECMIN:int = 1;	// degrees and decimal minutes:  ddd/mm.mmm
		public static var FORMAT_DECDEG:int = 2;	// decimal degrees:              dd.ddddd
		
		public function get latitude():Number { return _latitude; }
		public function set latitude(newValue:Number):void { _latitude = newValue; }
		public function get longitude():Number { return _longitude; }
		public function set longitude(newValue:Number):void { _longitude = newValue; }
		
		public function toString(format:int):String {
			var result:String = "";
			var degrees:Number;
			var minutes:Number;
			var seconds:Number;
			
			if (format == FORMAT_DMS) {
				if (!isNaN(longitude)) {
					degrees = int(Math.round(latitude * 100) / 100);
					minutes = Math.abs((latitude - degrees) * 60);
					seconds = Math.round(((minutes - Math.floor(minutes)) * 60) * 100) / 100;
					minutes = Math.floor(minutes);
					result = Math.abs(degrees) + "° " + minutes + "' " + seconds + "\" " + (latitude >= 0 ? "N" : "S");
				}
				
				if (!isNaN(longitude)) {
					degrees = int(Math.round(longitude * 100) / 100);
					minutes = Math.abs((longitude - degrees) * 60);
					seconds = Math.round(((minutes - Math.floor(minutes)) * 60) * 100) / 100;
					minutes = Math.floor(minutes);
					result += ", " + Math.abs(degrees) + "° " + minutes + "' " + seconds + "\" " + (longitude >= 0 ? "E" : "W");
				}
			} else if (format == FORMAT_DECMIN) {
				degrees = int(Math.round(latitude * 100) / 100);
				minutes = Math.abs((latitude - degrees) * 60);
				result = (latitude >= 0 ? "N" : "S") + Math.abs(degrees) + " " + 
					(Math.round((minutes * 100)) / 100);
				
				degrees = int(Math.round(longitude * 100) / 100);
				minutes = Math.abs((longitude - degrees) * 60);
				result += " " + (longitude >= 0 ? "E" : "W") + Math.abs(degrees) + " " + 
					(Math.round((minutes * 100)) / 100);
			} else if (format == FORMAT_DECDEG) {
				if (!isNaN(latitude)) {
					result = String(Math.round(latitude * 1000000) / 1000000);
					if (!isNaN(longitude)) {
						result += " " + (Math.round(longitude * 1000000) / 1000000);
					}
				}
			}
			return result;
		}
		
		protected var _latitude:Number;		// expressed in decimal degrees
		protected var _longitude:Number;	// expressed in decimal degrees
	}
}