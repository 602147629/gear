﻿package gear.gui.controls {
	import gear.gui.core.GBase;
	import gear.gui.core.GPhase;
	import gear.gui.group.GToggleGroup;

	import flash.events.MouseEvent;

	/**
	 * 双模基础控件
	 * 
	 * @author bright
	 * @version 20101018
	 */
	public class GToggleBase extends GBase {
		protected var _phase:int;
		protected var _selected : Boolean = false;
		protected var _group : GToggleGroup;
		
		protected function viewSkin():void{			
		}

		protected function onSelect() : void {
		}
		
		override protected  function onShow() : void {
			super.onShow();
			addEvent(this, MouseEvent.ROLL_OVER, mouseHandler);
			addEvent(this, MouseEvent.ROLL_OUT, mouseHandler);
			addEvent(this, MouseEvent.MOUSE_DOWN, mouseHandler);
			addEvent(this, MouseEvent.MOUSE_UP, mouseHandler);
		}
		
		protected function mouseHandler(event : MouseEvent) : void {
			event.stopPropagation();
			if (!_enabled) {
				return;
			}
			if (event.type == MouseEvent.ROLL_OVER) {
				_phase = GPhase.OVER;
			} else if (event.type == MouseEvent.ROLL_OUT) {
				_phase = GPhase.UP;
			} else if (event.type == MouseEvent.MOUSE_DOWN) {
				_phase = GPhase.DOWN;
			} else if (event.type == MouseEvent.MOUSE_UP) {
				_phase = (event.currentTarget == this) ? GPhase.OVER : GPhase.UP;
				if (_group!=null) {
					if (!_selected) {
						selected = true;
					}
				} else {
					selected = !_selected;
				}
			}
			addRender(viewSkin);
		}

		public function GToggleBase() {
		}

		/**
		 * 设置选中状态
		 * 
		 * @param value 是否选中
		 */
		public function set selected(value : Boolean) : void {
			if (_selected == value) {
				return;
			}
			_selected = value;
			if (_group != null && _selected) {
				_group.selected(this);
			}
			onSelect();
		}

		/**
		 * 获得选中状态
		 * 
		 * @return 是否选中
		 */
		public function get selected() : Boolean {
			return _selected;
		}

		/**
		 * 设置组
		 * 
		 * @param value 双模组
		 */
		public function set group(value : GToggleGroup) : void {
			_group = value;
		}
	}
}