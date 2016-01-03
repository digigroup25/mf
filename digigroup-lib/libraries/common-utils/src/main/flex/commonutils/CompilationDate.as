package commonutils {
	
	import flash.display.LoaderInfo;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.net.SharedObject;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	import mx.core.Application;
	import mx.core.FlexGlobals;
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	
	
	/**
	 * Direct reading of SWF file to gather the SWF Compile information
	 *
	 * Distributed under the new BSD License
	 * @author Paul Sivtsov - ad@ad.by
	 * @author Igor Costa
	 * @author Judah Frangipane
	 *
	 * http://www.igorcosta.org/?p=220
	 * http://judahfrangipane.com
	 *
	 * Updated for use as an MXML tag and source of data binding, etc
	 *
	 *
	 **/
	public class CompilationDate {
		
		// date SWF was compiled
		[Bindable]
		public var compilationDate:Date = new Date();
		
		// date SWF was compiled last
		// this date is set to the same compilation date when it is run the client the first time
		[Bindable]
		public var previousCompiliationDate:Date = new Date();
		
		// difference in milliseconds from last compile
		// only works when the application has been previously visited on your computer
		[Bindable]
		public var timeDifference:Number = 0;
		
		// year compiled
		[Bindable]
		public var year:String = "";
		
		// month name
		[Bindable]
		public var monthName:String = "";
		
		// month names
		[Bindable]
		public var monthNames:Array = ["January","February","March","April","May","June","July","August","September","October","November","December"];
		
		// month number
		[Bindable]
		public var monthIndex:String = "";
		
		// day name
		[Bindable]
		public var dayName:String = "";
		
		// day name
		[Bindable]
		public var dayNames:Array = ["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"];
		
		// day number index
		[Bindable]
		public var dayIndex:String = "";
		
		// day of month number
		[Bindable]
		public var dayNumber:String = "";
		
		// hour
		[Bindable]
		public var hour:String = "";
		
		// minute
		[Bindable]
		public var minute:String = "";
		
		// seconds
		[Bindable]
		public var seconds:String = "";
		
		// milliseconds
		[Bindable]
		public var milliseconds:String = "";
		
		// AM or PM
		[Bindable]
		public var ampm:String = "";
		
		// AM or PM array
		[Bindable]
		public var ampmNames:Array = ["AM","PM"];
		
		// hour notation
		[Inspectable(type="String", enumeration="12,24", defaultValue="12")]
		[Bindable]
		public var hourNotation:String = "12";
		
		// flag that indicates the swf has changed since last time you viewed it in the browser
		[Bindable]
		public var changed:Boolean = false;
		
		// flag that indicates the swf has changed since last time you viewed it in the browser
		[Bindable]
		public var cached:Boolean = false;
		
		// track changes in a shared object
		// allows you to know if and how long ago changes were made 
		[Bindable]
		public var trackChanges:Boolean = true;
		
		// local version number unique to the computer the application is run on 
		[Bindable]
		public var version:String = "";
		
		// serial number
		[Bindable]
		public var serialNumber:ByteArray = new ByteArray();
		
		// reference to reload button
		[Bindable]
		public var reloadButton:* = new UIComponent();
		
		public function CompilationDate() {
			FlexGlobals.topLevelApplication.addEventListener(FlexEvent.APPLICATION_COMPLETE, applicationComplete, false, 0, true);
		}
		
		///////////////////////////////////////////////////////////////////////////
		// Set the compilation date variable after SWF is loaded
		private function applicationComplete(event:FlexEvent):void {
			var leadingZeros:LeadingZeros = new LeadingZeros();
			
			compilationDate = readCompilationDate();
			
			year = String(compilationDate.fullYear);
			monthName = String(monthNames[compilationDate.month]);
			monthIndex = String(compilationDate.month);
			dayName = String(dayNames[compilationDate.day]);
			dayIndex = String(compilationDate.day);
			dayNumber = String(compilationDate.date);
			hour = (hourNotation=="12") ? (compilationDate.hours==0) ? "12" : (compilationDate.hours<11) ? String(compilationDate.hours) : String(compilationDate.hours - 12) : String(compilationDate.hours);
			hour = (hour =="0") ? "12" : hour;
			minute = String(leadingZeros.padNumber(compilationDate.minutes, 2));
			seconds = String(leadingZeros.padNumber(compilationDate.seconds, 2));
			milliseconds = String(leadingZeros.padNumber(compilationDate.milliseconds, 3));
			ampm = (compilationDate.hours<12) ? ampmNames[0] : ampmNames[1];
			
			var sharedObjectName:String = FlexGlobals.topLevelApplication.className.toString() + "_CompilationDate";
			var sharedObject:SharedObject = SharedObject.getLocal(sharedObjectName);
			var localVersion:int = int(version);
			
			// previous changes found
			if (sharedObject.size!=0) {
				// get last saved compilation date
				previousCompiliationDate = new Date(sharedObject.data.compilationDate);
				// get last version number
				localVersion = sharedObject.data.version;
				// get time difference
				timeDifference = compilationDate.time - previousCompiliationDate.time;
				
				if (timeDifference>0) {
					changed = true;
					localVersion++;
				}
				else {
					cached = true;
				}
			}
			
			// save changes
			sharedObject.data.compilationDate = compilationDate.time;
			sharedObject.data.version = localVersion;
			version = String(localVersion);
			
			// save changes
			if (trackChanges) {
				try {
					sharedObject.flush();
				} catch (e:Event) {
					// can't save info for some reason
				}
			}
			
			// remove listener
			FlexGlobals.topLevelApplication.removeEventListener(FlexEvent.APPLICATION_COMPLETE, applicationComplete);
			
			// if we have button and the file hasn't changed we show the reload button
			if (reloadButton!=null && !changed && reloadButton is UIComponent) {
				UIComponent(reloadButton).visible = true;
				UIComponent(reloadButton).addEventListener(MouseEvent.CLICK, function():void {
					//SecurityError: Error #2060: Security sandbox violation: ExternalInterface caller 
					// requires you to have access to the wrapper 
					// IE be on a server, like localhost or yourdomain.com 
					try {
						ExternalInterface.call("eval", "document.location.reload(true)");
					}
					catch (event:Error) {} 
				});
				
			}
		}
		
		///////////////////////////////////////////////////////////////////////////
		// Returns compilation date of current module
		public function readCompilationDate(serialNumber:ByteArray = null):Date {
			const compilationDate:Date = new Date;
			const DATETIME_OFFSET:uint = 18;
			
			if (serialNumber == null)
				serialNumber = readSerialNumber();
			
			/* example of filled SWF_SERIALNUMBER structure
			struct SWF_SERIALNUMBER
			{
			UI32 Id;         // "3"
			UI32 Edition;    // "6"
			// "flex_sdk_4.0.0.3342"
			UI8 Major;       // "4."
			UI8 Minor;       // "0."
			UI32 BuildL;     // "0."
			UI32 BuildH;     // "3342"
			UI32 TimestampL;
			UI32 TimestampH;
			};
			*/
			
			// the SWF_SERIALNUMBER structure exists in FLEX swfs only, not FLASH
			if (serialNumber == null)
				return null;
			
			// date stored as uint64
			serialNumber.position = DATETIME_OFFSET;
			serialNumber.endian = Endian.LITTLE_ENDIAN;
			compilationDate.time = serialNumber.readUnsignedInt() + serialNumber.readUnsignedInt()* (uint.MAX_VALUE + 1);
			
			return compilationDate;
		}
		
		///////////////////////////////////////////////////////////////////////////
		// Returns contents of Adobe SerialNumber SWF tag
		public function readSerialNumber():ByteArray {
			const TAG_SERIAL_NUMBER:uint = 0x29;
			return findAndReadTagBody(TAG_SERIAL_NUMBER);
		}
		
		///////////////////////////////////////////////////////////////////////////
		// Returns the tag body if it is possible
		public function findAndReadTagBody(theTagCode:uint):ByteArray {
			// getting direst access to unpacked SWF file
			// reported to cause security sandbox errors ->
			//const src:ByteArray = LoaderInfo.getLoaderInfoByDefinition(SWF).bytes;
			// erg this one throughs an error too TypeError: Error #1009: Cannot access a property or method of a null object reference.
			//const src:ByteArray = Application(Application.application).loaderInfo.bytes;
			var src:ByteArray = new ByteArray();
			var loaderInfo:LoaderInfo = FlexGlobals.topLevelApplication.loaderInfo;
			
			// the swf has not loaded yet - wait until application complete
			if (loaderInfo.bytesLoaded!=loaderInfo.bytesTotal) { 
				return null;
			}
			const test:* = FlexGlobals.topLevelApplication.loaderInfo.bytes;
			src = FlexGlobals.topLevelApplication.loaderInfo.bytes;
			
			/*
			SWF File Header
			Field      Type  Offset   Comment
			-----      ----  ------   -------
			Signature  UI8   0        Signature byte: “F” indicates uncompressed, “C” indicates compressed (SWF 6 and later only)
			Signature  UI8   1        Signature byte always “W”
			Signature  UI8   2        Signature byte always “S”
			Version    UI8   3        Single byte file version (for example, 0x06 for SWF 6)
			FileLength UI32  4        Length of entire file in bytes
			FrameSize  RECT  8        Frame size in twips
			FrameRate  UI16  8+RECT   Frame delay in 8.8 fixed number of frames per second
			FrameCount UI16  10+RECT  Total number of frames in file
			*/
			
			// skip AVM2 SWF header
			// skip Signature, Version & FileLength
			src.position = 8;
			// skip FrameSize
			const RECT_UB_LENGTH:uint = 5;
			const RECT_SB_LENGTH:uint = src.readUnsignedByte() >> (8 - RECT_UB_LENGTH);
			const RECT_LENGTH:uint = Math.ceil((RECT_UB_LENGTH + RECT_SB_LENGTH* 4) / 8);
			src.position += (RECT_LENGTH - 1);
			// skip FrameRate & FrameCount
			src.position += 4;
			
			while(src.bytesAvailable > 0) {
				with(readTag(src, theTagCode)) {
					if (tagCode == theTagCode)
						return tagBody;
				}
			}
			
			return null;
		}
		
		///////////////////////////////////////////////////////////////////////////
		// Returns tag from current read position
		private function readTag(src:ByteArray, theTagCode:uint):Object {
			src.endian = Endian.LITTLE_ENDIAN;
			
			const tagCodeAndLength:uint = src.readUnsignedShort();
			const tagCode:uint = tagCodeAndLength >> 6;
			const tagLength:uint = function():uint {
				const MAX_SHORT_TAG_LENGTH:uint = 0x3F;
				const shortLength:uint = tagCodeAndLength & MAX_SHORT_TAG_LENGTH;
				return (shortLength == MAX_SHORT_TAG_LENGTH) ? src.readUnsignedInt() : shortLength;
			}();
			
			const tagBody:ByteArray = new ByteArray;
			if (tagLength > 0)
				src.readBytes(tagBody, 0, tagLength);
			
			return {tagCode:tagCode, tagBody:tagBody};
		}
	}
}


