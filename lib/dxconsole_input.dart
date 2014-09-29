part of dxConsole;

const bool bDEBUGMODEDXCONSOLE = false;

/**
 * Manipulates the Win32 api ReadConsoleInput function running in its own thread to directly access a console's input buffer.
 * Do not mix ConsoleInputEvents & stdin streams in the same application. Use ConsoleInputEvents or stdin, but not both.
 * All stdin consumers process/remove stdin events in FIFO order, so they can not be shared.
 */

const int VK_ENTER = 0x0D;
const int VK_TAB = 0x09;
const int VK_ESCAPE = 0x1B;
const int VK_END = 0x23;
const int VK_HOME = 0x24;
const int VK_LEFT = 0x25;
const int VK_UP = 0x26;
const int VK_RIGHT = 0x27;
const int VK_DOWN = 0x28;
const int VK_HELP = 0x2F;
const int VK_F1 = 0x70;
const int VK_F2 = 0x71;
const int VK_F3 = 0x72;
const int VK_F4 = 0x73;
const int VK_F5 = 0x74;
const int VK_F6 = 0x75;
const int VK_F7 = 0x76;
const int VK_F8 = 0x77;
const int VK_F9 = 0x78;
const int VK_F10 = 0x79;
const int VK_F11 = 0x80;
const int VK_F12 = 0x81;

const int EVT_KEYBOARD = 0x0001; // Event contains key event record
const int EVT_MOUSE = 0x0002; // Event contains mouse event record
const int EVT_WINDOW_BUFFER_SIZE = 0x0004; // Event contains window change event record
const int EVT_MENU = 0x0008; // Event contains menu event record
const int EVT_FOCUS = 0x0010; // event contains focus change

//
// ButtonState flags
//
const int FROM_LEFT_1ST_BUTTON_PRESSED = 0x0001;
const int RIGHTMOST_BUTTON_PRESSED = 0x0002;
const int FROM_LEFT_2ND_BUTTON_PRESSED = 0x0004;
const int FROM_LEFT_3RD_BUTTON_PRESSED = 0x0008;
const int FROM_LEFT_4TH_BUTTON_PRESSED = 0x0010;

//
// Mouse EventFlags
//
const int EVTFLAGS_SINGLE_CLICK = 0x0000;
const int EVTFLAGS_MOUSE_MOVED = 0x0001;
const int EVTFLAGS_DOUBLE_CLICK = 0x0002;
const int EVTFLAGS_MOUSE_WHEELED = 0x0004;
//#if(_WIN32_WINNT >= 0x0600)
const int EVTFLAGS_MOUSE_HWHEELED = 0x0008;
//#endif /* _WIN32_WINNT >= 0x0600 */

/**
 * InputEventData is returned as List<int>(Uint8List(3)) when lineMode==false for each keypress
 * ex. Esc key pressed generates
 * inputEventData[iKA_EVENTTYPE]=KEY_EVENT
 * inputEventData[iKA_KEYCHAR]=27
 * inputEventData[iKA_KEYCODE]=27
 */
//TODO:Convert to Enum???
const int iEVENTTYPE = 0;
//Keyboard Indexes
const int iKA_KEYCHAR = 1;
const int iKA_KEYCODE = 2;
const int iKA_TOTAL_ELEMENTS = 3;
//Mouse Indexes
const int iMI_MOUSE_POSX = 1;
const int iMI_MOUSE_POSY = 2;
const int iMI_MOUSE_FLAGS = 3;
const int iMI_MOUSE_BTNSTATE = 4;
const int iMI_MOUSE_TOTAL_ELEMENTS = 5;
//Window Buffer Indexes
const int iWI_WBER_POSX = 1;
const int iWI_WBER_POSY = 2;
const int iWI_WBER_TOTAL_ELEMENTS = 3;

class ConsoleInputEventsParms {
	Completer _completer;
	Function _fnInputEvents;
	String sSendKeys;
	bool _bEchoMode,
			_bLineMode,
			_addEvtMouse = false,
			_addEvtWindow = false;
	ConsoleInputEventsParms(this._fnInputEvents, [this._bLineMode = true, this._bEchoMode = true]);
	/**
     * Set the default Handler for incoming messages
     */
	set fnInputEvents(Function fn) => _fnInputEvents = fn;

	/**
       * Check if echo mode is enabled.
       */
	bool get bEchoMode => _bEchoMode;

	/**
       * Enable or disable echo mode.
       * If disabled, input from to console will not be echoed.
       */
	set bEchoMode(bool enabled) => _bEchoMode = enabled;

	/**
   * Check if line mode is enabled.
   */
	bool get bLineMode => _bLineMode;

	/**
   * Enable or disable line mode on.
   * If enabled, characters are delayed until a new-line character is entered.
   * If disabled, characters will be available as typed.
   */
	set bLineMode(bool enabled) => _bLineMode = enabled;

	/**
   * Check if Mouse events are captured.
   */
	bool get bMouseEvents => _addEvtMouse;

	/**
   * Enable or disable capturing Mouse events.
   */
	set bMouseEvents(bool enabled) => _addEvtMouse = enabled;

	/**
   * Check if Window events are captured.
   */
	bool get bWindowEvents => _addEvtWindow;

	/**
   * Enable or disable capturing Window events.
  */
	set bWindowEvents(bool enabled) => _addEvtWindow = enabled;
}

class ConsoleInputEvents {
	//must stay in sync with extension
	final int iACTION_STOP = 0;
	final int iACTION_START = 1;

	final int iARGSIDX_ACTION = 0;
	final int iARGSIDX_SENDPORT_OR_ACTIONRESULT = 1;

