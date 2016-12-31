package com.brickmice.data.tcp
{
	
	import com.brickmice.data.Data;
	import com.brickmice.data.tcp.events.*;
	
	import flash.errors.IOError;
	import flash.events.*;
	import flash.net.Socket;
	import flash.utils.*;
	
	/**
	 * TCP连接
	 * @author Derek
	 * 
	 */	
	public class Tcp extends EventDispatcher
	{
		protected static var instance : Tcp;
		
		/**
		 * 提供单态的访问Tcp实例
		 */
		public static function getInstance() : Tcp
		{
			if (instance == null)
				instance = new Tcp();
			
			return instance as Tcp;
		}
		
		private var _kickout : Boolean;	 //是否被踢线		
		private var connected : Boolean; //是否连接
		private var readbuff : ByteArray;
		private var _socket : Socket;
		private var ip : String;
		private var port : int;
		private var flag : Boolean;	//数据传输时使用的一个标记
		
		public function Tcp()
		{
			_socket = new Socket();
			_kickout = false;
			connected = false;
			flag = false;
			addEventListener(LoginEvent.MULTI_LOGIN, kickOut);
			var timer:Timer = new Timer(30000);
			timer.addEventListener(TimerEvent.TIMER, function():void{
				if (connected)
					SendRequest("user", {method:"nop"});
			});
			timer.start();
		}
		
		public function Connect(_ip: String, _port:int) : void
		{
			if(_kickout)
			{
				return;
			}
			ip = _ip;
			port = _port;
			trace("connecting: " + ip + ":" + port);
			_socket.addEventListener(Event.CONNECT, onConnect);
			_socket.addEventListener(Event.CLOSE, onClose);
			_socket.addEventListener(ProgressEvent.SOCKET_DATA, onData);
			_socket.addEventListener(IOErrorEvent.IO_ERROR, onIoError);
			_socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityErr);
			
			_socket.connect(ip, port);
		}
		
		/**
		 * 编码成传递给服务器的字符串
		 * @param value 字符串
		 * @return 
		 * 
		 */		
		private function Encode(value : String) : String
		{
			var ret : String = '';
			for (var i : int; i < value.length; i ++)
			{
				switch ( value.charAt(i) )
				{
					case '&': ret += '&&';break;										
					case ';': ret += '&1';break;										
					case '=': ret += '&2';break;										
					case '\n': ret += '&n';break;										
					default : ret += value.charAt(i);
				}
			}
			return ret;
		}
		
		/**
		 * 解析从服务器传来的字符串 
		 * @param value 字符串
		 * @return 
		 * 
		 */		
		private function Decode(value : String) : String
		{
			var ret : String = '';
			for (var i: int = 0 ; i < value.length; i++)
			{
				if ( value.charAt(i) == '&' && i+1 < value.length)
				{
					switch (value.charAt(++i))
					{
						case '&':
							ret += '&'; break;
						case '1':
							ret += ';'; break;
						case '2':
							ret += '='; break;
						case 'n':
							ret += '\n'; break;
					}
				}
				else ret += value.charAt(i);
			}
			return ret;
		}
		
		/**
		 * 向服务端发送命令 
		 * @param cmd 命令
		 * @param args 参数
		 * 
		 */		
		public function SendRequest(cmd : String, args : Object) : void
		{
			if (!connected)
			{
				throw new flash.errors.IOError();
			}
			var data : String = ConstructRequest(cmd, args);
			//trace("Sending request: " + data);
			_socket.writeUTFBytes(data);
			_socket.flush();
		}
		
		private function ConstructRequest(cmd : String, args : Object) : String
		{
			var data : String = cmd + ';';
			for (var key : String in args)
			{
				data = data + Encode(key) + '=' + Encode(args[key]) + ';';
			}
			return data + '\n';
		}
		
		private function ParseRequest(data: String) : void
		{
			var Seq : Array = data.split(';');
			if (Seq.length < 1)
			{
				return;
			}
			
			var Cmd : String = Seq[0];
			var Args : Object = new Object();
			
			for (var i : int = 1; i < Seq.length; i++)
			{
				var header : String = Seq[i];
				var pos : int = header.indexOf("=");
				if (pos <= 0)
				{
					continue;
				}
				var key : String = header.substr(0, pos);
				var value : String = header.substr(pos + 1);
				Args[Decode(key)] = Decode(value);
			}
			dispatchEvent(new NetworkEvent(Cmd, Args));			
		}
		
		private function ParseRequests() : void
		{
			var part : ByteArray = new ByteArray();
			readbuff.position = 0;
			while (readbuff.bytesAvailable > 0) 
			{
				var bt : int = readbuff.readByte();
				if (bt == 10)	// '\n'分割命令
				{
					part.position = 0;
					var data : String = part.readUTFBytes(part.length);
					//trace("Recieved notify:" + data);
					ParseRequest(data);
					part = new ByteArray();					
				}
				else
				{
					part.writeByte(bt);
				}				
			}
			readbuff = part;
			flag = true;
		}
		
		/**
		 * socket从服务端获取数据处理函数
		 * 
		 */		
		private function onData(event: Event) : void
		{
			if (!readbuff || !flag)
			{
				readbuff = new ByteArray();
			}
			var bytes : ByteArray = new ByteArray;
			_socket.readBytes(bytes);
			flag = false;
			readbuff.position = readbuff.length;
			readbuff.writeBytes(bytes);
			ParseRequests();
		}
		
		/**
		 * 安全沙箱错误
		 * 结果:连接失败，发送conn_fail事件以重新连接.
		 */		
		private function onSecurityErr(e : SecurityErrorEvent):void
		{
			trace("connect failed.");
			connected = false;
			dispatchEvent(new NetworkEvent(NetworkEvent.CONNECTE_FAIL, {}));
			removeSocketListeners();
		}
		private function onIoError(event: Event) : void
		{
			trace("connect failed.");
			connected = false;
			dispatchEvent(new NetworkEvent(NetworkEvent.CONNECTE_FAIL, {}));
			removeSocketListeners();
		}
		
		/**
		 * 连接关闭处理函数
		 * 结果: 发送NetworkEvent的disconnect事件, 以便重新连接.
		 */		
		private function onClose(event:Event) : void
		{
			trace("connect closed.");
			connected = false;
			dispatchEvent(new NetworkEvent(NetworkEvent.DISCONNECT, {}));
			removeSocketListeners();
		}
		
		/**
		 * socket连接成功处理函数
		 * 结果: 发送NetworkEvent的connected事件
		 */		
		private function onConnect(event:Event) : void
		{
			trace("connect successed.");	
			connected = true;
			
			dispatchEvent(new NetworkEvent(NetworkEvent.CONNECTED, {}));
		} 
		
		private function kickOut(evt:LoginEvent) : void
		{
			_kickout = true;
			connected = false;
		}

		/**
		 * 删除socket的所有侦听, 重新连接时会重新创建侦听
		 */		
		private function removeSocketListeners():void
		{
			if (_socket)
			{
				_socket.removeEventListener(Event.CONNECT, onConnect);
				_socket.removeEventListener(Event.CLOSE, onClose);
				_socket.removeEventListener(ProgressEvent.SOCKET_DATA, onData);
				_socket.removeEventListener(IOErrorEvent.IO_ERROR, onIoError);
				_socket.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityErr);
			}
		}

		public function get kickout():Boolean
		{
			return _kickout;
		}

	}
}
