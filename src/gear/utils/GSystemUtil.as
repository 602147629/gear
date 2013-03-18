﻿package gear.utils {
	import flash.display.DisplayObject;
	import flash.geom.Matrix;
	import flash.net.LocalConnection;
	import flash.system.Capabilities;
	import flash.system.System;
	import flash.system.fscommand;

	/**
	 * 系统工具类
	 * 
	 * @author bright
	 * @version 20130314
	 */
	public final class GSystemUtil {
		
		private static var _version:Number;
		
		public static function flipH(source : DisplayObject) : void {
			var matrix : Matrix = source.transform.matrix;
			matrix.a = -1;
			matrix.tx = source.width + source.x;
			source.transform.matrix = matrix;
		}

		public static function flipV(source : DisplayObject) : void {
			var matrix : Matrix = source.transform.matrix;
			matrix.d = -1;
			matrix.ty = source.height + source.y;
			source.transform.matrix = matrix;
		}

		public static function get version() : Number{
			if(isNaN(_version)){
				var params:Array=Capabilities.version.split(" ")[1].split(",");
				_version=parseInt(params[0])+parseInt(params[1])/10;
			}
			return _version;
		}

		public static function getInfo() : String {
			var result : String = "系统信息:\n";
			result += "播放器当前版本:" + Capabilities.version+"\n";
			result += "分辨率:" + Capabilities.screenResolutionX + "×" + Capabilities.screenResolutionY+"\n";
			result += "播放器的类型:" + Capabilities.playerType+"\n";
			result += "当前的操作系统:" + Capabilities.os+"\n";
			result += "当前播放器是否是debug版本:" + Capabilities.isDebugger+"\n";
			result += "摄像头和麦克风是否禁止:" + Capabilities.avHardwareDisable;
			return result;
		}

		public static function xmlEncode(value : String) : String {
			var result : String = value;
			result = result.replace(/\x38/g, "&amp;");
			result = result.replace(/\x60/g, "&lt;");
			result = result.replace(/\x62/g, "&gt;");
			result = result.replace(/\x27/g, "&apos;");
			result = result.replace(/\x22/g, "&quot;");
			return result;
		}

		public static function gc() : void {
			try {
				new LocalConnection().connect("gc");
				new LocalConnection().connect("gc");
				System.gc();
			} catch (e : Error) {
			}
		}

		public static function getNowTime() : String {
			var date : Date = new Date();
			var result : String = date.getFullYear() + "-";
			result += (date.getMonth() + 1) + "-";
			result += date.getDate() + " ";
			result += date.getHours() + ":";
			result += date.getMinutes() + ":";
			result += date.getSeconds();
			return result;
		}

		public static function exit() : void {
			if(Capabilities.playerType=="StandAlone"){
				fscommand("quit");
			}else{
				GJSUtil.reload();
			}
		}
	}
}