	//if you prefer using streams, uncomment lines related to _controller
	//static StreamController _controller;
	Map<int, ConsoleInputEventsParms> mapInputParms;
	static SendPort _spSend;
	static ConsoleInputEvents _cieSingleton;
	static RawReceivePort _rrpReply;
	int _iPendingParmKey;

	factory ConsoleInputEvents() {
		// Create it if we don't have one.
		if (_cieSingleton == null) _cieSingleton = new ConsoleInputEvents._internal();
		return _cieSingleton;
	}

	ConsoleInputEvents._internal() {
		_rrpReply = new RawReceivePort();
		//_controller = new StreamController(onListen: _onListen, onPause: _onPause, onResume: _onListen, onCancel: _onPause);
		mapInputParms = new Map<int, ConsoleInputEventsParms>();
	}

	ConsoleInputEventsParms getCIEvtParms(int iParmsKey, Completer completer) {
		ConsoleInputEventsParms _ConsoleInputParms;
		//ensure no other pending request is active
		if (iParmsKey == null) {
			completer.completeError("invalid iParmsKey");
		} else if (_iPendingParmKey != null || _iPendingParmKey == iParmsKey) {
			completer.completeError("parms:${_iPendingParmKey}, pending request outstanding");
		} else {
			//assert(sParmsName.length > 0);
			//stderr.writeln("start:${sParmsName}");
			_ConsoleInputParms = mapInputParms[iParmsKey];
			//assert(_parms != null);
			if (_ConsoleInputParms == null) {
				completer.completeError("parms:${_iPendingParmKey}, does not exist");
			} else if (_ConsoleInputParms._completer != null) {
				completer.completeError("parms:${_iPendingParmKey}, _completer pending outstanding");
			}
		}
		return _ConsoleInputParms;
	}

	Future<bool> start(int iParmsKey, [String sSendKeys]) {
		final Completer _completer = new Completer();
		ConsoleInputEventsParms _parms = getCIEvtParms(iParmsKey, _completer);

		//ensure no other pending request is active
		if (_parms != null) {
			_rrpReply.handler = _onReply;
			//save _completer for _onReply
			_parms._completer = _completer;

			_iPendingParmKey = iParmsKey;
			//send start action to native extension
			new Future<bool>(() {
				List args = new List(6);
				args[iARGSIDX_ACTION] = iACTION_START;
				args[iARGSIDX_SENDPORT_OR_ACTIONRESULT] = _rrpReply.sendPort;
				args[2] = _parms.bLineMode;
				args[3] = _parms.bEchoMode;
				args[4] = _parms.bMouseEvents;
				args[5] = _parms.bWindowEvents;
				_parms.sSendKeys = sSendKeys;
				_servicePort.send(args);
				return true;
			});
		}
		return _completer.future; // Send future object back to client.
	}

	Future<bool> stop() {
		final Completer _completer = new Completer();

		if (_iPendingParmKey != null) {
			_completer.completeError("parms:${_iPendingParmKey}, pending request outstanding");
		}
		if (mapInputParms.keys.length == 0) {
			//rather than throw an error, just assume nothing was ever started?
			_completer.complete(true);
		} else {
			_rrpReply.handler = _onReply;
			//save _completer for _onReply, use first key entry
			_iPendingParmKey = mapInputParms.keys.first;
			mapInputParms[_iPendingParmKey]._completer = _completer;
			new Future<bool>(() {
				List args = new List(2);//+1 for _onReply result
				args[iARGSIDX_ACTION] = iACTION_STOP;
				_servicePort.send(args);
				return true;
			});
		}
		return _completer.future; // Send future object back to client.
	}

	void _onReply(dynamic vResult) {
		//ignore unprocessed keystroke events
		if (vResult is List) {
			ConsoleInputEventsParms _parms = mapInputParms[_iPendingParmKey];
			List lstResult = vResult;
			if (lstResult.length > 1) {
				//check extension's return code
				if (lstResult[iARGSIDX_SENDPORT_OR_ACTIONRESULT] == true) {
					//is START action?
					if (lstResult[iARGSIDX_ACTION] == iACTION_START) {
						Function _fnhandler = _parms._fnInputEvents;
						assert(_fnhandler is Function && _fnhandler != null);
						//PERF: Replace _onReply with our real handler
						_rrpReply.handler = _fnhandler;
						String _sendKeys = _parms.sSendKeys;
						if (_sendKeys != null && _sendKeys.length > 0) DXConsole.sendKeys(_sendKeys);
					}
				}
				_parms._completer.complete(true);
				_parms._completer = null;
				_iPendingParmKey = null;
				return;
			}
		}

		String sTypeName = vResult.runtimeType.toString();
		stderr.write("\n--------------------------------" "\n_onReply unprocessed eventType:$sTypeName\nValue:$vResult" "\n--------------------------------");
		throw new StateError("ConsoleInput: _onReply");
	}

//	void _onListen() =>listen(_onReply);
//	void _onPause() {}
//	void _onReply(result) {
//		if (result != null) {
////			if (result is List<int>) {
////			} else {
////				print("_onReply:$result");
////			}
//			_controller.add(result);
//		} else {
//			//_replyPort.close();
//			throw new StateError("ConsoleInput: _onReply");
//		}
//	}

	//Stream get events => _controller.stream;

	SendPort get _servicePort {
		if (_spSend == null) {
			_spSend = _newServicePort();
		}
		return _spSend;
	}

	SendPort _newServicePort() native "ServicePort_ConsoleInput";
}
