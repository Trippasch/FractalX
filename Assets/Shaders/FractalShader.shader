Shader "Explore/FractalShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Area("Area", vector) = (0, 0, 4, 4)
        _MaxIter("Iterations", range(1, 1000)) = 255
        _Angle("Angle", range(-3.1415, 3.1415)) = 0
        _Color("Color", range(0, 1)) = 0
        _ColorRepeat("ColorRepeat", float) = 0
        _ColorSpeed("ColorSpeed", float) = 0
        _Symmetry("Symmetry", range(0, 1)) = 0
        _Symmetryx4("Symmetryx4", range(0, 1)) = 0
        _Symmetryx8("Symmetryx8", range(0, 1)) = 0
        _LeafsBoolean("LeafsBoolean", range(0, 1)) = 0
        _JuliaBoolean("JuliaBoolean", range(0, 1)) = 0
        _LinearBoolean("LinearBoolean", range(0, 1)) = 0
        _DoubleBoolean("DoubleBoolean", range(0, 1)) = 0
        _EscapeRadius("EscapeRadius", float) = 2
        _RotationSpeed("RotationSpeed", float) = 0
        _JuliaSeedX("JuliaSeedX", float) = -0.79
        _JuliaSeedY("JuliaSeedY", float) = 0.15
        _DoublePwr("DoublePower", range(0, 1)) = 1
        _ThirdPwr("ThirdPower", range(0, 1)) = 0
        _FourthPwr("FourthPower", range(0, 1)) = 0
        _FifthPwr("FifthPower", range(0, 1)) = 0
        _SixthPwr("SixthPower", range(0, 1)) = 0
    }
    SubShader
    {
        // No culling or depth
        Cull Off ZWrite Off ZTest Always

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            float4 _Area;
            float _Angle, _Color, _ColorRepeat, _ColorSpeed;
            float _Symmetry, _Symmetryx4, _Symmetryx8;
            float _MaxIter, _LinearBoolean, _DoubleBoolean, _LeafsBoolean, _JuliaBoolean;
            float _RotationSpeed, _EscapeRadius, _JuliaSeedX, _JuliaSeedY;
            float _DoublePwr, _ThirdPwr, _FourthPwr, _FifthPwr, _SixthPwr;
            sampler2D _MainTex;

            float2 rot(float2 p, float2 pivot, float a)
            {
                float s = sin(a);
                float c = cos(a);

                p -= pivot;
                p = float2(p.x * c - p.y * s, p.x * s + p.y * c);
                p += pivot;

                return p;
            }

            fixed4 frag(v2f i) : SV_Target
            {

                float2 uv = i.uv - .5;

                if (_Symmetryx4 == 1) // x4 symmetry
                {
                    uv = abs(uv); 
                }
                if (_Symmetryx8 == 1) // x8 symmetry with slight rotation
                {
                    uv = abs(uv);
                    uv = rot(uv, 0, .25 * 3.1415); 
                    uv = abs(uv);
                }

                uv = lerp(i.uv - .5, uv, _Symmetry);

                float2 c = _Area.xy + uv * _Area.zw;
                
                c = rot(c, _Area.xy, _Angle);

                float2 j = float2(_JuliaSeedX, _JuliaSeedY);

                float r = _EscapeRadius; // escape radius default=20 (leafs radius)
                float r2 = r * r;
                float k = 0;
                float2 z, zPrevious;

                z = c;

                float iter;
                for (iter = 0; iter < _MaxIter; iter++) 
                {
                    zPrevious = rot(z, 0, _Time.y * _RotationSpeed); // control the leafs rotation

                    if (_JuliaBoolean == 1)
                    {                        
                        if (_ThirdPwr == 1)
                            z = float2(z.x * z.x * z.x - z.x * z.y * z.y - 2 * z.x * z.y * z.y, 2 * z.x * z.x * z.y + z.x * z.x * z.y - z.y * z.y * z.y) + j; // (f(z) = z^3 + juliaseed)
                        else if (_FourthPwr == 1)
                            z = float2(z.x * z.x * z.x * z.x - 6 * z.x * z.x * z.y * z.y + z.y * z.y * z.y * z.y, 4 * z.x * z.x * z.x * z.y - 4 * z.x * z.y * z.y * z.y) + j; // (f(z) = z^4 + juliaseed)
                        else if (_FifthPwr == 1)
                            z = float2(z.x * z.x * z.x * z.x * z.x - 10 * z.x * z.x * z.x * z.y * z.y + 5 * z.x * z.y * z.y * z.y * z.y, 5 * z.x * z.x * z.x * z.x * z.y - 10 * z.x * z.x * z.y * z.y * z.y + z.y * z.y * z.y * z.y * z.y) + j; // (f(z) = z^5 + juliaseed)
                        else if (_SixthPwr == 1)
                            z = float2(z.x * z.x * z.x * z.x * z.x * z.x - 15 * z.x * z.x * z.x * z.x * z.y * z.y + 15 * z.x * z.x * z.y * z.y * z.y * z.y - z.y * z.y * z.y * z.y * z.y * z.y, 6 * z.x * z.x * z.x * z.x * z.x * z.y - 20 * z.x * z.x * z.x * z.y * z.y * z.y + 6 * z.x * z.y * z.y * z.y * z.y * z.y) + j; // (f(z) = z^6 + juliaseed)
                        else if (_DoublePwr == 1)
                            z = float2(z.x * z.x - z.y * z.y, 2 * z.x * z.y) + j; // julia equation (f(z) = z^2 + juliaseed)
                    }
                    else
                    {
                        if (_ThirdPwr == 1)
                            z = float2(z.x * z.x * z.x - z.x * z.y * z.y - 2 * z.x * z.y * z.y, 2 * z.x * z.x * z.y + z.x * z.x * z.y - z.y * z.y * z.y) + c; // (f(z) = z^3 + c)
                        else if (_FourthPwr == 1)
                            z = float2(z.x * z.x * z.x * z.x - 6 * z.x * z.x * z.y * z.y + z.y * z.y * z.y * z.y, 4 * z.x * z.x * z.x * z.y - 4 * z.x * z.y * z.y * z.y) + c; // (f(z) = z^4 + c)
                        else if (_FifthPwr == 1)
                            z = float2(z.x * z.x * z.x * z.x * z.x - 10 * z.x * z.x * z.x * z.y * z.y + 5 * z.x * z.y * z.y * z.y * z.y, 5 * z.x * z.x * z.x * z.x * z.y - 10 * z.x * z.x * z.y * z.y * z.y + z.y * z.y * z.y * z.y * z.y) + c; // (f(z) = z^5 + c)
                        else if (_SixthPwr == 1)
                            z = float2(z.x * z.x * z.x * z.x * z.x * z.x - 15 * z.x * z.x * z.x * z.x * z.y * z.y + 15 * z.x * z.x * z.y * z.y * z.y * z.y - z.y * z.y * z.y * z.y * z.y * z.y, 6 * z.x * z.x * z.x * z.x * z.x * z.y - 20 * z.x * z.x * z.x * z.y * z.y * z.y + 6 * z.x * z.y * z.y * z.y * z.y * z.y) + c; // (f(z) = z^6 + c)
                        else if (_DoublePwr == 1)
                            z = float2(z.x * z.x - z.y * z.y, 2 * z.x * z.y) + c; // mandelbrot equation (f(z) = z^2 + c)
                    }

                    k++;
                    if (_LeafsBoolean == 1)
                    {
                        if (dot(z, zPrevious) > r2) break; // leafy vibe
                    }
                    else
                    {
                        if (length(z) > r) break; // normal
                    }
                }
                if (iter > _MaxIter - 1) return 0;

                float dist = length(z); // distance from origin
                float interP;

                if (_LinearBoolean == 1)
                {
                    interP = (dist - r) / (r2 - r); // linear interpolation
                }
                if (_DoubleBoolean == 1)
                {
                    interP = log2(log(dist) / log(r)); // double exponential interpolation
                }

                float smooth = sqrt(iter / _MaxIter);
                float4 col = sin(float4(.3, .45, .65, 1) * smooth * 1000) * .5 + .5; // procedural coloring
                col = tex2D(_MainTex, float2((smooth * _ColorRepeat) + (_Time.y * _ColorSpeed), _Color)); // texture sampling

                float angle = atan2(z.x, z.y); // -pi and pi
                if (_LinearBoolean == 1 || _DoubleBoolean == 1)
                {
                    col *= smoothstep(3, 0, interP); // interpolate
                }

                col *= 1 + sin(angle * 2 + _Time.y * 4 *_RotationSpeed) * .2; // shades and shade speed
                
                return col;

                ///*---TechniColor---*/
                //if (k == _MaxIter)
                //    return 0;     
                //else
                //    return float4(sin(k / 4), sin(k / 5), sin(k / 7), 1) / 4 + 0.75;
                ///*----------------*/

                ///*-----No Color-----*/
                //return iter / _MaxIter;
                ///*------------------*/
            }
            ENDCG
        }
    }
}
