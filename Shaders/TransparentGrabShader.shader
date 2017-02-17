Shader "Custom/TransparentGrabShader"
{
	// Basic glass-like grab pass shader.
	Properties
	{
		_Tint("Grab Texture Tint", Color) = (1, 1, 1, 1)
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

		GrabPass{}

		Pass
		{
			CGPROGRAM
			
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			sampler2D _GrabTexture;
			float4 _Tint;

			struct vertInput
			{
				float4 vertex : POSITION;
			};

			struct vertOutput
			{
				float4 vertex : POSITION;
				float4 uvgrab : TEXCOORD1;
			};

			// Vertex function 
			vertOutput vert(vertInput v)
			{
				vertOutput o;
				o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);
				o.uvgrab = ComputeGrabScreenPos(o.vertex);
				return o;
			}

			// Fragment function
			half4 frag(vertOutput i) : COLOR
			{
				fixed4 col = tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(i.uvgrab));
				return col + _Tint;
			}

			ENDCG
		}
	}
}