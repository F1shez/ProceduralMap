Shader "Custom/GenerateTextureMap"
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
            
            //colorize map
            fixed4 frag (v2f i) : SV_Target // fragment shader
            {
                fixed4 col = tex2D(_MainTex, i.uv);
                if(col.r > 0.5)
                {
                    col.r = 1;
                    col.g = 1;
                    col.b = 1;
                }
                else
                {
                    col.r = 0;
                    col.g = 0;
                    col.b = 0;
                }
                return col;
            }

            ENDCG // here ends the part in Cg 
        }
    }
}