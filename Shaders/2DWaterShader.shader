Shader "Custom/2SWaterShader" 
{
	// 2D water shader.
	// Written in Unity 5.5.1
	Properties 
	{
		_NoiseTex("Noise text", 2D) = "white" {}
		_Tint ("Shader Tint", Color) = (1, 1, 1, 1)
		_Period ("Period", Range(0, 50)) = 1
		_Magnitude ("Magnitude", Range(-10, 10)) = 0
		_Scale ("Scale", Range(-10, 10)) = 1
	}
	
	SubShader
	{
		Tags
		{
			"Queue"="Transparent"
			"IgnoreProjector"="True"
			"RenderType"="Transparent"
		}

		ZWrite Off
		Lighting Off
		Cull Off
		Blend One Zero
		Fog{ Mode Off }
		LOD 110

		GrabPass { "_GrabTexture" }
		
		Pass 
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			sampler2D _GrabTexture;
			sampler2D _NoiseTex;	
			fixed4 _Tint;
			float  _Period;
			float  _Magnitude;
			float  _Scale;

		

			struct vertInput
			{
				float4 vertex : POSITION;
				float4 color : COLOR;
				float2 texcoord : TEXCOORD0;
			};

			struct vertOutput
			{
				float4 vertex : POSITION;
				fixed4 color : COLOR;
				float2 texcoord : TEXCOORD0;
				float4 worldPos : TEXCOORD1;
				float4 uvgrab : TEXCOORD2;
			};

			// Vertex function 
			vertOutput vert (vertInput v)
			{
				vertOutput o;
				o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);
				o.color = v.color;
				o.texcoord = v.texcoord;

				o.worldPos = mul(unity_ObjectToWorld, v.vertex);
				o.uvgrab = ComputeGrabScreenPos(o.vertex);
				
				return o;
			}

			// Fragment function
			fixed4 frag (vertOutput i) : COLOR
			{
				float sinT = sin(_Time.w / _Period);
				float2 distortion = float2
				(	tex2D(_NoiseTex, i.worldPos.xy / _Scale + float2(sinT, 0) ).r - 0.5,
					tex2D(_NoiseTex, i.worldPos.xy / _Scale + float2(0, sinT) ).r - 0.5
					);

				i.uvgrab.xy += distortion * _Magnitude;

				fixed4 col = tex2Dproj( _GrabTexture, UNITY_PROJ_COORD(i.uvgrab));
				return col * _Tint;
			}
		
			ENDCG
		} 
	}
}
