package com.brickmice.controller
{	
	import com.brickmice.data.tcp.Login;
	import com.brickmice.data.tcp.Tcp;
	import com.brickmice.data.tcp.events.ChatErrorEvent;
	import com.brickmice.data.tcp.events.NetworkEvent;
	import com.brickmice.data.tcp.events.ReceiveMsgEvent;
	
	import flash.events.*;
	import flash.utils.*;

	public class ChatController extends EventDispatcher
	{
		private var conn : Tcp;
		private var login : Login;
		
		public function ChatController(_conn : Tcp, _login : Login)
		{
			conn = _conn;
			login = _login;
			conn.addEventListener(NetworkEvent.CHAT, onChat);
		}
		
		private function onChat(event : NetworkEvent) : void
		{
			var method:String = event.args['method'];
			if (!method)
			{
				return;
			}
			var msg : String = event.args['msg'];
			var sender : String = event.args['sender'];
			var recver : String = event.args['recver'];
			switch(method)
			{
				case 'whisper_r':
				{
					if (msg && recver)
					{
						trace("you wispered to " + recver + ": " + msg);
						if (recver != login.name)	//自己给自己发送的消息不显示2次。
							dispatchEvent(new ReceiveMsgEvent(ReceiveMsgEvent.WHISPER_MSG, login.name, recver, msg));
					}
					break;
				}
				case 'whisper_n':
				{
					if (msg && sender)
					{
						trace(sender + " wispered: " + msg);
						dispatchEvent(new ReceiveMsgEvent(ReceiveMsgEvent.WHISPER_MSG, sender, login.name, msg));
					}
					break;
				}
				case 'system_n':
				{
					if (msg)
					{
						trace("[system]:" + msg);
						dispatchEvent(new ReceiveMsgEvent(ReceiveMsgEvent.SYSTEM_MSG, 
							sender ? sender : null, 
							recver ? recver : null, 
							msg));
					}
					break;
				}
				case 'unionmsg_n':
				{
					if (msg && sender)
					{
						trace(sender + " in guild: " + msg);
						dispatchEvent(new ReceiveMsgEvent(ReceiveMsgEvent.GUILD_MSG, sender, null, msg));
					}
					break;
				}
				case 'merchantmsg_n':
				{
					if (msg && sender)
					{
						trace(sender + " in union: " + msg);
						dispatchEvent(new ReceiveMsgEvent(ReceiveMsgEvent.UNION_MSG, sender, null, msg));
					}
					break;
				}					
				case 'worldmsg_n':
				{
					if (msg && sender)
					{
						trace(sender + " in world: " + msg);
						dispatchEvent(new ReceiveMsgEvent(ReceiveMsgEvent.WORLD_MSG, sender, null, msg));
					}
					break;
				}
				case 'error':
				{
					var error:String = event.args['error'];
					var type:String = event.args['type'];
					if (!type) type = ReceiveMsgEvent.SYSTEM_MSG;
					if (error)
					{
						trace (type + "error : " + error);
						dispatchEvent(new ChatErrorEvent(ChatErrorEvent.ERROR, type, error));
					}
					break;
				}
					
				default:
					break;
			}
		}
		
		public function SendWhisper(_recver : String, _msg : String) : void
		{
			if (!login.bLogined)
			{
				dispatchEvent(new ChatErrorEvent(ChatErrorEvent.ERROR, 'whisper', 'need login'));
				return;
			}
			if (_recver.length <= 0)
			{
				dispatchEvent(new ChatErrorEvent(ChatErrorEvent.ERROR, 'whisper', 'need target'));
				return;
			}
			conn.SendRequest('chat', {method:'whisper', recver:_recver, msg:_msg});
		}
		
		public function SendUnionMsg(_msg : String) : void
		{
			if (!login.bLogined)
			{
				dispatchEvent(new ChatErrorEvent(ChatErrorEvent.ERROR, 'union', 'need login'));
				return;
			}
			conn.SendRequest('chat', {method:'merchant_msg', msg:_msg});
		}
		
		public function SendGuildMsg(_msg : String) : void
		{
			if (!login.bLogined)
			{
				dispatchEvent(new ChatErrorEvent(ChatErrorEvent.ERROR, 'guild', 'need login'));
				return;
			}
			conn.SendRequest('chat', {method:'union_msg', msg:_msg});
		}		
		
		public function SendWorldMsg(_msg : String) : void
		{
			if (!login.bLogined)
			{
				dispatchEvent(new ChatErrorEvent(ChatErrorEvent.ERROR, 'world', 'need login'));
				return;
			}
			conn.SendRequest('chat', {method:'world_msg', msg:_msg});
		}
	}
}

