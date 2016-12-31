package com.framework.ui.sprites
{
	import flash.display.DisplayObject;

	/**
	 * 物品窗口.在关闭窗口的时候.会自动执行callback.
	 *
	 * @author derek
	 */
	public class CItemWindow extends CWindow
	{
		/**
		 *
		 * @param name
		 * @param w
		 * @param h
		 * @param bg
		 * @param closeBtn
		 * @param closeBtnXoffset
		 * @param closeBtnYoffset
		 * @param headHeight
		 *
		 */
		public function CItemWindow(name:String, w:uint, h:uint, bg:DisplayObject, closeBtn:CButton, closeBtnXoffset:int, closeBtnYoffset:int, headHeight:int = 0)
		{
			super(name, w, h, bg, closeBtn, closeBtnXoffset, closeBtnYoffset, headHeight);
			
			if (getIndex == null || lockCallback == null || unlockAllItemCallback == null)
			{
				throw '类3个静态回调函数没有初始化';
			}
			
			// 关闭窗口的回调函数
			super.onClosed = unlockAllItemCallback(_lockItems);
		}
		
		/**
		 * 锁定物品
		 *
		 * @param item 物品信息
		 */
		public function lockItem(item:*):void
		{
			if (getIndex(_lockItems, item) >= 0)
				return;
			
			_lockItems.push(item);
			
			// 回调
			lockCallback(item, true);
		}
		
		/**
		 * 解锁物品
		 *
		 * @param item 物品信息
		 */
		public function unlockItem(item:*):void
		{
			// 获取物品index
			var index:int = getIndex(_lockItems, item);
			
			if (index < 0)
				return;
			
			// 移除之
			_lockItems.splice(index, 1);
			
			// 回调
			lockCallback(item, false);
		}
		
		/**
		 * 获取物品的index的回调函数.格式应该为: getIndex(arr:Array,item:*):int;
		 * arr:数组.item:指定物品. 返回int:该item在arr的index.
		 */
		public static var getIndex:Function;

		public override function removeSelf():void
		{
			super.removeSelf();
			unlockAllItemCallback(_lockItems);
		}

		/**
		 * 锁定/解锁物品的callback.格式 lockCallback(item:*,lock:Boolean):void;
		 * 	item:物品信息   lock:是否锁定
		 */
		public static var lockCallback:Function;
		/**
		 * 窗口被关闭的时候的回调函数.格式  unlockAllItemCallback(items:Array):void;
		 *
		 * items为所有应该被解锁的物品列表.
		 */
		public static var unlockAllItemCallback:Function;
		/**
		 * 所有应该被解锁的item列表
		 */
		private var _lockItems:Array = [];

	
	}
}
