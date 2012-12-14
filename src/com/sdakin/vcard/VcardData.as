package com.sdakin.vcard
{
	import com.sdakin.gps.GPSCoordinate;
	import com.sdakin.gps.GPSParser;

	public class VcardData
	{
		protected var _fullName:String;
		protected var _addr:String;
		protected var _geo:String;
		
		static public function fromObject(obj:Object):VcardData
		{
			var result:VcardData = new VcardData();
			result._fullName = obj["FN"];
			result._addr = obj["ADR"];
			if (obj.hasOwnProperty("GEO")) {
				var parser:GPSParser = new GPSParser();
				var coord:GPSCoordinate = parser.parseGPSCoordinate(obj["GEO"].replace(/[ ]+/g, ","));
				result._geo = coord.toString(GPSCoordinate.FORMAT_DECDEG).replace(/[ ]+/g, ";");
			}
			return result;
		}
		
		public function toString():String {
			var vcardStr:String = "BEGIN:VCARD\nVERSION:3.0\n";
			if (_fullName)
				vcardStr += "FN:" + _fullName + "\n";
			if (_addr)
				vcardStr += "ADR:" + _addr + "\n";
			if (_geo)
				vcardStr += "GEO:" + _geo + "\n";
			vcardStr += "END:VCARD\n";
			return vcardStr;
		}
	}
}