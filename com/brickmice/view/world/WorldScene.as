package com.brickmice.view.world
{
	import com.brickmice.data.Consts;
	import com.brickmice.data.Data;
	import com.brickmice.view.ViewMessage;
	import com.framework.core.ViewManager;
	import com.framework.ui.basic.CScene;
	
	import flash.events.Event;

	/**
	 * @author derek
	 */
	public class WorldScene extends CScene
	{
		/**
		 * 场景名字
		 */
		public static const NAME:String = "WorldScene";
		private var _content:World;

		/**
		 * 银河场景
		 */
		public function WorldScene()
		{
			// 构造银河
			_content = new World();

			super(NAME, _content.cWidth, _content.cHeight);

			// 设置场景内容
			setContent(_content);
			
			//发送菜单栏提示信息
			ViewManager.sendMessage(ViewMessage.ENTER_WORLD);

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

			_content.x = Data.data.user.union == 1 ? 0 : (cWidth - _content.cWidth);
			_content.y = (cHeight - _content.cHeight) / 2;
		}
	}
}
