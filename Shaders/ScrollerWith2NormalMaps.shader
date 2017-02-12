Shader "Custom/ScrollerWith2NormalMaps"
{
	Properties{
		_MainTint("Diffusive Tint", Color) = (1, 1, 1, 1)
		_MainTex("Base (RGB)", 2D) = "white" {}
		_NormalTex("Normal Map", 2D) = "bump" {}
		_SecondNormalTex("Second Normal Map", 2D) = "bump" {}
		_ScrollXSpeed("X Scroll Speed", Range(0, 10)) = 2
		_ScrollYSpeed("Y Scroll Speed", Range(0, 10)) = 2
	}

	SubShader{
		Tags{ "RenderType" = "Opaque" }
		LOD 200

		CGPROGRAM
		#pragma surface surf Standard fullforwardshadows

		#pragma target 3.0

		sampler2D _MainTex;
		sampler2D _NormalTex;
		sampler2D _SecondNormalTex;
		fixed _ScrollXSpeed;
		fixed _ScrollYSpeed;
		fixed4 _MainTint;

		struct Input{
			float2 uv_MainTex;
			float2 uv_NormalTex;
			float2 uv_SecondNormalTex;
		};

		void surf(Input IN, inout SurfaceOutputStandard o){
			fixed2 scrolledUV = IN.uv_MainTex;
			fixed2 scrolledNormalTexUV = IN.uv_NormalTex;
			fixed2 scrolledSecondNormalTexUV = IN.uv_SecondNormalTex;

			fixed xScrollValue = _ScrollXSpeed * _Time;
			fixed yScrollValue = _ScrollYSpeed * _Time;

			scrolledUV += fixed2(xScrollValue, yScrollValue);
			scrolledNormalTexUV += fixed2(xScrollValue / 2, yScrollValue / 2);
			scrolledSecondNormalTexUV += fixed2(xScrollValue / 3, yScrollValue / 3);

			half4 c = tex2D(_MainTex, scrolledUV);
			float3 n =
				lerp(
					UnpackNormal(tex2D(_NormalTex, scrolledNormalTexUV)),
					UnpackNormal(tex2D(_SecondNormalTex, scrolledSecondNormalTexUV)),
					0.5);

			float3 normalTex = n;

			o.Albedo = c.rgb * _MainTint;
			o.Alpha = c.a;
			o.Normal = normalTex.rgb;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
