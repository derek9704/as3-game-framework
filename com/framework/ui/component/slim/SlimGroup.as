package com.framework.ui.component.slim
{
	import flash.utils.*;

	/**
	 * 管理radiobutton的组
	 * 对radiobutton的操作应该在这里统一进行.
	 * 
	 */
	public class SlimGroup
	{
		/**
		 * 构造函数
		 * 
		 * @param onChanged 当修改了按钮的状态时候的回调函数.格式: onChanged(id:String,index:int):void; id=被选中项的ID.index = 当前项的INDEX
		 */
		public function SlimGroup(onChanged : Function = null)
		{
			_buttons = new Dictionary();
			_onChanged = onChanged;
		}

		/**
		 * 加入一个新的raido
		 * 
		 * @param btn raidobutton
		 */
		public function addButton(btn : SlimSwitchButton) : void
		{
			if (_buttons[btn.id] != null)
			{
				throw 'radiogroup:重复的ID';
				return;
			}
			_buttons[btn.id] = btn;

			btn.click = setSelected;
		}

		public function clear() : void
		{
			_buttons = new Dictionary();
		}

		/**
		 * 移出指定按钮
		 * 
		 * @param btn raidobutton
		 */
		public function removeButton(btn : SlimSwitchButton) : void
		{
			if (_buttons[btn.id] != null)
			{
				return;
			}
			;
			delete _buttons[btn.id];
		}

		/**
		 * 当前选中项的id
		 */
		public function get select() : *
		{
			for each (var sBtn:SlimSwitchButton in this._buttons)
			{
				if (sBtn.select)
				{
					return sBtn.id;
				}
			}
			;

			return null;
		}

		/**
		 * 设置选中项
		 */
		public function set select(id : *) : void
		{
			// 根据ID获取按钮

			var btn : SlimSwitchButton = _buttons[id];

			// 如果没有这个按钮.则报错
			if (btn == null)
			{
				throw 'RadioButton id:' + id + '不存在';
				return;
			}
			// 如果按钮已经被选择.退出
			if (btn.select)
				return;

			for each (var sBtn:SlimSwitchButton in this._buttons)
			{
				sBtn.select = false;
			}
			;

			// 选中项为TRUE
			btn.select = true;

			// 如果有CALLBACK.则调用之
			if (_onChanged != null)
			{
				_onChanged(btn.id, _buttons.indexOf(btn));
			}
		}

		/**
		 * 设置某项被选择
		 * 
		 * @param event
		 */
		private function setSelected(id : *) : void
		{
			select = id;
		}

		/**
		 * 按钮列表
		 */
		private var _buttons : Dictionary;
		/**
		 * 当修改了选择想的CALLBACK.格式参见构造函数说明
		 */
		private var _onChanged : Function;
	}
}