package com.brickmice
{
	import com.brickmice.data.Consts;
	import com.brickmice.data.Data;
	import com.brickmice.data.ResourceLoader;
	import com.brickmice.view.ViewMessage;
	import com.brickmice.view.city.CityScene;
	import com.brickmice.view.component.layer.LoadingLayer;
	import com.brickmice.view.component.layer.TipLayer;
	import com.brickmice.view.component.layer.UiLayer;
	import com.brickmice.view.component.layer.WindowLayer;
	import com.brickmice.view.research.ResearchScene;
	import com.brickmice.view.solar.SolarScene;
	import com.brickmice.view.world.WorldScene;
	import com.framework.core.ViewManager;
	import com.framework.ui.basic.CScene;
	import com.framework.utils.SoundUtils;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.system.System;

	/**
	 * 主程序 - 程序入口
	 * @author derek
	 */
	public class Main extends CScene
	{
		/**
		 * 记录下自己的实例
		 */
		public static var self:Main;
		/**
		 * 当前场景
		 */
		public var currentScene:String = "";
		/**
		 * 新手箭头
		 */
		public var newbieBtn:MovieClip;	

		/**
		 * 构造函数
		 */
		public function Main()
		{
			super('Main', Consts.WIDTH, Consts.HEIGHT);
			Main.self = this;
			evts.addedToStage(onAddedToStage);
		}

		private function onAddedToStage(event:Event):void
		{
			evts.removeEventListener(onAddedToStage);
			//干掉焦点矩形
			stage.stageFocusRect = false;
			// 读取配置文件
			ResourceLoader.loadXml('server.xml?ver=' + Math.random(), function(xml:XML):void
			{
				var server:String = xml.server.toString();
				var resource:String = xml.resource.toString();
				System.disposeXML(xml);

				Consts.requestURL = server;
				Consts.resourceURL = resource;

				helpStartUp();
			});
		}

		private function helpStartUp():void
		{
			stage.frameRate = 18;
			// 初始化ModelManager
			ModelManager.init();
			// 初始化ControllerManager
			ControllerManager.init();
			// 初始化 应用程序
			ControllerManager.initController.initApp();
		}

		/**
		 * window层
		 */
		public var windowLayer:WindowLayer;
		/**
		 * tip层
		 */
		public var tipLayer:TipLayer;
		/**
		 * ui层
		 */
		public var uiLayer:UiLayer;
		/**
		 * loading层
		 */
		public var loadingLayer:LoadingLayer;

		/**
		 * 初始化各层
		 */
		public function initLayers():void
		{
			// 加入4层
			uiLayer = new UiLayer(cWidth, cHeight);
			uiLayer.visible = false;
			addChildEx(uiLayer);

			// 窗口层
			windowLayer = new WindowLayer(cWidth, cHeight);
			addChildEx(windowLayer);

			// tip层
			tipLayer = new TipLayer(cWidth, cHeight);
			addChildEx(tipLayer);

			// loading层
			loadingLayer = new LoadingLayer(cWidth, cHeight);
			addChildEx(loadingLayer);
			
			//新手箭头
			newbieBtn = new ResNewbieBtn;
			newbieBtn.gotoAndStop(1);
			newbieBtn.mouseEnabled = false;
		}

		/***
		 * 修改当前场景
		 *
		 * @param scene 新场景引用.继承自CScene
		 */
		public function changeScene(scene:CScene, showUi:int):void
		{
			
			// 记录当前场景的名字
			currentScene = scene.cName;
			
			//处理一下背景音乐
			var flag:Boolean = Data.data.user.musicOn == 1;
			//先暂停原先的音乐
			SoundUtils.musicState = false;
			SoundUtils.musicControl();	
			switch(currentScene)
			{
				case CityScene.NAME:
				{
					SoundUtils.init(Consts.resourceURL + "music/bg.mp3", flag);	
					break;
				}
				case ResearchScene.NAME:
				{
					SoundUtils.init(Consts.resourceURL + "music/research.mp3", flag);	
					break;
				}
				case SolarScene.NAME:
				{
					SoundUtils.init(Consts.resourceURL + "music/bg3.mp3", flag);	
					break;
				}
				case WorldScene.NAME:
				{
					SoundUtils.init(Consts.resourceURL + "music/bg2.mp3", flag);	
					break;
				}
			}

			// windowlayer tiplayer清理一下
			windowLayer.clear();
			tipLayer.removeAllChildren();

			// 修改场景
			setContent(scene);

			// 新场景重设一下大小
			scene.resize();

			// 是否显示ui
			uiLayer.headVisible = showUi;

			scene = null;
		}

		/**
		 * 锁定屏幕
		 */
		public function lockScene(show:Boolean = true, requestAble:Boolean = false):void
		{
			mouseEnabled = mouseChildren = false;
			loadingLayer.showLoading(show, requestAble);
		}

		/**
		 * 解锁屏幕
		 */
		public function unlockScene():void
		{
			mouseEnabled = mouseChildren = true;
			loadingLayer.showLoading(false);
		}
	}
}
