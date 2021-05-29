Shader "Custom/GetNoise"
{
    Properties
    {
        _MainTex ("Base (RGB)", 2D) = "white" {}
    }
    SubShader
    {
        Cull Off 
        ZWrite Off 
        ZTest Always
        Pass { // some shaders require multiple passes
            CGPROGRAM // here begins the part in Unity's Cg
            #pragma vertex vert
            #pragma fragment frag 

            #include "UnityCG.cginc"
            #include "Random.cginc"

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

            sampler2D _MainTex;
            float _Brightness;

            half4 _Tint;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);    
                o.uv = v.uv;                      
                return o;
            }

            float easeIn(float interpolator){
                return interpolator * interpolator;
            }

            float easeOut(float interpolator){
                return 1 - easeIn(1 - interpolator);
            }

            float easeInOut(float interpolator){
                float easeInValue = easeIn(interpolator);
                float easeOutValue = easeOut(interpolator);
                return lerp(easeInValue, easeOutValue, interpolator);
            }
            
            float perlinNoise(float2 value){
                //generate random directions
                float2 lowerLeftDirection = rand2dTo2d(float2(floor(value.x), floor(value.y))) * 2 - 1;
                float2 lowerRightDirection = rand2dTo2d(float2(ceil(value.x), floor(value.y))) * 2 - 1;
                float2 upperLeftDirection = rand2dTo2d(float2(floor(value.x), ceil(value.y))) * 2 - 1;
                float2 upperRightDirection = rand2dTo2d(float2(ceil(value.x), ceil(value.y))) * 2 - 1;

                float2 fraction = frac(value);

                //get values of cells based on fraction and cell directions
                float lowerLeftFunctionValue = dot(lowerLeftDirection, fraction - float2(0, 0));
                float lowerRightFunctionValue = dot(lowerRightDirection, fraction - float2(1, 0));
                float upperLeftFunctionValue = dot(upperLeftDirection, fraction - float2(0, 1));
                float upperRightFunctionValue = dot(upperRightDirection, fraction - float2(1, 1));

                float interpolatorX = easeInOut(fraction.x);
                float interpolatorY = easeInOut(fraction.y);

                //interpolate between values
                float lowerCells = lerp(lowerLeftFunctionValue, lowerRightFunctionValue, interpolatorX);
                float upperCells = lerp(upperLeftFunctionValue, upperRightFunctionValue, interpolatorX);

                float noise = lerp(lowerCells, upperCells, interpolatorY);
                return noise;
            }
            //reverse glossines map
            fixed4 frag (v2f i) : SV_Target // fragment shader
            {
                float2 value = i.uv / 0.1;
                // fixed4 col = tex2D(_MainTex, i.uv);
                float noise = perlinNoise(value) + 0.5;
                return noise;
            }

            ENDCG // here ends the part in Cg 
        }
    }
}