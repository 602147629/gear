﻿package gear.gui.controls {
	import gear.gui.core.GBase;
	import gear.gui.core.GPhase;
	import gear.gui.core.GScaleMode;
	import gear.gui.skins.GHScrollBarSkin;
	import gear.gui.skins.IGSkin;
	import gear.log4a.GLogger;
	import gear.utils.GMathUtil;

	import flash.display.BitmapData;
	import flash.events.MouseEvent;

	/**
	 * 滚动条控件
	 * 
	 * @author bright
	 * @version 20130118
	 */
	public class GHScrollBar extends GBase {
		protected var _trackSkin : IGSkin;
		protected var _thumbSkin : IGSkin;
		protected var _thumbIcon : BitmapData;
		protected var _upSkin : IGSkin;
		protected var _downSkin : IGSkin;
		protected var _thumb_btn : GButton;
		protected var _up_btn : GButton;
		protected var _down_btn : GButton;
		protected var _track_btn : GButton;
		protected var _direction : int;
		protected var _thumbScrollOffset : int;
		protected var _position : int;
		protected var _pageSize : int;
		protected var _min : int;
		protected var _max : int;
		protected var _value : int;
		protected var _step : int;
		protected var _repeatDelay : int;
		protected var _onValueChange : Function;

		override protected function preinit() : void {
			_trackSkin = GHScrollBarSkin.trackSkin;
			_thumbSkin = GHScrollBarSkin.thumbSkin;
			_thumbIcon = GHScrollBarSkin.thumbIcon;
			_upSkin = GHScrollBarSkin.upSkin;
			_downSkin = GHScrollBarSkin.downSkin;
			_scaleMode = GScaleMode.FIT_HEIGHT;
			_min = 0;
			_max = 20;
			_pageSize = 10;
			_value = 0;
			_step = 1;
			forceSize(100, 15);
			callLater(resize);
		}

		override protected function create() : void {
			_track_btn = new GButton();
			_track_btn.skin = _trackSkin;
			addChild(_track_btn);
			_thumb_btn = new GButton();
			_thumb_btn.skin = _thumbSkin;
			_thumb_btn.icon = _thumbIcon;
			addChild(_thumb_btn);
			_up_btn = new GButton();
			_up_btn.skin = _upSkin;
			_up_btn.width = _upSkin.width;
			addChild(_up_btn);
			_down_btn = new GButton();
			_down_btn.skin = _downSkin;
			_down_btn.width = _downSkin.width;
			addChild(_down_btn);
		}

		override protected function resize() : void {
			_up_btn.height = _height;
			_down_btn.height = _height;
			_down_btn.x = _width - _down_btn.width;
			_track_btn.x = _up_btn.width;
			_track_btn.setSize(_width - _up_btn.width - _down_btn.width, _height);
			_thumb_btn.x = _up_btn.width;
			_thumb_btn.height = _track_btn.height;
			callLater(updateThumb);
		}

		override protected function onEnabled() : void {
			_track_btn.enabled = _enabled;
			_thumb_btn.enabled = _enabled;
			_thumb_btn.visible = _enabled;
			_up_btn.enabled = _enabled;
			_down_btn.enabled = _enabled;
		}

		override protected function onShow() : void {
			_up_btn.onClick = onArrowClick;
			_down_btn.onClick = onArrowClick;
			addEvent(_track_btn, MouseEvent.MOUSE_DOWN, track_mouseDownHandler);
			_thumb_btn.addEventListener(MouseEvent.MOUSE_DOWN, thumb_mouseDownHandler);
		}

		protected function onArrowClick(target : GButton) : void {
			if (target == _up_btn) {
				value = _value - _step;
			} else if (target == _down_btn) {
				value = _value + _step;
			}
		}

		protected function track_mouseDownHandler(event : MouseEvent) : void {
			if (mouseX < _thumb_btn.x) {
				value = _value - _pageSize;
			} else if (mouseX > _thumb_btn.right) {
				value = _value + _pageSize;
			}
		}

		protected function thumb_mouseDownHandler(event : MouseEvent) : void {
			mouseChildren = false;
			_thumb_btn.lockPhase = GPhase.DOWN;
			_thumbScrollOffset = mouseX - _thumb_btn.x;
			addEvent(stage, MouseEvent.MOUSE_MOVE, stage_mouseMoveHandler);
			addEvent(stage, MouseEvent.MOUSE_UP, mouseUpHandler);
			addEvent(_thumb_btn, MouseEvent.MOUSE_UP, mouseUpHandler);
		}

		protected function stage_mouseMoveHandler(event : MouseEvent) : void {
			_position = GMathUtil.clamp(mouseX - _thumbScrollOffset, _up_btn.width, _up_btn.width + _track_btn.width - _thumb_btn.width);
			value = (_position - _up_btn.width) / (_track_btn.width - _thumb_btn.width) * (_max - _min) + _min;
		}

		protected function mouseUpHandler(event : MouseEvent) : void {
			mouseChildren = true;
			_thumb_btn.lockPhase = GPhase.NONE;
			removeEvent(stage, MouseEvent.MOUSE_MOVE);
			removeEvent(stage, MouseEvent.MOUSE_UP);
			removeEvent(_thumb_btn, MouseEvent.MOUSE_UP);
		}

		protected function updateThumb() : void {
			var range : int = _max - _min;
			_thumb_btn.width = Math.max(12, _pageSize / ( range + _pageSize) * _track_btn.width);
			_thumb_btn.x = _up_btn.width + (_value - _min) / range * (_track_btn.width - _thumb_btn.width);
		}

		public function GHScrollBar() {
		}

		public function set onValueChange(value : Function) : void {
			_onValueChange = value;
		}

		public function setTo(newPageSize : int, newMax : int, newValue : int, newMin : int = 0) : void {
			var isUpdate : Boolean = false;
			if (_pageSize != newPageSize) {
				_pageSize = newPageSize;
				isUpdate = true;
			}
			if (_max != newMax) {
				_max = newMax;
				isUpdate = true;
			}
			if (_min != newMin) {
				_min = newMin;
				isUpdate = true;
			}
			newValue = GMathUtil.clamp(newValue, _min, _max);
			if (_value != newValue) {
				value = newValue;
				isUpdate = true;
			}
			if (isUpdate) {
				callLater(updateThumb);
			}
		}

		public function set value(newValue : int) : void {
			newValue = GMathUtil.clamp(newValue, _min, _max);
			if (_value == newValue) {
				return;
			}
			_value = newValue;
			if (_onValueChange != null) {
				try {
					_onValueChange();
				} catch(e : Error) {
					GLogger.error(e.getStackTrace());
				}
			}
			callLater(updateThumb);
		}

		public function get value() : int {
			return _value;
		}
	}
}