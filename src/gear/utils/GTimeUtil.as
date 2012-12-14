﻿package gear.utils {
	import gear.log4a.GLogger;

	import flash.utils.getTimer;

	/**
	 * 时间工具类
	 * 
	 * @author bright
	 * @version 20121112
	 */
	public final class GTimeUtil {
		private static var _time : int;

		public static function start() : void {
			_time = getTimer();
		}

		public static function end(prefix : String = "") : void {
			GLogger.debug(prefix + "运行 " + (getTimer() - _time) + " ms.");
		}
	}
}
