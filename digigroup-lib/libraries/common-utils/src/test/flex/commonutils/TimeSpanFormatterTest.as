package commonutils {
	import mx.utils.StringUtil;

	import org.flexunit.runners.Parameterized;
	import org.hamcrest.assertThat;
	import org.hamcrest.object.equalTo;

	[RunWith("org.flexunit.runners.Parameterized")]
	public class TimeSpanFormatterTest {

		public static function timeSpanFormatterTestCases():Array {
			return [[ TimeSpan.fromHours(1), "1h" ],
				[ TimeSpan.fromMinutes(5), "5m" ],
				[ TimeSpan.fromMinutes(1 * 60 + 30), "1h 30m" ],
				[ TimeSpan.fromMinutes(0), "0m" ]];
		}

		private var foo:Parameterized;

		private var formatter:TimeSpanFormatter;

		[Before]
		public function setUp():void {
			formatter = new TimeSpanFormatter();
		}

		[After]
		public function tearDown():void {
			formatter = null;
		}

		[Test(dataProvider = "timeSpanFormatterTestCases")]
		public function matchTimeSpans(timeSpan:TimeSpan, expectedResult:String):void {
			var actualResult:String = formatter.format(timeSpan);

			assertThat(actualResult, equalTo(expectedResult));
		}
	}
}
