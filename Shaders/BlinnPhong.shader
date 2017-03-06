Shader "Custom/BlinnPhong"
{
	// Blinn phong specular shader.
	// Written in Unity 5.5.1
	Properties
	{
		_MainTint ("Diffusive Tint", Color) = (1,1,1,1)
		_SpecularColor ("Specular Color", Color) = (1,1,1,1)
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_SpecPower ("Specular Power", Range(0.1, 60)) = 3
	}
	SubShader
	{
		Tags
		{
			"RenderType"="Opaque"
		}
		LOD 200
		
		CGPROGRAM
		#pragma surface surf CustomBlinnPhong

		#pragma target 3.0

		sampler2D _MainTex;
		fixed4 _MainTint;
		fixed4 _SpecularColor;
		float _SpecPower;

		struct Input
		{
			float2 uv_MainTex;
		};

		void surf (Input IN, inout SurfaceOutput o)
		{
			o.Albedo = tex2D(_MainTex, IN.uv_MainTex).rgb * _MainTint;
		}

		fixed4 LightingCustomBlinnPhong(SurfaceOutput s, fixed3 lightDir, half3 viewDir, fixed atten)
		{
			// Reflection
			float NdotL = max(0, dot(s.Normal, lightDir));
			float3 halfVector = normalize(lightDir + viewDir);
			float NdotH = max(0, dot(s.Normal, halfVector));
			
			// Specular
			float spec = pow(NdotH, _SpecPower) * _SpecularColor;

			// Final effect
			fixed4 c;
			c.rgb = (s.Albedo * _LightColor0.rgb * NdotL) + (spec * _SpecularColor.rgb * _LightColor0.rgb) * atten;
			c.a = s.Alpha;

			return c;

		}
		ENDCG
	}
	FallBack "Diffuse"
}
