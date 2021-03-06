﻿package gear.log4a {
	/**
	 * 日志格式化输出接口
	 * 
	 * @author bright
	 * @version 20121105
	 */
	public interface IGLogFormatter {
		/**
		 * 格式化输出
		 * 
		 * @param data 日志数据
		 * @param separator 行分隔符 @default "\n"
		 */
		function format(data : GLogData, separator : String = "\n"):String;
	}
}