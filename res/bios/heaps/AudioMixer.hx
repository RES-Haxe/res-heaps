package res.bios.heaps;

import res.audio.IAudioBuffer;

class AudioMixer extends res.audio.AudioMixer {
	public function new() {}

	override function createAudioChannel(buffer:IAudioBuffer, ?loop:Bool):res.audio.AudioChannel
		return new AudioChannel(cast buffer, loop);
}
