package com.framework.ui.component
{
	import flash.events.MouseEvent;

	/**
	 * 管理radiobutton的组
	 * 对radiobutton的操作应该在这里统一进行.
	 * 
	 */
	public class RadioButtonGroup
	{
		/**
		 * 构造函数
		 * 
		 * @param onChanged 当修改了按钮的状态时候的回调函数.格式: onChanged(id:String,index:int):void; id=被选中项的ID.index = 当前项的INDEX
		 */
		public function RadioButtonGroup(onChanged : Function = null)
		{
			this._buttons = new Vector.<RadioButton>();
			this._onChanged = onChanged;
		}

		/**
		 * 加入一个新的raido
		 * 
		 * @param btn raidobutton
		 */
		public function addButton(btn : RadioButton) : void
		{
			if (_buttons.indexOf(btn) > -1)
			{
				throw 'radiogroup:重复的ID';
				return;
			}
			_buttons.push(btn);
			btn.click = setSelected;
		}

		/**
		 * 移出指定按钮
		 * 
		 * @param btn raidobutton
		 */
		public function removeButton(btn : RadioButton) : void
		{
			if (_buttons.indexOf(btn) > -1)
			{
				return;
			}
			;
			_buttons.splice(_buttons.indexOf(btn), 1);
		}

		/**
		 * 当前选中项的id
		 */
		public function get select() : String
		{
			for each (var sBtn:RadioButton in this._buttons)
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
		 * 设置选中项.如果INDEX非法.则取消选择
		 */
		public function set index(value : int) : void
		{
			var len : int = _buttons.length;

			for (var i : int = 0; i < len; i++)
			{
				_buttons[i].select = (i == value);
			}
		}

		/**
		 * 获取被选中的INDEX.没有选中项则为 -1
		 */
		public function get index() : int
		{
			var len : int = _buttons.length;

			for (var i : int = 0; i < len; i++)
			{
				if (_buttons[i].select)
					return i;
			}

			return -1;
		}

		/**
		 * 设置选中项
		 */
		public function set select(id : String) : void
		{
			// 根据ID获取按钮

			var btn : RadioButton = getBtnById(id);

			// 如果没有这个按钮.则报错
			if (btn == null)
			{
				throw 'RadioButton id:' + id + '不存在';
				return;
			}
			// 如果按钮已经被选择.退出
			if (btn.select)
				return;

			// 按钮长度

			var len : int = _buttons.length;

			// 所有按钮设置为FALSE
			for (var i : int = 0; i < len; i++)
			{
				_buttons[i].select = false;
			}

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
		private function setSelected(event : MouseEvent) : void
		{
			var btn : RadioButton = event.target as RadioButton;

			select = btn.id;
		}

		/**
		 * 通过ID来获取按钮
		 * 
		 * @param id id
		 */
		private function getBtnById(id : String) : RadioButton
		{
			var len : int = _buttons.length;

			for (var i : int = 0; i < len; i++)
			{
				if (_buttons[i].id == id)
					return _buttons[i];
			}

			return null;
		}

		/**
		 * 按钮列表
		 */
		private var _buttons : Vector.<RadioButton>;
		/**
		 * 当修改了选择想的CALLBACK.格式参见构造函数说明
		 */
		private var _onChanged : Function;
	}
}