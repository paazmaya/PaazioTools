/**
 * @mxmlc -target-player=10.0.0 -source-path=D:/AS3libs -debug
 */
package sandbox
{
    import flash.display.*;
    import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.TextEvent;
	import flash.net.FileReference;
	import flash.utils.*;
	import flash.ui.Keyboard;
	
	import com.probertson.utils.GZIPBytesEncoder;
	//import com.wirelust.as3zlib.*;
	
	[SWF(backgroundColor = '0x042836', frameRate = '33', width = '800', height = '600')]

    public class CompressionTest extends Sprite
    {
		
		private var text:String = "Nanbudo has influences from many different martial arts. The idea behind Nanbudo is not to be just one of many martial arts. With widespread wholeness it is aiming at balanced and healthy life and strengthening of ones own inner power.";
		
		private var xml:String = '<?xml version="1.0" encoding="UTF-8"?><stream:stream xmlns="jabber:client" to="192.168.1.37" xmlns:stream="http://etherx.jabber.org/streams" xml:lang="en" version="1.0">';

		private var openStreamXml:String = '<?xml version="1.0" encoding="UTF-8"?><stream:stream xmlns="jabber:client" to="192.168.1.37" xmlns:stream="http://etherx.jabber.org/streams" xml:lang="en" version="1.0">';
		
		private var bytexml:ByteArray;
		
		private var bytedata:ByteArray;
		private var bytetext:ByteArray;
		private var fileRef:FileReference;
		private var gzipper:GZIPBytesEncoder;
		private var byteout:ByteArray;
		
        public function CompressionTest()
        {
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
            addEventListener( Event.ADDED_TO_STAGE, onInit );
        }

        private function onInit( event:Event ) : void
        {
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			fileRef = new FileReference();
			
			trace("text.length: " + text.length); // 235
			
			bytedata = new ByteArray();
			trace("bytedata default endian: " + bytedata.endian); // bigEndian
			bytedata.endian = Endian.LITTLE_ENDIAN; // Gzip is little.
			
			bytedata.writeUTFBytes(text);
			trace("Before toString(): " + bytedata.toString()); // Nanbudo ...
			
			trace("Before compress length: " + bytedata.length); // 235
			bytedata.compress(); // zlib
			trace("After compress length: " + bytedata.length); // 158
			
			trace("After compress position: " + bytedata.position); // 158
			bytedata.position = 0;
			trace("After compress bytesAvailable: " + bytedata.bytesAvailable); // 158
			
			trace("objectEncoding: " + bytedata.objectEncoding); // 3
			
			trace("After compress toString(): " + bytedata.toString()); // xÚU...
			
			
			gzipper = new GZIPBytesEncoder();
			byteout = gzipper.compressToByteArray(bytedata);
			
			
			bytetext = new ByteArray();
			bytetext.endian = Endian.LITTLE_ENDIAN; //
			bytetext.writeUTFBytes(text);
			trace("bytetext before anything: " + bytetext.toString());
			
			bytexml = new ByteArray();
			bytexml.endian = Endian.LITTLE_ENDIAN; //
			bytexml.writeUTFBytes(xml);
			/*
			trace("bytexml before anything: " + bytexml.toString());
			bytexml.compress();
			trace("bytexml compress and check zlib parts.");
			zlibParts(bytexml);
			*/
		}
		/*
		private function compressAs3zlib(data:ByteArray):ByteArray
		{
			var compressed:ByteArray = new ByteArray();

			var d_stream:ZStream = new ZStream();
			d_stream.next_in = data;
			d_stream.next_in_index = 0;
			d_stream.next_out = compressed;
			d_stream.next_out_index = 0;

			var err:int = d_stream.deflateInit(4);

			while (d_stream.total_out != 1 && d_stream.total_in < compressed.length)
			{
				d_stream.avail_in = d_stream.avail_out = 10;

				err = d_stream.deflate(JZlib.Z_NO_FLUSH);
				if (err == JZlib.Z_STREAM_END)
				{
					trace("decompress success.");
					break;
				}
				else if (err == JZlib.Z_STREAM_ERROR)
				{
					trace("stream error:" + " " + d_stream.msg);
					break;
				}
				else if (err == JZlib.Z_DATA_ERROR)
				{
					trace("data error:" + " " + d_stream.msg);
					break;
				}

			}
			err = d_stream.deflateEnd();
			

			// uncompressed now contains the inflated data

			return compressed;
		}*/
		
		private function compressNative(data:ByteArray):ByteArray
		{
			data.compress();
			return data;
		}
		
		private function compressGzip(data:ByteArray):ByteArray
		{
			return gzipper.compressToByteArray(data);
		}
		
		private function onKeyUp(event:KeyboardEvent):void
		{
			switch (event.keyCode)
			{
				case 73:
					// i
					bytetext.inflate();
					trace("inflate: " + bytetext.toString());
					break;
				case 68:
					// d
					bytetext.deflate();
					trace("deflate: " + bytetext.toString());
					break;
				case 67:
					// c
					bytetext.compress();
					trace("compress: " + bytetext.toString());
					break;
				case 85:
					// u
					bytetext.uncompress();
					trace("uncompress: " + bytetext.toString());
					break;
				case Keyboard.SPACE:
					fileRef.save(bytexml, "bytexml.zlib");
					//fileRef.save(bytetext, "bytetext.gz");
					//fileRef.save(bytedata, "bytedata.gz");
					break;
				case Keyboard.ENTER:
					fileRef.addEventListener(Event.COMPLETE, onFileComplete);
					fileRef.addEventListener(Event.SELECT, onFileSelect);
					fileRef.browse();
					break;
				case Keyboard.F1:
					//fileRef.save(compressAs3zlib(bytexml), "bytexml.as3zlib");
					break;
				case Keyboard.F2:
					fileRef.save(compressNative(bytexml), "bytexml.native");
					break;
				case Keyboard.F3:
					fileRef.save(compressGzip(bytexml), "bytexml.gzip");
					break;
				case Keyboard.F8:
					var	littleOpen:ByteArray = new ByteArray();
					littleOpen.endian = Endian.LITTLE_ENDIAN;
					littleOpen.writeUTFBytes(openStreamXml);
					littleOpen.compress();
					
					var fileLittle:FileReference = new FileReference();
					fileLittle.save(littleOpen, "openStreamXml.little.z");
					break;
				case Keyboard.F9:
					var	bigOpen:ByteArray = new ByteArray();
					bigOpen.endian = Endian.BIG_ENDIAN;
					bigOpen.writeUTFBytes(openStreamXml);
					bigOpen.compress();
					
					var fileBig:FileReference = new FileReference();
					fileBig.save(bigOpen, "openStreamXml.big.z");
					break;
			}
		}
		
		private function zlibParts(data:ByteArray):void
		{
			data.position = 0;
			// Lets see how zlib goes.
			
			var cmf:int = data.readByte();
			trace("CMF: " + cmf.toString()); // 78, 120
			trace("CM: " + (cmf >> 4 & 0xF)); // 7
			trace("CINFO: " + (cmf & 0xF)); // 8
			
			var flg:int = data.readByte();
			trace("FLG: " + flg.toString()); // -26, -38
			trace("FCHECK: " + (flg >> 5 & 0xF)); // 14
			trace("FDICT: " + (flg >> 1 & 0x7)); // 5
			trace("FLEVEL: " + (flg & 0x7)); // 2
		}
		
		private function onFileComplete(event:Event):void
		{
			var data:ByteArray = fileRef.data;
			trace("onFileComplete");
			trace("Before data: " + data.toString());
			trace("data endian: " + data.endian); // bigEndian
			
			zlibParts(data);
			
			//data.uncompress();
			//trace("uncompressed: " + data.toString());
			
			//var datain:ByteArray = gzipper.uncompressToByteArray(data);
			//trace("After datain: " + datain.toString());
		}
		
		private function onFileSelect(event:Event):void
		{
			trace("onFileSelect");
			fileRef.load();
		}

    }
}
