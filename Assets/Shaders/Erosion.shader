Shader "Custom/GenerateErosion"
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
            
            //erosion
            fixed4 frag (v2f i) : SV_Target // fragment shader
            {
                fixed4 col = tex2D(_MainTex, i.uv);
                col.r = col.r - 0.1;
                col.g = col.g - 0.1;
                col.b = col.b - 0.1;

                return col;
            }

            ENDCG // here ends the part in Cg 
        }
    }
}