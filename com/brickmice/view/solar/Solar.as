package com.brickmice.view.solar
{
	import com.brickmice.ModelManager;
	import com.brickmice.controller.NewbieController;
	import com.brickmice.data.Data;
	import com.brickmice.view.ViewMessage;
	import com.brickmice.view.component.BmButton;
	import com.brickmice.view.component.BmTextButton;
	import com.brickmice.view.component.BmWindow;
	import com.brickmice.view.component.McTip;
	import com.framework.core.Message;
	import com.framework.core.ViewManager;
	import com.framework.ui.basic.CScene;
	import com.framework.ui.basic.layer.CLayer;
	import com.framework.ui.sprites.CMap;
	import com.framework.utils.TipHelper;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.utils.getDefinitionByName;

	/**
	 * 太阳试炼
	 *
	 * @author derek
	 */
	public class Solar extends CMap
	{

		/**
		 * 名字.
		 */
		public static const NAME : String = "Solar";	
		
		private var _window:*;
		private var _selectLevel:MovieClip;
		private var _uiLayer:CLayer;
		private var _solarInfo:MovieClip;
		private var _selectLevelVec:Vector.<BmTextButton>;
		
		private var _currentPlanet:int;
		private var _openGalaxy:int;
		
		public function Solar(openGalaxy:int)
		{
			super(NAME, 1292, 714);
			
			setContent(openGalaxy);
			
			_selectLevelVec = new Vector.<BmTextButton>();
			
			//选择关卡动画
			_selectLevel = new ResSolarSelectLevel;
			_selectLevel.gotoAndStop(1);
			_selectLevel.visible = false;
			
			for (var i:int = 1; i <= 15; i++) 
			{
				setBmTb(i);
			}
			
			setData();
			
			//新手指引
			NewbieController.showNewBieBtn(4, 2, this, 1011, 287, true, "进入月球关卡");
			NewbieController.showNewBieBtn(5, 2, this, 1011, 287, true, "进入月球关卡");
		}
		
		public function setChallengeAnim(count:int):void
		{
			for (var i:int = 1; i <= 10; i++) 
			{
				_window._challengeModeBtn['_' + i].gotoAndStop(i > count ? 2 : 1);
			}
			
		}
		
		public function setContent(openGalaxy:int):void
		{
			_openGalaxy = openGalaxy;
			removeAllChildren();
			// 初始化并加入资源
			var cls:Object =  getDefinitionByName('ResSolarG' + (openGalaxy > 2 ? openGalaxy - 2 : openGalaxy));
			_window = new cls;
			addChildEx(_window);
			
			(_window as MovieClip).scrollRect = new Rectangle(0, 0, 1292, 714);
			
			_window.addEventListener(MouseEvent.CLICK, function():void{
				_selectLevel.visible = false;
			});	
			
			//挑战关卡
			new BmButton(_window._challengeModeBtn, function():void{
				if (ViewManager.hasView(SolarChallenge.NAME)) return;
				if(ViewManager.hasView(SolarRaid.NAME)) (ViewManager.retrieveView(SolarRaid.NAME) as SolarRaid).closeWindow();
				var win:BmWindow = new SolarChallenge(openGalaxy);
				(parent as CScene).addChildCenter(win);
			});
			
			if(Data.data.user.techLevel < 26){
				_window._challengeModeBtn.visible = false;
			}
			
			setData();
		}
		
		private function setBmTb(pos:int):void
		{
			var bmTb:BmTextButton = new BmTextButton(_selectLevel['_' + pos], '', function():void{
				NewbieController.refreshNewBieBtn(4, 4);
				NewbieController.refreshNewBieBtn(5, 4);
				_selectLevel.visible = false;
				ModelManager.solarModel.getSolarLevelData(_currentPlanet, pos, function():void
				{	
					var pName:String = Data.data.solar.galaxy[_openGalaxy].planet[_currentPlanet].name;
					if (ViewManager.hasView(SolarRaid.NAME)) {
						(ViewManager.retrieveView(SolarRaid.NAME) as SolarRaid).setData(_currentPlanet, pName);
					}else{
						var solarRaidWin:BmWindow = new SolarRaid(_currentPlanet, pName);
						(parent as CScene).addChildCenter(solarRaidWin);
					}
				});
			});
			_selectLevelVec.push(bmTb);
		}
		
		public function setSceneComponent(uiLayer:CLayer, solarInfo:MovieClip):void
		{
			_uiLayer = uiLayer;
			_solarInfo = solarInfo;
			setInfo();
			_uiLayer.addChildEx(_selectLevel);
		}
		
		/**
		 * 使用用户数据来填充用户面板
		 */
		private function setInfo() : void
		{
			_solarInfo._userInfo._coins.text = Data.data.user.coins;
			
			_solarInfo._userInfo._golden.text = (int(Data.data.user.golden) + int(Data.data.user.silver)).toString();
			
			_solarInfo._userInfo._honorLvl.text = Data.data.user.honorLevel;
			
			_solarInfo._userInfo._techLvl.text = Data.data.user.techLevel;
		}		
		
		private function setData():void
		{
			for (var i:int = 1; i <= 10; i++) 
			{
				var planet:MovieClip = _window['_' + i];
				planet.buttonMode = true;
				var planetId:int = (_openGalaxy - 1) * 10 + i;
				var pName:String = Data.data.solar.galaxy[_openGalaxy].planet[planetId].name;
				TipHelper.setTip(planet, new McTip(pName + "<br>Lv：" + planetId.toString()));
				//屏蔽未开启星球
				if(planetId > Data.data.solar.openPlanet){
					planet.gotoAndStop(2);
				}else{
					planet.gotoAndStop(1);
					addPlanetClick(planetId, planet);	
				}
				//处理最新星球动画
				(_window['_' + i + 'new'] as MovieClip).mouseEnabled = false;
				if(planetId == Data.data.solar.openPlanet){
					_window['_' + i + 'new'].visible = true;
					_window['_' + i + 'new'].play();
				}else{
					_window['_' + i + 'new'].visible = false;
					_window['_' + i + 'new'].stop();
				}
			}
		}
		
		private function addPlanetClick(index:int, planet:MovieClip):void
		{
			if(planet.hasEventListener(MouseEvent.CLICK)) return; //无须重复注册
			planet.addEventListener(MouseEvent.CLICK, function(event:MouseEvent):void{
				if(index == 1) {
					NewbieController.refreshNewBieBtn(4, 3);
					NewbieController.refreshNewBieBtn(5, 3);
					NewbieController.showNewBieBtn(4, 3, _selectLevel, 5, 10, true, "选择月球1关卡");
					NewbieController.showNewBieBtn(5, 3, _selectLevel, 100, 10, true, "选择月球2关卡");
				}
				event.stopImmediatePropagation();
				event.stopPropagation();
				//赋值
				var pName:String = Data.data.solar.galaxy[_openGalaxy].planet[index].name;
				_currentPlanet = index;
				for (var i:int = 1; i <= 15; i++) 
				{
					_selectLevelVec[i - 1].title = pName + i.toString() + "关";
					if(index == Data.data.solar.openPlanet && i > Data.data.solar.openLevel){
						_selectLevelVec[i - 1].enable = false;
					}
					else{
						_selectLevelVec[i - 1].enable = true;
					}
				}
				// 定位
				var x:int = _uiLayer.mouseX + 10;
				var y:int = _uiLayer.mouseY + 10;
				// 位置偏移
				if (x + 571 > _uiLayer.cWidth)
					x -= 571;
				if (y + 126 > _uiLayer.cHeight)
					y = _uiLayer.cHeight - 126 - 20;
				_selectLevel.x = x;
				_selectLevel.y = y;
				_selectLevel.visible = true;
				_selectLevel.gotoAndPlay(1);
			});	
		}
		
		/**
		 * 消息监听
		 */
		override public function listenerMessage() : Array
		{
			return [ViewMessage.REFRESH_SOLARPOINT, ViewMessage.REFRESH_EQUIPPOINT, ViewMessage.REFRESH_SOLAROPENPLANET, 
				ViewMessage.REFRESH_USER, ViewMessage.REFRESH_SOLARSTONE, ViewMessage.REFRESH_NEWBIE];
		}	
		
		/**
		 * 消息捕获
		 */
		override public function handleMessage(message : Message) : void
		{
			switch(message.type)
			{
				case ViewMessage.REFRESH_EQUIPPOINT:
					_solarInfo._equipCombineCount.text = Data.data.equip.centrifuge;
					break;
				case ViewMessage.REFRESH_SOLARPOINT:
					_solarInfo._tickets.text = Data.data.solar.point + " / " + Data.data.solar.maxPoint;
					var tip:String = '';
					tip += "试炼次数恢复间隔：" + Data.data.solar.recoverPointInterval + "秒<br>";
					tip += "花费" + Data.data.solar.buyPointCost + "宇宙钻购买" + Data.data.solar.buyPointCount + "试炼次数";
					TipHelper.setTip(_solarInfo._buyTicketsBtn, new McTip(tip));
					break;	
				case ViewMessage.REFRESH_SOLARSTONE:
					_solarInfo._talentStoneCount.text = Data.data.solar.stone;
					break;
				case ViewMessage.REFRESH_SOLAROPENPLANET:
					setData();
					break;
				case ViewMessage.REFRESH_USER:
					setInfo();
					break;
				case ViewMessage.REFRESH_NEWBIE:
					NewbieController.showNewBieBtn(4, 12, _uiLayer, (this.x < 0 ? -60 : this.x - 60) + 162, (this.y < 0 ? 0 : this.y) + 304, false, "离开太阳的试炼", true);
					NewbieController.showNewBieBtn(5, 9, _uiLayer, (this.x < 0 ? -60 : this.x - 60) + 162, (this.y < 0 ? 0 : this.y) + 304, false, "离开太阳的试炼", true);
					break;
				default:
			}
		}	

	}
}