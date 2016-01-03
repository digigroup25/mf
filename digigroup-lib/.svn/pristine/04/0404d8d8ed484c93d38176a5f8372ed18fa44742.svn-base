package converters {

	public class XmlCollectionConverterFactory {
		public static function create(version:String):IXmlConverter {
			switch (version) {
				case "1.0":
					return new XmlCollectionConverter_1_0();
				case "1.1":
					return new XmlCollectionConverter_1_1();
				case "1.2":
					return new XmlCollectionConverter_1_2();
				default:
					throw Error("XmlCollectionConverter with version " + version + " does not exist");
			}
			return null;
		}

		public static function createLatest():IXmlConverter {
			return create("1.2");
		}
	}
}
