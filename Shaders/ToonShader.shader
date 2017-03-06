Shader "Custom/ToonShader"
{
	// Simple cel shader.
	// Written in Unity 5.5.1
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}
		_CelShadingLevels("Cel Shading Level", Range(1.5, 25.5)) = 2.5

		// For implementation with the ramp map.
		// _RampTex("Ramp", 2D) = "white" {}
	}
	SubShader
	{
		Tags
		{
			"RenderType" = "Opaque"
		}
		CGPROGRAM
		#pragma surface surf Toon

		struct Input
		{
			float2 uv_MainTex;
		};

		sampler2D _MainTex;
		sampler2D _RampTex;
		int _CelShadingLevels;

		void surf(Input IN, inout SurfaceOutput o)
		{
			o.Albedo = tex2D(_MainTex, IN.uv_MainTex).rgb;
		}

		half4 LightingToon(SurfaceOutput s, half3 lightDir, half atten)
		{
			half NdotL = dot(s.Normal, lightDir);

			// For implementation with the ramp map.
			// NdotL = tex2D(_RampTex, fixed2(NdotL, 0.5));

			//Snap the light intencity.
			half cel = floor(NdotL * _CelShadingLevels) / (_CelShadingLevels - 0.5);

			fixed4 c;

			// For implementation with the ramp map.
			// c.rgb = s.Albedo * _LightColor0.rgb * NdotL * atten;

			c.rgb = s.Albedo * _LightColor0.rgb * cel * atten;
			c.a = s.Alpha;

			return c;
		}

		ENDCG
	}
		Fallback "Diffuse"
}
