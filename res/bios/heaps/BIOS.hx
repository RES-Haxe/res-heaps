package res.bios.heaps;

import h2d.Interactive;
import hxd.App;
import res.audio.IAudioBuffer;
import res.audio.IAudioStream;
import res.storage.Storage;

using Math;

class RESApp extends App {
	final onInit:Void->Void;

	public var res:RES;

	public function new(onInit:Void->Void) {
		super();
		this.onInit = onInit;
	}

	override function init() {
		onInit();
	}

	override function update(dt:Float) {
		if (res != null) {
			res.update(dt);
			res.render();
		}
	}
}

class BIOS extends res.bios.BIOS {
	var app:RESApp;

	public function new() {
		super('Heaps');
	}

	override function ready(cb:() -> Void) {
		app = new RESApp(cb);
	}

	public function connect(res:RES) {
		app.s2d.scaleMode = LetterBox(res.width, res.height);

		final interactive = new Interactive(res.width, res.height);

		interactive.onMove = (ev) -> {
			res.mouse.moveTo(ev.relX.floor(), ev.relY.floor());
		};

		interactive.onPush = (ev) -> {
			res.mouse.push(switch (ev.button) {
				case 0: LEFT;
				case 1: RIGHT;
				case 2: MIDDLE;
				case _: LEFT;
			}, ev.relX.floor(), ev.relY.floor());
		};

		interactive.onRelease = interactive.onReleaseOutside = (ev) -> {
			res.mouse.release(switch (ev.button) {
				case 0: LEFT;
				case 1: RIGHT;
				case 2: MIDDLE;
				case _: LEFT;
			}, ev.relX.floor(), ev.relY.floor());
		};

		hxd.Window.getInstance().addEventTarget((ev) -> {
			switch (ev.kind) {
				case EKeyDown:
					res.keyboard.keyDown(ev.keyCode);
				case ETextInput:
					res.keyboard.input(String.fromCharCode(ev.charCode));
				case EKeyUp:
					res.keyboard.keyUp(ev.keyCode);
				case _:
			}
		});

		app.res = res;
	}

	public function createAudioBuffer(audioStream:IAudioStream):IAudioBuffer
		return new AudioBuffer(audioStream);

	public function createAudioMixer():res.audio.AudioMixer
		return new AudioMixer();

	public function createFrameBuffer(width:Int, height:Int, palette:Palette):res.display.FrameBuffer
		return new FrameBuffer(app.s2d, width, height, palette);

	public function createStorage():Storage
		return new Storage();
}
