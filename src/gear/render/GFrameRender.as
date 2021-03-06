﻿package gear.render {
	import gear.log4a.GLogger;
	import gear.log4a.GLogError;

	import flash.display.Stage;
	import flash.events.Event;
	import flash.utils.getTimer;

	/**
	 * 帧渲染控制器
	 * 
	 * @author bright
	 * @version 20121107
	 */
	public class GFrameRender {
		public static var elapsed : int;
		private static var _creating : Boolean = false;
		private static var _instance : GFrameRender;
		private var _stage : Stage;
		private var _list : Array;
		private var _running : Boolean;
		private var _lastTime : int;
		private var _nowTime : int;
		private var _pause : Boolean;
		private var _onLast : Function;

		private function init() : void {
			_list = new Array();
			_running = false;
			_pause = false;
		}

		private function enterFrameHandler(event : Event) : void {
			render();
		}

		private function activateHandler(event : Event) : void {
			_lastTime = getTimer();
		}

		public function GFrameRender() {
			if (!_creating) {
				throw (new GLogError("Class cannot be instantiated.Use RenderControl.instance instead."));
			}
			init();
		}

		public static function get instance() : GFrameRender {
			if (_instance == null) {
				_creating = true;
				_instance = new GFrameRender();
				_creating = false;
			}
			return _instance;
		}

		public function set stage(value : Stage) : void {
			if (_stage == value) {
				return;
			}
			_stage = value;
			_stage.addEventListener(Event.ACTIVATE, activateHandler);
		}

		public function render() : void {
			_nowTime = getTimer();
			elapsed = _nowTime - _lastTime;
			_lastTime = getTimer();
			for each (var frame : IGFrame in _list) {
				frame.refresh();
			}
			if (_onLast is Function) {
				try {
					_onLast();
				} catch(e : Error) {
					GLogger.error(e.getStackTrace());
				}
			}
		}

		public function add(value : IGFrame) : void {
			if (value == null) {
				return;
			}
			if (_list.indexOf(value) != -1) {
				return;
			}
			_list.push(value);
			if (!_pause && !_running) {
				_running = true;
				_lastTime = getTimer();
				_stage.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
			}
		}

		public function remove(value : IGFrame) : void {
			var index : int = _list.indexOf(value);
			if (index == -1) {
				return;
			}
			_list.splice(index, 1);
			if (_list.length < 1 && _running) {
				_running = false;
				_stage.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
			}
		}

		public function has(value : IGFrame) : Boolean {
			return _list.indexOf(value) != -1;
		}

		public function set onLast(value : Function) : void {
			_onLast = value;
		}

		/**
		 * 暂停
		 */
		public function set pause(value : Boolean) : void {
			if (_pause == value) {
				return;
			}
			_pause = value;
			if (_pause) {
				if (_running) {
					_running = false;
					_stage.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
				}
			} else if (_list.length > 0 && !_running) {
				_running = true;
				_stage.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
			}
		}

		public function get pause() : Boolean {
			return _pause;
		}

		public function get running() : Boolean {
			return _running;
		}
	}
}
