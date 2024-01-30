package;
import flixel.system.FlxAssets.FlxShader;

class BloomShader extends FlxShader {
    @:glFragmentSource('
	    #pragma header

	    uniform float uSize;
	    uniform float uAlpha;
	
	    void main(void) {
		    vec2 uv = openfl_TextureCoordv.xy;
		    vec4 blur = vec4(0.0);
		    float a_size = uSize * 0.05 * openfl_TextureCoordv.y;
	    	float halfKernelSize = a_size * 0.5;
		    float normalizationFactor = 1.0 / (1600.0 * a_size);
		
		    for (float i = -halfKernelSize; i < halfKernelSize; i += 0.001) {
		    	blur.rgb += flixel_texture2D(bitmap, uv + vec2(0.0, i)).rgb * normalizationFactor;
	    	}
		
	    	vec4 color = flixel_texture2D(bitmap, uv);
		    gl_FragColor = color + uAlpha * (color * (color + blur * 1.5 - 1.0));
	}
	
	')

    public function new() {
        super();
		uSize.value = [0];
		uAlpha.value = [1];
    }

    @:isVar
    public var size(get,set):Float;

    function get_size()
		return uSize.value[0];

	function set_size(val:Float)
		return uSize.value[0] = val;

	@:isVar
    public var shaderAlpha(get,set):Float;

    function get_shaderAlpha()
		return uAlpha.value[0];

	function set_shaderAlpha(val:Float)
		return uAlpha.value[0] = val;
}