package com.brickmice.view.component
{
	import com.framework.utils.KeyValue;
	

	/**
	 * @author derek
	 */
	public class BmTabView
	{
		private var _tabs : Vector.<BmTabButton>;
		private var _callback : Function;
		private var _selectedId : int;
		
		/**
		 * 构造函数
		 * 
		 * @param tabs 按钮列表 keyvalue: key:String = 回调id  value :MovieClip = 按钮
		 * @param callback 点击按钮的callback
		 */
		public function BmTabView(tabs : Vector.<KeyValue>, callback : Function)
		{
			_callback = callback;
			_tabs = new Vector.<BmTabButton>();
			
			tabs.forEach(function(item : KeyValue, index : int, list : Vector.<KeyValue>) : void
			{
				// 构造按钮
				var btn : BmTabButton = new BmTabButton(item.key, item.value, resetTabs);
				
				// 加入按钮
				_tabs.push(btn);
			});
			
			// 设置默认第一个激活
			selectIndex = 0;
		}
		
		/**
		 * 重设所有按钮
		 */
		private function resetTabs(id : String = null) : void
		{
			var len : int = _tabs.length;
			
			for (var i : int = 0; i < len; i++)
			{
				if (_tabs[i].id != id)
				{
					_tabs[i].status = 2;
					_selectedId = i;
				}
			}
			
			if (id != null)
				_callback(id);
		}
		
		/**
		 * 根据IDNEX设置选中项
		 */
		public function set selectIndex(index : int) : void
		{
			if (index < 0 || index >= _tabs.length)
				throw '指定的INDEX超出了范围';
			
			resetTabs();
			_tabs[index].status = 1;
		}	
		
		/**
		 * 根据IDNEX获取选中项
		 */
		public function getIndexTab(index : int) : BmTabButton
		{
			if (index < 0 || index >= _tabs.length)
				throw '指定的INDEX超出了范围';
			return _tabs[index];
		}	
		
		/**
		 * 隐藏所有按钮
		 */
		public function hideAllTab() : void
		{
			for each(var one:BmTabButton in _tabs){
				one.visible = false;
			}
		}			
		
		/**
		 * 根据ID设置当前的选中项
		 */
		public function set selectId(id : String) : void
		{
			var len : int = _tabs.length;
			
			for (var i : int = 0; i < len; i++)
			{
				if (_tabs[i].id == id)
				{
					resetTabs();
					_tabs[i].status = 1;
				}
			}
		}
		
		public function get selectedIndex() : int
		{
			return _selectedId;
		}
		
		public function get selectedId() : String
		{
			if (_selectedId < 0 || _selectedId >= _tabs.length)
				return null;
			
			return _tabs[_selectedId].id;
		}
	}
}
