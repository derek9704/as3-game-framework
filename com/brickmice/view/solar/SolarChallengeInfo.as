package com.brickmice.view.solar
{
	import com.brickmice.data.Data;
	import com.brickmice.view.ViewMessage;
	import com.brickmice.view.component.BmButton;
	import com.brickmice.view.component.BmWindow;
	import com.framework.core.Message;
	import com.framework.core.ViewManager;
	
	import flash.display.MovieClip;

	public class SolarChallengeInfo extends BmWindow
	{
		/**
		 * 窗口名字.
		 */
		public static const NAME : String = "SolarChallengeInfo";
		
		private var _mc:MovieClip;
		private var _pid:int;
		private var _gid:int;
		private var _pName:String;
		
		public function SolarChallengeInfo(gid:int, pid:int)
		{
			_mc = new ResSolarChallengePanel;
			super(NAME, _mc);

			_pid = pid;
			_gid = gid;
			
			_pName = Data.data.solar.galaxy[_gid].planet[_pid].name;
			_mc._title.text = _pName + '挑战关卡';
			
			setData();
		}
		
		private function setData():void
		{
			var data:Object = Data.data.solar.challenge[_pid];
			
			for (var i:int = 1; i <= 5; i++) 
			{
				if(data[i]['flag'] == 1){
					_mc['_' + i].gotoAndStop(2);
					_mc['_' + i]._lvl.text = data[i].houseLevel;
					_mc['_' + i]._count.text = data[i].houseTroop;
					_mc['_' + i]._atk.text = data[i].houseAtk;
					_mc['_' + i]._def.text = data[i].houseDef;
					_mc['_' + i]._challenge.htmlText = data[i].describe;
				}else if(i != 1 && data[i - 1]['flag'] != 1){
					_mc['_' + i].gotoAndStop(3);
				}else{
					_mc['_' + i].gotoAndStop(1);
					_mc['_' + i]._lvl.text = data[i].houseLevel;
					_mc['_' + i]._count.text = data[i].houseTroop;
					_mc['_' + i]._atk.text = data[i].houseAtk;
					_mc['_' + i]._def.text = data[i].houseDef;
					_mc['_' + i]._challenge.htmlText = data[i].describe;
					setBtn(_mc['_' + i]._beginBtn, data[i]);	
				}
			}	
		}

		private function setBtn(btn:MovieClip, data:Object):void
		{
			new BmButton(btn, function():void{
				if (ViewManager.hasView(SolarRaid.NAME)) {
					(ViewManager.retrieveView(SolarRaid.NAME) as SolarRaid).setData(_pid, _pName, data);
				}else{
					var solarRaidWin:BmWindow = new SolarRaid(_pid, _pName, data);
					addChildCenter(solarRaidWin);
				}
			});
		}
		
		/**
		 * 消息监听
		 */
		override public function listenerMessage() : Array
		{
			return [ViewMessage.REFRESH_CHALLENGE];
		}	
		
		/**
		 * 消息捕获
		 */
		override public function handleMessage(message : Message) : void
		{
			switch(message.type)
			{
				case ViewMessage.REFRESH_CHALLENGE:
					setData();
					break;
				default:
			}
		}	
		
	}
}