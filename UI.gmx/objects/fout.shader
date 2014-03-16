// Varyings
static float2 _v_vTexcoord = {0, 0};

static float4 gl_Color[1] =
{
    float4(0, 0, 0, 0)
};


uniform float _blurSize : register(c3);
uniform float _gm_AlphaRefValue : register(c4);
uniform bool _gm_AlphaTestEnabled : register(c5);
uniform sampler2D _gm_BaseTexture : register(s0);
uniform float4 _gm_FogColour : register(c6);
uniform bool _gm_PS_FogEnabled : register(c7);
uniform float _sigma : register(c8);

float4 gl_texture2D(sampler2D s, float2 t)
{
    return tex2D(s, t);
}

#define GL_USES_FRAG_COLOR
;
;
;
;
;
void _DoAlphaTest(in float4 _SrcColour)
{
{
if(_gm_AlphaTestEnabled)
{
{
if((_SrcColour.w <= _gm_AlphaRefValue))
{
{
discard;
;
}
;
}
;
}
;
}
;
}
}
;
void _DoFog(inout float4 _SrcColour, in float _fogval)
{
{
if(_gm_PS_FogEnabled)
{
{
(_SrcColour = lerp(_SrcColour, _gm_FogColour, clamp(_fogval, 0.0, 1.0)));
}
;
}
;
}
}
;
;
;
;
;
static float _pii = 3.1415927;
static float _numBlurPixelsPerSide = 3.0;
static float2 _blurMultiplyVec = float2(1.0, 0.0);
void gl_main()
{
{
float3 _incrementalGaussian = {0, 0, 0};
(_incrementalGaussian.x = (1.0 / (sqrt((2.0 * _pii)) * _sigma)));
(_incrementalGaussian.y = exp((-0.5 / (_sigma * _sigma))));
(_incrementalGaussian.z = (_incrementalGaussian.y * _incrementalGaussian.y));
float4 _avgValue = float4(0.0, 0.0, 0.0, 0.0);
float _coefficientSum = 0.0;
(_avgValue += (gl_texture2D(_gm_BaseTexture, _v_vTexcoord.xy) * _incrementalGaussian.x));
(_coefficientSum += _incrementalGaussian.x);
(_incrementalGaussian.xy *= _incrementalGaussian.yz);
{for(float _i = 1.0; (_i <= _numBlurPixelsPerSide); (_i++))
{
{
(_avgValue += (gl_texture2D(_gm_BaseTexture, (_v_vTexcoord.xy - ((_i * _blurSize) * _blurMultiplyVec))) * _incrementalGaussian.x));
(_avgValue += (gl_texture2D(_gm_BaseTexture, (_v_vTexcoord.xy + ((_i * _blurSize) * _blurMultiplyVec))) * _incrementalGaussian.x));
(_coefficientSum += (2.0 * _incrementalGaussian.x));
(_incrementalGaussian.xy *= _incrementalGaussian.yz);
}
;}
}
;
(gl_Color[0] = (_avgValue / _coefficientSum));
}
}
;
struct PS_INPUT
{
    float2 v0 : TEXCOORD0;
};

struct PS_OUTPUT
{
    float4 gl_Color0 : COLOR0;
};

PS_OUTPUT main(PS_INPUT input)
{
    _v_vTexcoord = input.v0.xy;

    gl_main();

    PS_OUTPUT output;
    output.gl_Color0 = gl_Color[0];

    return output;
}
