package;
import flixel.system.FlxAssets.FlxShader;

class BarrelEffect {
	public var shader:BarrelDistortionShader = new BarrelDistortionShader();

	@:isVar
	public var barrelDistortion1(get, set):Float = 0;
	@:isVar
	public var barrelDistortion2(get, set):Float = 0;

	function get_barrelDistortion1()
		return shader.dis1.value[0];

	function set_barrelDistortion1(val:Float)
		return shader.dis1.value[0] = val;

	function get_barrelDistortion2()
		return shader.dis2.value[0];

	function set_barrelDistortion2(val:Float)
		return shader.dis2.value[0] = val;
    
	public function new() {
		shader.dis1.value[0]  = 0;
		shader.dis2.value[0] = 0;
	}
}

class BarrelDistortionShader extends FlxShader {
    @:glFragmentSource('
	    #pragma header
	    const float PI_F = 3.141592653589793;
	    uniform float dis1;
	    uniform float dis2;
	
	    vec2 brownConradyDistortion(vec2 uv) {
	    	float r2 = dot(uv, uv);
	    	return uv * (1.0 + dis1 * r2 + dis2 * r2 * r2);
	    }
	
	    void main() {
	    	vec2 uv = openfl_TextureCoordv - 0.5;
	    	uv = brownConradyDistortion(uv) + 0.5;
	
	      	if(all(greaterThanEqual(uv, vec2(0.0))) && all(lessThanEqual(uv, vec2(1.0)))) {
		    	gl_FragColor = flixel_texture2D(bitmap, uv);
	    	} else {
	    		gl_FragColor = vec4(0.0);
	    	}
	    }
    ')
    public function new() {
        super();
		dis1.value = [0.0];
		dis2.value = [0.0];
    }
}