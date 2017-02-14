Shader "Custom/PhongSpecular"
{
	// Viewpoint-dependent specular shader.
	Properties
	{
		_MainTint ("Diffusive Tint", Color) = (1,1,1,1)
		_SpecularColor ("Specular Color", Color) = (1,1,1,1)
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_SpecPower ("Specular Power", Range(0, 30)) = 1
	}
	SubShader
	{
		Tags
		{
			"RenderType"="Opaque"
		}
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Phong

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

		fixed4 LightingPhong(SurfaceOutput s, fixed3 lightDir, half3 viewDir, fixed atten)
		{
			// Reflection
			float NdotL = dot(s.Normal, lightDir);
			float3 reflectionVector = normalize(2.0 * s.Normal * NdotL - lightDir);

			// Specular
			float spec = pow(max(0, dot(reflectionVector, viewDir)), _SpecPower);
			float3 finalSpec = spec * _SpecularColor.rgb;

			// Final effect
			fixed4 c;
			c.rgb = (s.Albedo * _LightColor0.rgb * max(0, NdotL) * atten) + (finalSpec * _LightColor0.rgb);
			c.a = s.Alpha;

			return c;

		}
		ENDCG
	}
	FallBack "Diffuse"
}
