package com.brickmice.view.city
{
	import com.brickmice.view.ViewMessage;
	import com.framework.core.ViewManager;
	import com.framework.ui.basic.CScene;
	
	import flash.events.Event;

	/**
	 * @author derek
	 */
	public class CityScene extends CScene
	{
		/**
		 * 场景名字
		 */
		public static const NAME:String = "CityScene";
		private var _content:City;

		/**
		 * 城市场景
		 */
		public function CityScene()
		{
			// 构造城市
			_content = new City();

			super(NAME, _content.cWidth, _content.cHeight);

			// 设置场景内容
			setContent(_content);
			
			//发送菜单栏提示信息
			ViewManager.sendMessage(ViewMessage.ENTER_CITY);

			// 添加到舞台上的响应
			evts.addedToStage(onAddedToStage);
		}

		/**
		 * 添加到舞台的响应函数
		 */
		private function onAddedToStage(event:Event):void
		{
			// 关闭添加到舞台之后的监听
			evts.removeEventListener(onAddedToStage);

			_content.x = cWidth - _content.cWidth;
			_content.y = cHeight - _content.cHeight;
		}
	}
}
