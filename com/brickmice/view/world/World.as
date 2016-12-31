package com.brickmice.view.world
{
	import com.brickmice.ControllerManager;
	import com.brickmice.controller.NewbieController;
	import com.brickmice.data.Data;
	import com.brickmice.view.ViewMessage;
	import com.framework.core.Message;
	import com.framework.ui.sprites.CMap;
	import com.framework.utils.TipHelper;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;

	/**
	 * 银河
	 *
	 * @author derek
	 */
	public class World extends CMap
	{

		private var _window:ResWorld;
		private var _houseArr:Array;

		/**
		 * 银河名字
		 */
		public static const NAME:String = 'World';

		public function World()
		{
			// 初始化并加入资源
			_window = new ResWorld();
			super(NAME, 2649, 965);
			addChildEx(_window);
			_houseArr = [];
			// 初始化
			for each(var one:Object in Data.data.planet) {
				var planet:MovieClip = _window.getChildByName('_' + one.id) as MovieClip;
				initPlanet(planet, one);
			}
			//初始化驻守标识
			var heroArr:Object = Data.data.boyHero;
			for each(var hero:Object in heroArr) {
				if(hero.status == 'house'){
					var houseAnim:MovieClip = _window.getChildByName('_' + hero.planet.id + 'houseAnim') as MovieClip;
					houseAnim.visible = true;
					houseAnim.play();
					var index:int = _houseArr.indexOf(hero.planet.id);
					if(index < 0) _houseArr.push(hero.planet.id);
				}
			}
			
			newbieHandler();
		}

		/**
		 * 消息监听
		 */
		override public function listenerMessage():Array
		{
			return [ViewMessage.UPDATE_PLANET, ViewMessage.REFRESH_BOYHERO, ViewMessage.REFRESH_NEWBIE];
		}
		
		/**
		 * 消息捕获
		 */
		override public function handleMessage(message:Message):void
		{
			switch(message.type)
			{
				case ViewMessage.UPDATE_PLANET:
					var pid:int = message.data;
					var data:Object = Data.data.planet[pid];
					var planet:MovieClip = _window.getChildByName('_' + pid) as MovieClip;
					updatePlanet(planet, data);
					break;
				case ViewMessage.REFRESH_BOYHERO:
					for each(var id:int in _houseArr) {
						var houseAnim:MovieClip = _window.getChildByName('_' + id + 'houseAnim') as MovieClip;
						houseAnim.visible = false;
						houseAnim.stop();
					}
					_houseArr = [];
					var heroArr:Object = Data.data.boyHero;
					for each(var hero:Object in heroArr) {
						if(hero.status == 'house'){
							var houseAnim2:MovieClip = _window.getChildByName('_' + hero.planet.id + 'houseAnim') as MovieClip;
							houseAnim2.visible = true;
							houseAnim2.play();
							var index:int = _houseArr.indexOf(hero.planet.id);
							if(index < 0) _houseArr.push(hero.planet.id);
						}
					}
					break;
				case ViewMessage.REFRESH_NEWBIE:
					newbieHandler();
					break;
				default:
			}
		}
		
		/**
		 * 更新星球信息
		 */
		public function updatePlanet(planet:MovieClip, one:Object):void
		{
			var pUnion:int = one.union;
			if(one.id > 3000) pUnion -= 2;
			planet.gotoAndStop(pUnion);
			var subPlanet:MovieClip = planet.getChildByName('_' + pUnion) as MovieClip;
			subPlanet.gotoAndStop(Math.floor(one.level/15) * 2 + 1);
			if(one.status != 'war'){
				planet._mask._battleFlag.gotoAndStop(12);
			}else{
				planet._mask._battleFlag.play();
			}
		}

		/**
		 * 初始化
		 */
		public function initPlanet(planet:MovieClip, one:Object):void
		{
			//隐藏一些标识
			var houseAnim:MovieClip = _window.getChildByName('_' + one.id + 'houseAnim') as MovieClip;
			houseAnim.visible = false;
			houseAnim.stop();
			//阵营
			var pUnion:int = one.union;
			if(one.id > 3000) pUnion -= 2;
			planet.gotoAndStop(pUnion);
			//动画都用mask
			if(planet._mask) {
				planet.hitArea = planet._mask;
				if(one.status != 'war'){
					planet._mask._battleFlag.gotoAndStop(12);
				}
			}
			var subPlanet:MovieClip = planet.getChildByName('_' + pUnion) as MovieClip;
			subPlanet.gotoAndStop(Math.floor(one.level/15) * 2 + 1);
			// 设定各种鼠标响应事件
			planet.addEventListener(MouseEvent.CLICK, function(event : MouseEvent) : void
			{
				NewbieController.refreshNewBieBtn(26, 3);
				NewbieController.refreshNewBieBtn(22, 8);
//				NewbieController.refreshNewBieBtn(33, 3);
				ControllerManager.planetController.showPlanet(one.id);
			});
			planet.buttonMode = true;
			
			planet.addEventListener(MouseEvent.MOUSE_OVER, function(event : MouseEvent) : void
			{
				var lvl:int = Data.data.planet[one.id].level;
				var subPlanet1:MovieClip = planet.getChildByName('_1') as MovieClip;
				if(subPlanet1 != null) subPlanet1.gotoAndStop(Math.floor(lvl/15) * 2 + 2);
				var subPlanet2:MovieClip = planet.getChildByName('_2') as MovieClip;
				if(subPlanet2 != null) subPlanet2.gotoAndStop(Math.floor(lvl/15) * 2 + 2);
			});
			
			planet.addEventListener(MouseEvent.MOUSE_OUT, function(event : MouseEvent) : void
			{
				var lvl:int = Data.data.planet[one.id].level;
				var subPlanet1:MovieClip = planet.getChildByName('_1') as MovieClip;
				if(subPlanet1 != null) subPlanet1.gotoAndStop(Math.floor(lvl/15) * 2 + 1);
				var subPlanet2:MovieClip = planet.getChildByName('_2') as MovieClip;
				if(subPlanet2 != null) subPlanet2.gotoAndStop(Math.floor(lvl/15) * 2 + 1);
			});
			// 设定tip
			TipHelper.setTip(planet, new PlanetTip(one.id));
		}
		
		private function newbieHandler():void
		{
			if(Data.data.user.union == 1){
				NewbieController.showNewBieBtn(26, 2, this, 394, 511, true, "打开星球详细操作界面", false, true);
				NewbieController.showNewBieBtn(22, 7, this, 394, 511, true, "打开最近的星球面板", false, true);
//				NewbieController.showNewBieBtn(33, 2, this, 394, 511, true, "打开星球界面");
			}else{
				NewbieController.showNewBieBtn(26, 2, this, 2220, 481, true, "打开星球详细操作界面", false, true);
				NewbieController.showNewBieBtn(22, 7, this, 2220, 481, true, "打开最近的星球面板", false, true);
//				NewbieController.showNewBieBtn(33, 2, this, 2220, 481, true, "打开星球界面");
			}
		}
	}
}
