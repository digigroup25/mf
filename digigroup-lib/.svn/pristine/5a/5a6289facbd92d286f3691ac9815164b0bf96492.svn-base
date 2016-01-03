package mindmaps.importexport {
	import commonutils.MinutePrecisionTimeSpan;
	import commonutils.TimeSpan;
	import commonutils.TimeSpanFormatter;

	import org.flexunit.assertThat;
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.runners.Parameterized;
	import org.hamcrest.object.equalTo;

	[RunWith("org.flexunit.runners.Parameterized")]
	public class TimeSpanMatcherTest {

		private static const type:String = TimeSpanMatcher.type;

		public static function timeSpanMatchTestCases():Array {
			return processForParameterizedTesting([
				{ input: "", output: { score: 0 }},
				{ input: "0.5h", output: { score: 1, type: type, value: TimeSpan.fromHours(0.5)}}
				, { input: "1", output: { score: 1, type: type, value: TimeSpan.fromHours(1)}},
				{ input: "1.2", output: { score: 1, type: type, value: TimeSpan.fromHours(1.2)}},
				{ input: "1h30m", output: { score: 1, type: type, value: TimeSpan.fromHours(1.5)}},
				{ input: "15m", output: { score: 1, type: type, value: TimeSpan.fromHours(0.25)}},
				{ input: "2h", output: { score: 1, type: type, value: TimeSpan.fromHours(2)}},
				{ input: "1 hour 30 mins", output: { score: 1, type: type, value: TimeSpan.fromHours(1.5)}},
				{ input: "12 mins", output: { score: 1, type: type, value: TimeSpan.fromHours(0.2)}},
				{ input: "4hrs 30mins", output: { score: 1, type: type, value: TimeSpan.fromHours(4.5)}},
				{ input: "6 minutes", output: { score: 1, type: type, value: TimeSpan.fromHours(0.1)}},
				{ input: "38 mins", output: { score: 1, type: type, value: TimeSpan.fromHours(38 / 60)}}, //ratio
				/*{ input: "1:45", output: { score: 1, type: type, value: TimeSpan.fromHours(1.75)}}
				*/]);
		}

		public static function processForParameterizedTesting(testCases:Array):Array {
			var result:Array = [];
			for each (var testCase:Object in testCases) {
				var parameterizedTestCase:Array = [ testCase.input, testCase.output ];
				result.push(parameterizedTestCase);
			}
			return result;
		}

		public static function timeSpanTestCases():Array {
			return [[ "1h20m", "1:20" ], [ "0h5m", "0:5" ], [ "1m", ":1" ], [ "10h", "10:" ]];
		}

		private var m:IMatcher;

		private var foo:Parameterized;

		[Before]
		public function setUp():void {
			m = new TimeSpanMatcher();
		}

		[After]
		public function tearDown():void {
			m = null;
		}


		[Test(dataProvider = "timeSpanMatchTestCases")]
		public function matchTimeSpans(inputString:String, expectedResult:Object):void {
			var actualResult:Match = m.match(inputString);
			var expectedScore:Number = expectedResult.score as Number;
			assertThat(expectedScore, equalTo(actualResult.score));
			if (expectedScore == 0)
				return;
			var expectedType:String = type;
			assertThat(expectedType, equalTo(actualResult.type));
			var expectedTimeSpan:TimeSpan = TimeSpan(expectedResult.value);
			assertThat(actualResult.value.totalMilliseconds, equalTo(expectedTimeSpan.totalMilliseconds));
		}

		/*		[Test(dataProvider = "timeSpanTestCases")]
		*/
		public function testTimeSpanTestCases(input:String, expectedResult:String):void {
			//var regExp:RegExp = /(\d)+h(\d+)m/g;
			//var regExp:RegExp = /(?P<hours>(\d+)h{0,1})(?P<minutes>\d+)m/;
			var regExp:RegExp = /(\d*)(?:h)?(\d*)(?:m)?/;
			var actualResult:String = input.replace(regExp, "$1:$2");
			//var actualResult:Array = regExp.exec(input);
			/*var hours:String = actualResult.hours;
			var minutes:String = actualResult.minutes;
			trace(hours, minutes);*/
			assertThat(actualResult, equalTo(expectedResult));
		}

		[Test]
		public function inputTimeToFormattedTime():void {
			var input:String = "2h 10m";
			var match:Match = m.match(input);
			var timeSpan:TimeSpan = TimeSpan(match.value);
			var hours:Number = timeSpan.totalMinutes / 60;
			var formatter:TimeSpanFormatter = new TimeSpanFormatter();
			var actualResult:String = formatter.format(MinutePrecisionTimeSpan.fromHours(hours));
			assertThat(actualResult, equalTo(input));
		}

		[Test]
		public function inputTimeDecimalHours():void {
			var input:String = "0.5h";
			var match:Match = m.match(input);
			var actualResult:TimeSpan = TimeSpan(match.value);
			var expectedResult:TimeSpan = TimeSpan.fromHours(0.5);
			assertThat(actualResult.totalMilliseconds, equalTo(expectedResult.totalMilliseconds));
		}
	}
}
