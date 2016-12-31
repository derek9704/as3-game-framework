package com.brickmice.view.solar
{
	import com.brickmice.ControllerManager;
	import com.brickmice.ModelManager;
	import com.brickmice.data.Data;
	import com.brickmice.view.ViewMessage;
	import com.brickmice.view.component.BmButton;
	import com.brickmice.view.component.BmWindow;
	import com.brickmice.view.component.McImage;
	import com.brickmice.view.component.McTip;
	import com.framework.core.ViewManager;
	import com.framework.ui.basic.CScene;
	import com.framework.ui.basic.layer.CLayer;
	import com.framework.utils.TipHelper;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * @author derek
	 */
	public class SolarScene extends CScene
	{
		/**
		 * 场景名字
		 */
		public static const NAME:String = "SolarScene";
		private var _content:Solar;
		private var _uiLayer:CLayer;
		private var _solarInfo:MovieClip;
		private var _gid:int;
		private var _headImg:McImage;
		
		/**
		 * 试炼场景
		 */
		public function SolarScene()
		{
			var openPlanet:int = Data.data.solar.openPlanet;
			_gid = Math.floor((openPlanet - 1) / 10) + 1;
			// 构造试炼场景
			_content = new Solar(_gid);

			super(NAME, _content.cWidth, _content.cHeight);

			// 设置场景内容
			setContent(_content);
			
			//layer
			_uiLayer = new CLayer();
			addChildEx(_uiLayer);
			
			//加入信息框
			_solarInfo = new ResSolarInfo();
			_uiLayer.addChildEx(_solarInfo);
			_solarInfo._equipCombineCount.text = Data.data.equip.centrifuge;
			_solarInfo._tickets.text = Data.data.solar.point + " / " + Data.data.solar.maxPoint;
			_solarInfo._talentStoneCount.text = Data.data.solar.stone ? Data.data.solar.stone : '0';
			_solarInfo._galaxyName.text = Data.data.solar.galaxy[_gid].name;
			setChallengeNum();
			
			new BmButton(_solarInfo._chooseGalaxyBtn, function():void{
				if (ViewManager.hasView(SelectGalaxy.NAME)) return;
				var selectGalaxyWin:BmWindow = new SelectGalaxy(_gid, function(gid:int):void{
					_gid = gid;
					_content.setContent(gid);
					setChallengeNum();
					_solarInfo._galaxyName.text = Data.data.solar.galaxy[gid].name;
				});
				addChildCenter(selectGalaxyWin);
			});
			
			new BmButton(_solarInfo._buyTicketsBtn, function():void{
				ModelManager.solarModel.buySolarPoint();
			});
			var tip:String = '';
			tip += "试炼次数恢复间隔：" + Data.data.solar.recoverPointInterval + "秒<br>";
			tip += "花费" + Data.data.solar.buyPointCost + "宇宙钻购买" + Data.data.solar.buyPointCount + "试炼次数";
			TipHelper.setTip(_solarInfo._buyTicketsBtn, new McTip(tip));
			
			var btn:BmButton = new BmButton(_solarInfo._equipCombineBtn, function():void{
				ControllerManager.equipCombineController.showEquipCombine();
			});
			if(Data.data.user.techLevel < 14){
				btn.enable = false;
				TipHelper.setTip(_solarInfo._equipCombineBtn, new McTip("科技等级14级开启"));
			}
			
			_content.setSceneComponent(_uiLayer, _solarInfo as ResSolarInfo);
			
			//加入退出按钮
			new BmButton(_solarInfo._exitBtn, function():void{
				ControllerManager.cityController.enterCity();
				//刷新箭头
				ViewManager.sendMessage(ViewMessage.REFRESH_TASK);
			});
			
			//加入噩梦鼠按钮
			new BmButton(_solarInfo._boyHeroBtn, function():void{
				ControllerManager.boyHeroController.showBoyHero();
			});
			
			//加入挑战按钮
			btn = new BmButton(_solarInfo._startChallengeBtn, function():void{
				if (ViewManager.hasView(SolarChallenge.NAME)) return;
				if(ViewManager.hasView(SolarRaid.NAME)) (ViewManager.retrieveView(SolarRaid.NAME) as SolarRaid).closeWindow();
				var win:BmWindow = new SolarChallenge(_gid);
				addChildCenter(win);		
			});
			
			var btn2:BmButton = new BmButton(_solarInfo._conversionTalentBtn, function():void{
				if (ViewManager.hasView(TalentExchange.NAME)) return;
				var talentExchangeWin:BmWindow = new TalentExchange;
				addChildCenter(talentExchangeWin);
			});
			
			if(Data.data.user.techLevel < 26){
				btn.enable = false;
				TipHelper.setTip(_solarInfo._startChallengeBtn, new McTip("科技等级26级开启"));
			}
			if(Data.data.user.techLevel < 28){
				btn2.enable = false;
				TipHelper.setTip(_solarInfo._conversionTalentBtn, new McTip("科技等级28级开启"));
			}
			
			//用户信息
			TipHelper.setTip(_solarInfo._userInfo._coins, new McTip("宇宙币"));
			TipHelper.setTip(_solarInfo._userInfo._golden, new McTip("宇宙钻"));
			TipHelper.setTip(_solarInfo._userInfo._techLvl, new McTip("科技等级"));
			TipHelper.setTip(_solarInfo._userInfo._honorLvl, new McTip("荣誉等级"));
			TipHelper.setTip(_solarInfo._userInfo._vip, new McTip("VIP特权"));
			
			_solarInfo._userInfo._vip.buttonMode = true;
			_solarInfo._userInfo._vip.addEventListener(MouseEvent.CLICK, function():void{
				ControllerManager.vipController.showVip();
			});
			
			new BmButton(_solarInfo._userInfo._rechargeBtn, function():void{});
			_solarInfo._userInfo._rechargeBtn.visible = false;
			
			new BmButton(_solarInfo._userInfo._head, function():void{
				ControllerManager.userInfoController.showUserInfo();
			});
			
			_solarInfo._userInfo._playerName.text = Data.data.user.name;
			_solarInfo._userInfo._job.text = Data.data.user.honorName;
			_solarInfo._userInfo._campLogo.gotoAndStop(Data.data.user.union);
			TipHelper.setTip(_solarInfo._userInfo._campLogo, new McTip(Data.data.user.unionName));
			_solarInfo._userInfo._vip.gotoAndStop(int(Data.data.user.vip) + 1);
			
			_headImg = new McImage(Data.data.user.headImg);
			_headImg.mouseEnabled = false;
			addChildEx(_headImg, 18, 1);

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

			_content.x = (cWidth - _content.cWidth) / 2;
			_content.y = (cHeight - _content.cHeight) / 2;
			_solarInfo.x = _content.x < 0 ? 0 : _content.x;
			_solarInfo.y = _content.y < 0 ? 0 : _content.y;
			_headImg.x = _solarInfo.x + 18;
			_headImg.y = _solarInfo.y + 1;
		}
		
		/**
		 * 设置挑战关卡数值 
		 * 
		 */
		private function setChallengeNum():void
		{
			var data:Object = Data.data.solar.challenge;
			var finishPlanet:int = 0;
			var flag:Boolean;
			var count:int;
			for (var i:int = (_gid - 1) * 10 + 1; i < (_gid - 1) * 10 + 11; i++) 
			{
				count = 0;
				flag = true;
				if(!data || !data[i]) continue;
				for each (var o:Object in data[i]) 
				{
					count++;
					if(o['flag'] != 1) {
						flag = false;
						break;
					}
				}
				if(count != 5) continue;
				if(flag) finishPlanet++;
			}
			_solarInfo._challengeCount.text = finishPlanet.toString();
			_content.setChallengeAnim(finishPlanet);
		}
		
	}
}
