package res.bios.heaps;

import hxd.snd.Channel;

class AudioChannel extends res.audio.AudioChannel {
	public var _channel:Channel;

	var _buffer:AudioBuffer;
	var _loop:Bool;
	var _playing:Bool = false;
	var _ended:Bool = false;
	var _position:Float = 0;

	public function new(buffer:AudioBuffer, loop:Bool) {
		_buffer = buffer;
		_loop = loop;
	}

	function onEnd() {
		trace('onEnd');
		_ended = true;
		_playing = false;
		stop();
	}

	override function isEnded():Bool {
		return _ended;
	}

	override function isPlaying():Bool {
		return _playing;
	}

	override function pause() {
		_playing = false;
		_position = _channel.position;
		_channel.pause = true;
	}

	override function resume() {
		_channel.pause = false;
		_playing = true;
	}

	override function start() {
		_channel = _buffer.play(_loop);
		_playing = true;
		_channel.onEnd = onEnd;
	}

	override function stop() {
		_playing = false;
		super.stop();
	}
}
