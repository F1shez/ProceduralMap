Shader "Custom/PerlinNoise3d"
{
    Properties {
        // _MainTex ("Albedo (RGB)", 2D) = "white" {}
		_CellSize ("Cell Size", Range(0, 1)) = 1
        _Tex("InputTex", 2D) = "white" {}
	}
	SubShader {
		Tags{ "RenderType"="Opaque" "Queue"="Geometry"}

		CGPROGRAM

		#pragma surface surf Standard fullforwardshadows
        // #pragma fragment frag

		#pragma target 3.0


		#include "Random.cginc"
        // sampler2D _MainTex;

		float _CellSize;
		float _Jitter;
                 sampler2D   _Tex;


		struct Input {
			float3 worldPos;
		};

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

		float perlinNoise(float3 value){
			float3 fraction = frac(value);

			float interpolatorX = easeInOut(fraction.x);
			float interpolatorY = easeInOut(fraction.y);
			float interpolatorZ = easeInOut(fraction.z);

			float cellNoiseZ[2];
			[unroll]
			for(int z=0;z<=1;z++){
				float cellNoiseY[2];
				[unroll]
				for(int y=0;y<=1;y++){
					float cellNoiseX[2];
					[unroll]
					for(int x=0;x<=1;x++){
						float3 cell = floor(value) + float3(x, y, z);
						float3 cellDirection = rand3dTo3d(cell) * 2 - 1;
						float3 compareVector = fraction - float3(x, y, z);
						cellNoiseX[x] = dot(cellDirection, compareVector);
					}
					cellNoiseY[y] = lerp(cellNoiseX[0], cellNoiseX[1], interpolatorX);
				}
				cellNoiseZ[z] = lerp(cellNoiseY[0], cellNoiseY[1], interpolatorY);
			}
			float noise = lerp(cellNoiseZ[0], cellNoiseZ[1], interpolatorZ);
			return noise;
		}

		void surf (Input i, inout SurfaceOutputStandard o) {
			float3 value = i.worldPos / _CellSize;
			//get noise and adjust it to be ~0-1 range
			float noise = perlinNoise(value) + 0.5;
			o.Albedo = noise;
            // _Tex = o.Albedo * tex2D(_Tex, i.worldPos);
		}
        // struct v2f
        //     {                             
        //         float2 uv : TEXCOORD0;    
        //         float4 vertex : SV_POSITION;
        //     };

        // float4 frag(v2f i) : COLOR
        // {
        //     float3 value = i.uv / _CellSize;
        //     float noise = perlinNoise(value) + 0.5;
        //     return noise * tex2D(_Tex, i.uv);
        // }
        
		ENDCG
	}
	FallBack "Standard"
}
