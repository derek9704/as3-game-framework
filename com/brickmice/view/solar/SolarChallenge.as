package com.brickmice.view.solar
{
	import com.brickmice.ModelManager;
	import com.brickmice.data.Data;
	import com.brickmice.view.ViewMessage;
	import com.brickmice.view.component.BmButton;
	import com.brickmice.view.component.BmWindow;
	import com.brickmice.view.component.McTip;
	import com.framework.core.Message;
	import com.framework.core.ViewManager;
	import com.framework.utils.TipHelper;
	
	import flash.display.MovieClip;
	import flash.utils.getDefinitionByName;

	public class SolarChallenge extends BmWindow
	{
		/**
		 * 窗口名字.
		 */
		public static const NAME : String = "SolarChallenge";
		
		private var _mc:MovieClip;
		private var _gid:int;
		
		public function SolarChallenge(gid:int)
		{
			// 初始化并加入资源
			var cls:Object =  getDefinitionByName('ResSolarG' + (gid > 2 ? gid - 2 : gid) + 'Challenge');
			_mc = new cls;
			super(NAME, _mc);
			
			var prizeBtn:BmButton = new BmButton(_mc._prizeBtn, function():void{
				ModelManager.solarModel.getSolarDailyPrize();
				prizeBtn.enable = false;
			});
			
			var num:String = Data.data.user.vip >= 5 ? '200' : '100';
			TipHelper.setTip(_mc._prizeBtn, new McTip('通关任意一个星球所有挑战关卡后开启，每个星球每天可兑换' + num + '天赋石。'));
			
			var flag:int = Data.data.solar.prizeFlag;
			if(flag == 1){
				prizeBtn.enable = false;
			}else{
				var arr:Object = Data.data.solar.challenge;
				var foo:Boolean = false;
				for each (var i:Object in arr) 
				{
					foo = true;
					for (var j:int = 1; j <= 5; j++) 
					{
						if(!i[j] || !i[j]['flag']){
							foo = false;
							break;
						}
					}
					if(foo) {
						break;
					}
				}
				if(!foo) {
					prizeBtn.enable = false;
				}
			}

			setData(gid);
		}
		
		private function setData(gid:int):void
		{
			_gid = gid;
			var data:Object = Data.data.solar.challenge;
			var openPlanet:int = Data.data.solar.openPlanet;
			var openLevel:int = Data.data.solar.openLevel;
			var flag:Boolean;
			var count:int;
			for (var i:int = 1; i <= 10; i++) 
			{
				var pid:int = (_gid - 1) * 10 + i;
				//还未开放
				if(pid >= openPlanet && pid != 20){
					_mc['_' + i].gotoAndStop(5);
					continue;
				}
				if(pid == 20 && (openPlanet != 20 || openLevel != 15)){
					_mc['_' + i].gotoAndStop(5);
					continue;
				}
				//是否全部攻关完成
				count = 0;
				flag = true;
				if(data && data[pid]) {
					for each (var o:Object in data[pid]) 
					{
						count++;
						if(o['flag'] != 1) {
							flag = false;
							break;
						}
					}
					if(count == 5 && flag) {
						_mc['_' + i].gotoAndStop(4);
						_mc['_' + i].mouseEnabled = false;
						continue;
					}
				}
				//尚有未攻关项目
				setLevel(i);
			}
		}

		private function setLevel(pos:int):void
		{
			new BmButton(_mc['_' + pos], function():void{
				var pid:int = (_gid - 1) * 10 + pos;
				var pName:String = Data.data.solar.galaxy[_gid].planet[pid].name;
				ModelManager.solarModel.getSolarChallengeData(pid, function():void{
					if (ViewManager.hasView(SolarChallengeInfo.NAME)) return;
					var win:BmWindow = new SolarChallengeInfo(_gid, pid);
					addChildCenter(win);
				});
			});
		}

	}
}