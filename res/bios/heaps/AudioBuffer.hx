package res.bios.heaps;

import haxe.io.Bytes;
import haxe.io.BytesOutput;
import hxd.fs.FileEntry;
import hxd.res.Sound;
import hxd.snd.Data;
import res.audio.IAudioBuffer;
import res.audio.IAudioStream;

class HeapsAudioData extends Data {
	var stream:IAudioStream;

	var rawPCM:Bytes;

	public function new(stream:IAudioStream) {
		this.stream = stream;

		channels = stream.numChannels;
		samples = stream.numSamples;
		samplingRate = stream.sampleRate;
		sampleFormat = I16;

		final bo = new BytesOutput();

		for (n => sample in stream) {
			for (nChannel => amp in sample) {
				bo.writeInt16(Std.int(amp * 32767));
			}
		}

		rawPCM = bo.getBytes();
	}

	override function decodeBuffer(out:Bytes, outPos:Int, sampleStart:Int, sampleCount:Int) {
		final bpp = getBytesPerSample();
		out.blit(outPos, rawPCM, sampleStart * bpp, sampleCount * bpp);
	}
}

class DummyEntry extends FileEntry {
	override function get_path():String {
		return 'dummy';
	}

	public function new() {
		name = 'dummy';
	}
}

class AudioBuffer implements IAudioBuffer extends Sound {
	public final numChannel:Int;

	public final numSamples:Int;

	public final sampleRate:Int;

	var stream:IAudioStream;

	public function new(audioStream:IAudioStream) {
		super(new DummyEntry());

		stream = audioStream;

		data = new HeapsAudioData(audioStream);

		numChannel = audioStream.numChannels;
		numSamples = audioStream.numSamples;
		sampleRate = audioStream.sampleRate;
	}
}
