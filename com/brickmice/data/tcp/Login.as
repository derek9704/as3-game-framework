package com.brickmice.data.tcp
{
	import com.brickmice.data.tcp.events.*;
	import com.brickmice.view.ViewMessage;
	import com.framework.core.ViewManager;
	
	import flash.events.EventDispatcher;

	public class Login extends EventDispatcher
	{
		private var conn : Tcp;
		public var bLogined : Boolean;
		public var name : String;
		
		public function Login(_conn : Tcp)
		{
			conn = _conn;
			bLogined = false;
			conn.addEventListener(NetworkEvent.USER, onUser);
			conn.addEventListener(NetworkEvent.DISCONNECT, onDisconnect);
		}
		
		private function onDisconnect(evt:NetworkEvent) : void
		{
			if (bLogined)
			{
				bLogined = false;			
				dispatchEvent(new LoginEvent(LoginEvent.LOGIN_OUT));
			}
		}
		
		public function SendAuthLogin(_uid:int, _sid:String) : void
		{
			conn.SendRequest("user", {method:'auth_login', uid:_uid, sid:_sid});
		}
		
		private function onUser(event : NetworkEvent) : void
		{
			var method:String = event.args['method'];
			if (!method)
			{
				return;
			}
			switch(method)
			{
				case 'auth_login':
					{
						var result:String = event.args['result'];
						switch (result)
						{
							case 'ok': 
								bLogined = true;
								name = event.args['name'];
								dispatchEvent(new LoginEvent(LoginEvent.LOGIN_IN)); 
								break;
							default:
								trace('login failed. reason: ' + result);
								dispatchEvent(new LoginEvent(LoginEvent.LOGIN_FAIL)); 
								break;
						}
					}
					break;
				case 'kick':
					{
						var reason:String = event.args['reason'];
						bLogined = false;
						if(reason == "multi_login")
							conn.dispatchEvent(new LoginEvent(LoginEvent.MULTI_LOGIN));				
					}
					break;
				case 'channel':
					{
						var func:String = event.args['func'];
						var args:String = event.args['args'];
						var data:Object = {};
						switch(func)
						{
							case 'warVictory':
							{
								var tmp:Array = args.split('|');
								data['union'] = tmp[0];
								data['txt'] = tmp[1];
								ViewManager.sendMessage(ViewMessage.WAR_VICTORY, data);
								break;
							}
							case 'callKan':
							{
								tmp = args.split('|');
								data['head'] = tmp[0];
								data['union'] = tmp[1];
								data['txt'] = tmp[2];
								ViewManager.sendMessage(ViewMessage.CALL_KAN, data);
								break;
							}
							case 'notice':
							{
								dispatchEvent(new ReceiveMsgEvent(ReceiveMsgEvent.SYSTEM_MSG, null, null, event.args['args']));
								break;
							}
							default:
							{
								break;
							}
						}
					}
					break;
				default:
			}
		}
	}
}