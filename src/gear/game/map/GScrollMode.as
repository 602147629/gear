﻿package gear.game.map {
	/**
	 * @author bright
	 * @version 20121127
	 */
	public class GScrollMode {
		private static var _list : Array = ["卷轴", "水平", "垂直"];
		public static const PARALLAX : int = 0;
		public static const H_ROLL : int = 1;
		public static const V_ROLL : int = 2;

		public static function getType(value : String) : int {
			return _list.indexOf(value);
		}
	}
}
