package com.brickmice.model
{
	import com.brickmice.data.Consts;
	import com.brickmice.data.Data;
	import com.brickmice.data.GameService;
	
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;

	/**
	 * @author derek
	 */
	public class UserModel
	{
		
		/**
		 * 处理服务器的确认请求 
		 */
		public function responseConfirm(action:String, args:Object, callBack:Function):void
		{
			// 请求
			var obj:Object = {"action":action, "args":args};
			// 发送请求
			GameService.request([obj], function():void{
				if(callBack != null) callBack();
			});
		}
		
		/**
		 * 初始化用户数据
		 */
		public function initUser(callback:Function):void
		{
			// 请求
			var obj:Object = {"action":"requestPlayerData", "args":{}};
			// 发送请求
			GameService.request([obj], function():void
			{
				callback();
			}, null, true, true);
		}
		
		/**
		 * 切换用户音效
		 */
		public function switchMusic():void
		{
			// 请求
			var obj:Object = {"action":"switchMusic", "args":{}};
			// 发送请求
			GameService.request([obj]);
		}
		
		/**
		 * 切换跳过攻关动画
		 */
		public function skipResearchAnim():void
		{
			// 请求
			var obj:Object = {"action":"skipResearchAnim", "args":{}};
			// 发送请求
			GameService.request([obj]);
		}
		
		/**
		 * 增加建筑点
		 */
		public function buyUnitPoint():void
		{
			// 请求
			var obj:Object = {"action":"buyUnitPoint", "args":{}};
			// 发送请求
			GameService.request([obj]);
		}
		
		/**
		 * 查看其他玩家信息
		 */
		public function getOtherUserData(id:int, callBack:Function):void
		{
			var obj:Object = {"action":"getOtherUserData", "args":{id:id}};
			GameService.request([obj], function():void{
				callBack();
			});
		}

		private var timeoutId:int = 0;

		/**
		 * 开始心跳
		 */
		public function startHeartbeat():void
		{
			if (timeoutId)
				clearTimeout(timeoutId);
			var obj:Object = {"action":"heartbeat", "args":{}};
			// 请求,如果心跳可执行
			if (Consts.heartBool)
			{
				GameService.request([obj], null, null, false, false);
				// 请求成功,6秒之后再次心跳
				timeoutId = setTimeout(startHeartbeat, 6000);
			}
			else
			{
				timeoutId = setTimeout(startHeartbeat, 6000);
			}
		}
	}
}
