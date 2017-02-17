Shader "Custom/Glass"
{
	// Glass shader with distortion.
	Properties
	{
		_MainTex("Base (RGB) Trans (A)", 2D) = "white" {}
		_Tint("Colour", Color) = (1, 1, 1, 1)
		_BumpMap("Noise text", 2D) = "bump" {}
		_Magnitude("Magnitude", Range(-10, 10)) = 0
	}

	SubShader
	{
		Tags
		{
			"Queue" = "Transparent"
			"IgnoreProjector" = "True"
			"RenderType" = "Opaque"
		}

		ZWrite On
		Lighting Off
		Cull Off
		Blend One Zero
		Fog{ Mode Off }

		GrabPass{  }

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			sampler2D _GrabTexture;
			sampler2D _MainTex;
			fixed4 _Tint;
			sampler2D _BumpMap;
			float  _Magnitude;

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
				float4 uvgrab : TEXCOORD1;
			};

			// Vertex function 
			vertOutput vert(vertInput v)
			{
				vertOutput o;
				o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);
				o.color = v.color;

				o.texcoord = v.texcoord;

				o.uvgrab = ComputeGrabScreenPos(o.vertex);
				return o;
			}

			// Fragment function
			half4 frag(vertOutput i) : COLOR
			{
				half4 mainColour = tex2D(_MainTex, i.texcoord);

				half4 bump = tex2D(_BumpMap, i.texcoord);
				half2 distortion = UnpackNormal(bump).rg;

				i.uvgrab.xy += distortion * _Magnitude;

				fixed4 col = tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(i.uvgrab));
				return col * mainColour * _Tint;
			}
			ENDCG
		}
	}
}
