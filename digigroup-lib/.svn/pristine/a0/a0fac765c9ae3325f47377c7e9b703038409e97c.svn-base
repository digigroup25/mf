package commonutils {

	public class MinutePrecisionTimeSpan extends TimeSpan {

		/**
		 * Creates a TimeSpan from the specified number of minutes
		 * @param minutes The number of minutes in the timespan
		 * @return A TimeSpan that represents the specified value
		 */
		public static function fromMinutes(minutes:Number):TimeSpan {
			return new MinutePrecisionTimeSpan(minutes * MILLISECONDS_IN_MINUTE);
		}

		/**
		 * Creates a TimeSpan from the specified number of hours
		 * @param hours The number of hours in the timespan
		 * @return A TimeSpan that represents the specified value
		 */
		public static function fromHours(hours:Number):TimeSpan {
			return new MinutePrecisionTimeSpan(hours * MILLISECONDS_IN_HOUR);
		}

		public function MinutePrecisionTimeSpan(milliseconds:Number) {
			var millisecondsRoundedToMinutes:int = int(Math.round(milliseconds / 60000)) * 60000; //round to minutes
			super(millisecondsRoundedToMinutes);
		}
	}
}
