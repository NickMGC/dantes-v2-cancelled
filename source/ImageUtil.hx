package;

import lime.graphics.ImageBuffer;
import lime.graphics.Image;
import lime.utils.UInt8Array;

// this is just code from ImageDataUtil in lime but with CFFI disabled because of how hl works lol
// i whould make a issue on lime's issue tracker but im too lazy
class ImageUtil
{
	public static function resize(image:Image, newWidth:Int, newHeight:Int):Void
	{
		var buffer = image.buffer;
		if (buffer.width == newWidth && buffer.height == newHeight)
			return;
		var newBuffer = new ImageBuffer(new UInt8Array(newWidth * newHeight * 4), newWidth, newHeight);

		var imageWidth = image.width;
		var imageHeight = image.height;

		var data = image.data;
		var newData = newBuffer.data;
		var sourceIndex:Int,
			sourceIndexX:Int,
			sourceIndexY:Int,
			sourceIndexXY:Int,
			index:Int;
		var sourceX:Int, sourceY:Int;
		var u:Float,
			v:Float,
			uRatio:Float,
			vRatio:Float,
			uOpposite:Float,
			vOpposite:Float;

		for (y in 0...newHeight)
		{
			for (x in 0...newWidth)
			{
				// TODO: Handle more color formats

				u = ((x + 0.5) / newWidth) * imageWidth - 0.5;
				v = ((y + 0.5) / newHeight) * imageHeight - 0.5;

				sourceX = Std.int(u);
				sourceY = Std.int(v);

				sourceIndex = (sourceY * imageWidth + sourceX) * 4;
				sourceIndexX = (sourceX < imageWidth - 1) ? sourceIndex + 4 : sourceIndex;
				sourceIndexY = (sourceY < imageHeight - 1) ? sourceIndex + (imageWidth * 4) : sourceIndex;
				sourceIndexXY = (sourceIndexX != sourceIndex) ? sourceIndexY + 4 : sourceIndexY;

				index = (y * newWidth + x) * 4;

				uRatio = u - sourceX;
				vRatio = v - sourceY;
				uOpposite = 1 - uRatio;
				vOpposite = 1 - vRatio;

				newData[index] = Std.int((data[sourceIndex] * uOpposite + data[sourceIndexX] * uRatio) * vOpposite
					+ (data[sourceIndexY] * uOpposite + data[sourceIndexXY] * uRatio) * vRatio);
				newData[index + 1] = Std.int((data[sourceIndex + 1] * uOpposite + data[sourceIndexX + 1] * uRatio) * vOpposite
					+ (data[sourceIndexY + 1] * uOpposite + data[sourceIndexXY + 1] * uRatio) * vRatio);
				newData[index + 2] = Std.int((data[sourceIndex + 2] * uOpposite + data[sourceIndexX + 2] * uRatio) * vOpposite
					+ (data[sourceIndexY + 2] * uOpposite + data[sourceIndexXY + 2] * uRatio) * vRatio);

				// Maybe it would be better to not weigh colors with an alpha of zero, but the below should help prevent black fringes caused by transparent pixels made visible

				if (data[sourceIndexX + 3] == 0 || data[sourceIndexY + 3] == 0 || data[sourceIndexXY + 3] == 0)
				{
					newData[index + 3] = 0;
				}
				else
				{
					newData[index + 3] = data[sourceIndex + 3];
				}
			}
		}

		buffer.data = newBuffer.data;
		buffer.width = newWidth;
		buffer.height = newHeight;

		#if js
		buffer.__srcImage = null;
		buffer.__srcImageData = null;
		buffer.__srcCanvas = null;
		buffer.__srcContext = null;
		#end

		image.dirty = true;
		image.version++;
	}
}
