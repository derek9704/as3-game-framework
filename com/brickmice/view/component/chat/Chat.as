package com.brickmice.view.component.chat
{
	
	import com.brickmice.ControllerManager;
	import com.brickmice.ModelManager;
	import com.brickmice.controller.ChatController;
	import com.brickmice.data.Consts;
	import com.brickmice.data.Data;
	import com.brickmice.data.tcp.Login;
	import com.brickmice.data.tcp.Tcp;
	import com.brickmice.data.tcp.events.ChatErrorEvent;
	import com.brickmice.data.tcp.events.LoginEvent;
	import com.brickmice.data.tcp.events.NetworkEvent;
	import com.brickmice.data.tcp.events.ReceiveMsgEvent;
	import com.brickmice.view.component.BmButton;
	import com.brickmice.view.component.prompt.NoticeMessage;
	import com.framework.ui.basic.sprite.CSprite;
	import com.framework.ui.sprites.WindowData;
	import com.framework.utils.KeyValue;
	
	import flash.display.MovieClip;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.events.TimerEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	/**
	 * @author derek
	 */
	public class Chat extends CSprite {
		public static const NAME:String = "Chat";
		public static const HEIGHT1:int = 168;
		public static const HEIGHT2:int = 400;
		public static const TABHEIGHT:int = 23;
		
		private var _netWork:Tcp;
		private var _login:Login;
		private var _allLab:RichTextArea;
		private var _worldLab:RichTextArea;
		private var _guildLab:RichTextArea;
		private var _unionLab:RichTextArea;
		private var _whisperLab:RichTextArea;
		private var _currentLab:RichTextArea;
		private var _input:RichTextField;
		private var _dropDownList:ChatDropDownList;
		private var _tabs:ChatTabButton;
		private var _msgType:String;
		//重新登录提示
		private var _reconnTip:Boolean = true;
		//聊天控制器_连接服务器后创建
		private var _chatController:ChatController;
		//记录聊天对象
		private var _whisperTargetName:String = "";
		
		public function Chat() {
			super(NAME,292,HEIGHT2);
			
			var GAPHEIGHT:int = HEIGHT2 - HEIGHT1;
			
			//加入背景
			var _chatBg:ResChatBg = new ResChatBg;
			addChildEx(_chatBg,0,GAPHEIGHT + TABHEIGHT);
			
			_chatBg.height = HEIGHT1 - TABHEIGHT;
			
			var _inputBg:ResChatInputBg = new ResChatInputBg;
			addChildEx(_inputBg,62,HEIGHT2 - 29);
			
			//加入tab
			_tabs = new ChatTabButton(changeTab);
			_tabs.addTab('综合');
			_tabs.addTab('世界');
			_tabs.addTab('阵营');
			_tabs.addTab('联盟');
			_tabs.addTab('私聊');
			_tabs.selectIndex = 0;
			addChildEx(_tabs,16,GAPHEIGHT + 3);

			//放大按钮
			var maxmize:MovieClip = new ResChatEnlargeBtn;
			addChildEx(maxmize,28,GAPHEIGHT + TABHEIGHT);
			new BmButton(maxmize,  function (evt:MouseEvent):void{
				_chatBg.height = HEIGHT2 - TABHEIGHT;
				_chatBg.y = TABHEIGHT;
				_allLab.sizeChange(253,HEIGHT2 - 60);
				_worldLab.sizeChange(253,HEIGHT2 - 60);
				_guildLab.sizeChange(253,HEIGHT2 - 60);
				_unionLab.sizeChange(253,HEIGHT2 - 60);
				_whisperLab.sizeChange(253,HEIGHT2 - 60);
				_allLab.y = _worldLab.y = _guildLab.y = _unionLab.y = _whisperLab.y = TABHEIGHT + 10;
				_tabs.y = 3;
				maxmize.visible = false;
				minimize.visible = true;
			});
			
			//缩小按钮
			var minimize:MovieClip = new ResChatReduceBtn;
			addChildEx(minimize,28,TABHEIGHT);
			minimize.visible = false;
			new BmButton(minimize, function (evt:MouseEvent):void{
				_chatBg.height = HEIGHT1 - TABHEIGHT;
				_chatBg.y = GAPHEIGHT + TABHEIGHT;
				_allLab.sizeChange(253,HEIGHT1 - 60);
				_worldLab.sizeChange(253,HEIGHT1 - 60);
				_guildLab.sizeChange(253,HEIGHT1 - 60);
				_unionLab.sizeChange(253,HEIGHT1 - 60);
				_whisperLab.sizeChange(253,HEIGHT1 - 60);
				_allLab.y = _worldLab.y = _guildLab.y = _unionLab.y = _whisperLab.y = TABHEIGHT + GAPHEIGHT + 10;
				//trick
				_currentLab._textField.appendText("");
				scrollToEnd();
				_tabs.y = GAPHEIGHT + 3;
				minimize.visible = false;
				maxmize.visible = true;
			});

			//各种标签页
			_currentLab = _allLab = new RichTextArea(253,HEIGHT1 - 60);
			addChildEx(_allLab,11,TABHEIGHT + GAPHEIGHT + 10);
			
			_worldLab = new RichTextArea(253,HEIGHT1 - 60);
			_worldLab.visible = false;
			addChildEx(_worldLab,11,TABHEIGHT + GAPHEIGHT + 10);
			
			_guildLab = new RichTextArea(253,HEIGHT1 - 60);
			_guildLab.visible = false;
			addChildEx(_guildLab,11,TABHEIGHT + GAPHEIGHT + 10);
			
			_unionLab = new RichTextArea(253,HEIGHT1 - 60);
			_unionLab.visible = false;
			addChildEx(_unionLab,11,TABHEIGHT + GAPHEIGHT + 10);			
			
			_whisperLab = new RichTextArea(253,HEIGHT1 - 60);
			_whisperLab.visible = false;
			addChildEx(_whisperLab,11,TABHEIGHT + GAPHEIGHT + 10);
			
			_allLab.addEventListener(TextEvent.LINK, linkHandler);
			_worldLab.addEventListener(TextEvent.LINK, linkHandler);
			_unionLab.addEventListener(TextEvent.LINK, linkHandler);
			_guildLab.addEventListener(TextEvent.LINK, linkHandler);
			_whisperLab.addEventListener(TextEvent.LINK, linkHandler);
			
			//下拉框
			var items:Array = [new KeyValue('world', "世界"),new KeyValue('union', "阵营"),new KeyValue('guild', "联盟"),new KeyValue('whisper', "私聊")];
			_dropDownList = new ChatDropDownList(items, 48, 27, 0, comboBocChanged,false);
			addChildEx(_dropDownList,9,HEIGHT2 - 30);
			_msgType = ChatConst.WORLD;
			
			_input = new RichTextField(148,18,RichTextField.INPUT);
			_input.textfield.multiline = false;
			
			_input.defaultTextFormat = new TextFormat("Arial", 12, 0xFFFFFF);
			_input.addEventListener(KeyboardEvent.KEY_DOWN, function (evt:KeyboardEvent):void
			{
				if(_input.length > 60) _input.text = _input.text.substr(0,60);
				if (evt.keyCode == Keyboard.ENTER && _chatController)
				{
					sendMsg();
				}
			});
			addChildEx(_input,67,HEIGHT2 - 26);
			
			var send:MovieClip = new ResChatSendBtn;
			addChildEx(send, 227, HEIGHT2 - 28);
			new BmButton(send, function (evt:MouseEvent):void{
				sendMsg();
			});
				
			//定时清屏
			var timer:Timer = new Timer(30000);
			timer.addEventListener(TimerEvent.TIMER, function():void{
				_allLab.clearHalf();
				_worldLab.clearHalf();
				_unionLab.clearHalf();
				_guildLab.clearHalf();
				_whisperLab.clearHalf();
			});
			timer.start();
			this._netWork = Tcp.getInstance();
			this._netWork.addEventListener(NetworkEvent.CONNECTED, netWorkHandler);
			this._netWork.addEventListener(NetworkEvent.CONNECTE_FAIL, netWorkHandler);
			this._netWork.addEventListener(NetworkEvent.DISCONNECT, netWorkHandler);
		}	
	
		private function sendMsg():void{
			var msg:String = _input.textfield.text.substr(0,60);
			if(msg == "") return;
			var bytes : ByteArray = new ByteArray();
			bytes.writeUTFBytes(msg);
			if (bytes.length < 200)
			{
				switch (_msgType)
				{
					case ChatConst.WHISPER:
						var index:int = msg.indexOf(":");
						if (index > -1)
						{
							_whisperTargetName = msg.substring(0, index);
							msg = msg.substr(index + 1, msg.length);
						}
						else
						{
							_whisperTargetName = "";
						}
						_chatController.SendWhisper(_whisperTargetName, msg );
						break;
					case ChatConst.WORLD:
						_chatController.SendWorldMsg(msg);
						break;
					case ChatConst.UNION:
						_chatController.SendUnionMsg( msg );
						break;
					case ChatConst.GUILD:
						_chatController.SendGuildMsg( msg);
						break;
				}
			}
			if (_msgType != ChatConst.WHISPER)
			{
				_input.clear();
			}
			else
			{
				_input.textfield.text = _input.textfield.text.substring(0, _input.textfield.text.indexOf(":") + 1);
			}
		}	
		/**
		 * 修改当前tab
		 * 
		 * @param title tab的标识
		 */
		private function changeTab(title : String,data:* = null) : void {
			//根据新标题类型来显示当前面板
			switch(title){
				case '综合':
					_allLab.visible = true;
					_worldLab.visible = false;
					_unionLab.visible = false;
					_guildLab.visible = false;
					_whisperLab.visible = false;
					_currentLab = _allLab;
					break;
				case '世界':
					_allLab.visible = false;
					_worldLab.visible = true;
					_unionLab.visible = false;
					_guildLab.visible = false;
					_whisperLab.visible = false;
					_currentLab = _worldLab;
					_msgType = ChatConst.WORLD;		
					_dropDownList.setIndex(0);
					break;
				case '阵营':
					_allLab.visible = false;
					_worldLab.visible = false;
					_unionLab.visible = true;
					_guildLab.visible = false;
					_whisperLab.visible = false;
					_currentLab = _unionLab;
					_msgType = ChatConst.UNION;
					_dropDownList.setIndex(1);
					break;				
				case '联盟':
					_allLab.visible = false;
					_worldLab.visible = false;
					_unionLab.visible = false;
					_guildLab.visible = true;
					_whisperLab.visible = false;
					_currentLab = _guildLab;
					_msgType = ChatConst.GUILD;			
					_dropDownList.setIndex(2);
					break;
				case '私聊':
					_allLab.visible = false;
					_worldLab.visible = false;
					_unionLab.visible = false;
					_guildLab.visible = false;
					_whisperLab.visible = true;
					_currentLab = _whisperLab;
					_msgType = ChatConst.WHISPER;
					_dropDownList.setIndex(3);
			}
		}		
		/**
		 * 选项改变触发
		 * */		
		private function comboBocChanged(title:String):void
		{
			switch(title)
			{
				case "world":
					_msgType = ChatConst.WORLD;
					break;
				case "guild":
					_msgType = ChatConst.GUILD;
					break;					
				case "union":
					_msgType = ChatConst.UNION;
					break;		
				case "whisper":
					_msgType = ChatConst.WHISPER;
					break;	
			}
			stage.focus = _input.textfield;
			_input.textfield.setSelection(0, _input.textfield.text.length);	
		}
		/**
		 * 连接服务器事件处理函数
		 * */
		private function netWorkHandler(evt:NetworkEvent):void
		{
			var evtType:String = evt.type;
			//与服务器建立连接成功后准备登陆
			if (evtType == NetworkEvent.CONNECTED)
			{
				if(!_login){
					this._login = new Login(this._netWork);
					this._login.addEventListener(LoginEvent.LOGIN_IN, loginHandler);
					this._login.addEventListener(LoginEvent.LOGIN_OUT, loginHandler);
					this._login.addEventListener(ReceiveMsgEvent.SYSTEM_MSG, receiveMsg_system);
				}
				
				var user:Object = Data.data.user;
				this._login.SendAuthLogin(user.id, user.sid);
			}
			else if (evtType == NetworkEvent.CONNECTE_FAIL)
			{
				this.tryRelogin();
			}
			else if (evtType == NetworkEvent.DISCONNECT)
			{
				this.tryRelogin();
			}
		}
		/**
		 * 尝试重新连接函数(连接服务器失败后)
		 * */
		private function tryRelogin() : void
		{	
			if(this._netWork.kickout)
			{
				_currentLab.appendText("[系统]您的账号已经在异地登陆",ChatConst.COLOR_SYSTEM);
				//这里直接提示刷新
				// 关闭心跳
				Consts.heartBool = false;
				//弹出提示
				var callback:Function = function():void{
					navigateToURL(new URLRequest(Consts.siteURL), "_top");
				};
				var data:Object = {msg:'您已经与服务器断开连接，请重新连接', title:'系统提示', callback:callback};
				ControllerManager.windowController.showWindow(new WindowData(NoticeMessage, data, true, 0, 0, 0, false));
				return;
			}
			if(this._reconnTip)
			{
				_currentLab.appendText("[系统]您已经与服务器断开连接，5秒后自动重连",ChatConst.COLOR_SYSTEM);
				this._reconnTip = false;
			}
			scrollToEnd();
			var id:uint = setTimeout(function() : void{
				queryAuth();
				clearTimeout(id);
			}, 5000);
		}
		/**
		 * Network连接函数
		 * */
		private function queryAuth() : void
		{
			this._netWork.Connect(Consts.chatServer, Consts.chatPort);
		}
		/**
		 * 文本自动滚动到末行
		 * */
		private function scrollToEnd():void
		{
			_allLab.scrollToEnd();
			_worldLab.scrollToEnd();
			_guildLab.scrollToEnd();
			_unionLab.scrollToEnd();
			_whisperLab.scrollToEnd();
		}
		/**
		 * 
		 * */
		private function chatErrorHandler(evt:ChatErrorEvent):void
		{
			var errorInfo:String = evt.error;
			var errorMsg:String = "";
			switch (errorInfo)
			{
				case "no union":
					errorMsg = "您没有联盟";
					break;
				case "no merchant":
					errorMsg = "您没有阵营";
					break;				
				case "no target":
					errorMsg = "该玩家不存在";
					break;					
				case "need login":
					errorMsg = "正在连接聊天服务器，请稍候";
					break;
				case "need target":
					errorMsg = "请选择私聊的目标";
					break;
				case "msg too long":
					errorMsg = "您发送的消息过长";
					break;
				case "too fast":
					errorMsg = "您发送消息过于频繁，请给他人一些发言的机会吧";
					break;
				case "chat block":
					errorMsg = "您已被禁言";
					break;					
				default:
					errorMsg = "未知错误";
					break;
			}
			_currentLab.appendText("[系统]"+errorMsg,ChatConst.COLOR_SYSTEM);
			if (_currentLab != _allLab)
			{
				_allLab.appendText("[系统]"+errorMsg,ChatConst.COLOR_SYSTEM);
			}
			scrollToEnd();
		}
		/**
		 * 用户登录处理函数
		 * */
		private function loginHandler(evt:LoginEvent):void
		{
			var evtType:String = evt.type;
			//登陆成功
			if (evtType == LoginEvent.LOGIN_IN)
			{
				_allLab.appendText("[系统]亲爱的玩家，欢迎您来到银河鼠光！",ChatConst.COLOR_SYSTEM);
				_worldLab.appendText("[系统]亲爱的玩家，欢迎您来到银河鼠光！",ChatConst.COLOR_SYSTEM);
				_unionLab.appendText("[系统]亲爱的玩家，欢迎您来到银河鼠光！",ChatConst.COLOR_SYSTEM);
				_guildLab.appendText("[系统]亲爱的玩家，欢迎您来到银河鼠光！",ChatConst.COLOR_SYSTEM);
				_whisperLab.appendText("[系统]亲爱的玩家，欢迎您来到银河鼠光！",ChatConst.COLOR_SYSTEM);
				//创建聊天控制器
				if(!_chatController){
					this._chatController = new ChatController(this._netWork, this._login);
					this._chatController.addEventListener(ReceiveMsgEvent.SYSTEM_MSG, receiveMsg_system);
					this._chatController.addEventListener(ReceiveMsgEvent.GUILD_MSG, receiveMsg_guild);
					this._chatController.addEventListener(ReceiveMsgEvent.UNION_MSG, receiveMsg_union);
					this._chatController.addEventListener(ReceiveMsgEvent.WHISPER_MSG, receiveMsg_whisper);
					this._chatController.addEventListener(ReceiveMsgEvent.WORLD_MSG, receiveMsg_world);
					this._chatController.addEventListener(ChatErrorEvent.ERROR, chatErrorHandler);
				}
				this._reconnTip = true;
			}
			//登录失败 or 退出 ???
			else if (evtType == LoginEvent.LOGIN_OUT)
			{
				
			}
		}
		private function linkHandler(linkEvent:TextEvent):void {
			switch(linkEvent.text.substring(0,1)){
				case "u":
					this._whisperTargetName = linkEvent.text.substr(2);
					_input.textfield.text = _whisperTargetName + ":";
					stage.focus = _input.textfield;
					_input.setCaretIndex(_input.textfield.length);
					_dropDownList.setIndex(3);
					_msgType = ChatConst.WHISPER;
					break;
			}
		}
		/**
		 * 开放给好友系统的私聊
		 * */		
		public function friendTalk(name:String):void {
			this._whisperTargetName = name;
			_input.textfield.text = _whisperTargetName + ":";
			stage.focus = _input.textfield;
			_input.setCaretIndex(_input.textfield.length);
			_dropDownList.setIndex(3);
			_msgType = ChatConst.WHISPER;	
		}

		/**
		 * 切换至世界聊天
		 * */		
		public function worldChat():void {
			_tabs.selectIndex = 0;
			_allLab.visible = true;
			_worldLab.visible = false;
			_unionLab.visible = false;
			_guildLab.visible = false;
			_whisperLab.visible = false;
			_currentLab = _allLab;			
			_dropDownList.setIndex(0);
			_msgType = ChatConst.WORLD;				
		}	
		/**
		 * 焦点到输入框
		 * */		
		public function focus():void {
			stage.focus = _input.textfield;			
		}		
		/**
		 * 焦点是否到输入框
		 * */		
		public function isFocus():Boolean {
			return stage.focus == _input.textfield;			
		}	
		/**
		 * 根据信息来返回该信息表示的段落[阵营]
		 * */
		private function msgConverter_union(sender:String, msg:String, lab:RichTextArea, lanzuan:int = 0):void
		{
			lab.appendCache("[阵营]", ChatConst.COLOR_UNION);
			//发送者
			if (sender && sender != '!')
			{
				lab.appendCache("<a href='event:u_"+sender+"'>["+sender+"]</a>", ChatConst.COLOR_USER, lanzuan);
				lab.appendCache(": ", ChatConst.COLOR_COMMON);
			}
			if (isShowText(msg))
			{
				msg = msg.substring(ChatConst.showFormat_Front.length, msg.length - ChatConst.showFormat_Back.length);
				var arrShow:Array = msg.split(ChatConst.showSplit);
				var content:String = "", type:String = "", heroID:String = "";
				if (arrShow[0])
				{
					content = arrShow[0];
				}
				if (arrShow[1])
				{
					type = arrShow[1];
				}
				if (arrShow[2])
				{
					heroID = arrShow[2];
				}
				if (arrShow[3])
				{
					ChatConst.COLOR_HERO = arrShow[3];
				}
				lab.appendCache("<a href='event:"+type+"_"+content+"'>["+content+"]</a>", ChatConst.COLOR_HERO);
			}
			else
			{
				var extraLength:int = 8+sender.length;
				var richMess:Object=lab._textField.converStringToRich(msg, extraLength);
				lab.appendCache(richMess.mess, ChatConst.COLOR_UNION, richMess.faces);
			}
			lab.flush();
		}
		/**
		 * 根据信息来返回该信息表示的段落[联盟]
		 * */
		private function msgConverter_guild(sender:String, msg:String, lab:RichTextArea, lanzuan:int = 0):void
		{
			lab.appendCache("[联盟]", ChatConst.COLOR_GUILD);
			//发送者
			if (sender && sender != '!')
			{
				lab.appendCache("<a href='event:u_"+sender+"'>["+sender+"]</a>", ChatConst.COLOR_USER, lanzuan);
				lab.appendCache(": ", ChatConst.COLOR_COMMON);
			}
			if (isShowText(msg))
			{
				msg = msg.substring(ChatConst.showFormat_Front.length, msg.length - ChatConst.showFormat_Back.length);
				var arrShow:Array = msg.split(ChatConst.showSplit);
				var content:String = "", type:String = "", heroID:String = "";
				if (arrShow[0])
				{
					content = arrShow[0];
				}
				if (arrShow[1])
				{
					type = arrShow[1];
				}
				if (arrShow[2])
				{
					heroID = arrShow[2];
				}
				if (arrShow[3])
				{
					ChatConst.COLOR_HERO = arrShow[3];
				}
				lab.appendCache("<a href='event:"+type+"_"+content+"'>["+content+"]</a>", ChatConst.COLOR_HERO);
			}
			else
			{
				var extraLength:int = 8+sender.length;
				var richMess:Object=lab._textField.converStringToRich(msg, extraLength);
				lab.appendCache(richMess.mess, ChatConst.COLOR_GUILD, richMess.faces);
			}
			lab.flush();
		}		
		/**
		 * 收到[阵营]消息处理函数
		 * */
		private function receiveMsg_union(evt:ReceiveMsgEvent):void
		{
			//添加到面板
			msgConverter_union(evt.sender, evt.msg, _unionLab);
			//显示在综合图文面板
			msgConverter_union(evt.sender, evt.msg, _allLab);
			scrollToEnd();
		}
		/**
		 * 收到[联盟]消息处理函数
		 * */
		private function receiveMsg_guild(evt:ReceiveMsgEvent):void
		{
			//添加到面板
			msgConverter_guild(evt.sender, evt.msg, _guildLab);
			//显示在综合图文面板
			msgConverter_guild(evt.sender, evt.msg, _allLab);
			scrollToEnd();
		}		
		/**
		 * 根据信息来返回该信息表示的段落[私聊]
		 * */
		private function msgConverter_whisper(sender:String, receiver:String, msg:String, lab:RichTextArea, lanzuan:int = 0):void
		{
			lab.appendCache("[私聊]", ChatConst.COLOR_WHISPER);

			//发送者
			lab.appendCache("<a href='event:u_"+sender+"'>["+sender+"]</a>", ChatConst.COLOR_USER, lanzuan);
			//"对"
			lab.appendCache(" 对 ", ChatConst.COLOR_COMMON);
			//接收者
			lab.appendCache("<a href='event:u_"+receiver+"'>["+receiver+"]</a>", ChatConst.COLOR_USER);
			//"说"
			lab.appendCache(" 说: ", ChatConst.COLOR_COMMON);
			//信息的内容
			if (isShowText(msg))
			{
				msg = msg.substring(ChatConst.showFormat_Front.length, msg.length - ChatConst.showFormat_Back.length);
				var arrShow:Array = msg.split(ChatConst.showSplit);
				var content:String = "", type:String = "", heroID:String = "";
				if (arrShow[0])
				{
					content = arrShow[0];
				}
				if (arrShow[1])
				{
					type = arrShow[1];
				}
				if (arrShow[2])
				{
					heroID = arrShow[2];
				}
				if (arrShow[3])
				{
					ChatConst.COLOR_HERO = arrShow[3];
				}
				lab.appendCache("<a href='event:"+type+"_"+content+"'>["+content+"]</a>", ChatConst.COLOR_HERO);
			}
			else
			{
				var extraLength:int = 15+sender.length+receiver.length;
				var richMess:Object=lab._textField.converStringToRich(msg,extraLength);
				lab.appendCache(richMess.mess, ChatConst.COLOR_WHISPER, richMess.faces);
			}
			lab.flush();
		}		
		/**
		 * 收到[私聊]消息处理函数
		 * */
		private function receiveMsg_whisper(evt:ReceiveMsgEvent):void
		{
			msgConverter_whisper(evt.sender, evt.receiver, evt.msg, _whisperLab);
			msgConverter_whisper(evt.sender, evt.receiver, evt.msg, _allLab);
			scrollToEnd();
		}
		/**
		 * 根据信息来返回该信息表示的段落[世界]
		 * */
		private function msgConverter_world(sender:String, msg:String, lab:RichTextArea, lanzuan:int = 0):void
		{
			lab.appendCache("[世界]", ChatConst.COLOR_WORLD);
			//发送者
			if (sender)
			{
				lab.appendCache("<a href='event:u_"+sender+"'>["+sender+"]</a>", ChatConst.COLOR_USER, lanzuan);
				lab.appendCache(": ", ChatConst.COLOR_COMMON);
			}
			if (isShowText(msg))
			{
				msg = msg.substring(ChatConst.showFormat_Front.length, msg.length - ChatConst.showFormat_Back.length);
				var arrShow:Array = msg.split(ChatConst.showSplit);
				var content:String = "", type:String = "", heroID:String = "";
				if (arrShow[0])
				{
					content = arrShow[0];
				}
				if (arrShow[1])
				{
					type = arrShow[1];
				}
				if (arrShow[2])
				{
					heroID = arrShow[2];
				}
				if (arrShow[3])
				{
					ChatConst.COLOR_HERO = arrShow[3];
				}
				lab.appendCache("<a href='event:"+type+"_"+content+"'>["+content+"]</a>", ChatConst.COLOR_HERO);
			}
			else
			{
				var extraLength:int = 8+sender.length;
				var richMess:Object=lab._textField.converStringToRich(msg, extraLength);
				lab.appendCache(richMess.mess, ChatConst.COLOR_WORLD, richMess.faces);
			}
			lab.flush();
		}		
		/**
		 * 收到[世界]消息处理函数
		 * */
		private function receiveMsg_world(evt:ReceiveMsgEvent):void
		{
			//添加到世界面板
			msgConverter_world(evt.sender, evt.msg, _worldLab);
			//显示在综合图文面板
			msgConverter_world(evt.sender, evt.msg, _allLab);
			scrollToEnd();	
		}
		/**
		 * 判断是否是展示类型的文本
		 * */
		private function isShowText(msg:String):Boolean
		{
			var indexFront:int = msg.indexOf(ChatConst.showFormat_Front);
			var indexBack:int = msg.lastIndexOf(ChatConst.showFormat_Back);
			if (indexFront == 0 && indexBack == (msg.length - ChatConst.showFormat_Back.length))
			{
				return true;
			}
			return false;
		}
		/**
		 * 收到[系统]消息处理函数
		 * */
		private function receiveMsg_system(evt:ReceiveMsgEvent):void
		{
			dealMsg_system(evt.sender, evt.msg, _currentLab);
			
			if (_currentLab != _allLab)
				dealMsg_system(evt.sender, evt.msg, _allLab);
		}
		private function dealMsg_system(sender:String, msg:String, lab:RichTextArea):void
		{
			lab.appendCache("[系统]", ChatConst.COLOR_SYSTEM);
			//发送者
			if (sender)
			{
				lab.appendCache("<a href='event:u_"+sender+"'>["+sender+"]</a>", ChatConst.COLOR_USER);
				lab.appendCache(": ", ChatConst.COLOR_COMMON);
			}
			else
			{
//				lab.appendCache("[公告]", ChatConst.COLOR_SYSTEM);
			}
			if (isShowText(msg))
			{
				msg = msg.substring(ChatConst.showFormat_Front.length, msg.length - ChatConst.showFormat_Back.length);
				var arrShow:Array = msg.split(ChatConst.showSplit);
				var content:String = "", type:String = "", heroID:String = "";
				if (arrShow[0])
				{
					content = arrShow[0];
				}
				if (arrShow[1])
				{
					type = arrShow[1];
				}
				if (arrShow[2])
				{
					heroID = arrShow[2];
				}
				if (arrShow[3])
				{
					ChatConst.COLOR_HERO = arrShow[3];
				}
				lab.appendCache("<a href='event:"+type+"_"+content+"'>["+content+"]</a>", ChatConst.COLOR_HERO);
			}
			else
			{
				lab.appendCache(msg, ChatConst.COLOR_SYSTEM);
			}
			lab.flush();
			scrollToEnd();
		}

		public function get currentLab():RichTextArea
		{
			return _currentLab;
		}

	}
}
