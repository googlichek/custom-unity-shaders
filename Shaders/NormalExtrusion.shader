Shader "Custom/NormalExtrusion"
{
	// Shader with extrusion by vector normal.
	Properties
	{
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_ExtrusionTex ("Extrusion Texture", 2D) = "white" {}
		_Amount("Extrusion Amount", Range(-1, 1)) = 0
	}
	SubShader
	{
		Tags
		{
			"RenderType"="Opaque"
		}
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Lambert vertex:vert
		#pragma target 3.0

		sampler2D _MainTex;
		sampler2D _ExtrusionTex;
		fixed4 _Color;
		float _Amount;

		struct Input
		{
			float2 uv_MainTex;
		};

		void surf (Input IN, inout SurfaceOutput o)
		{
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}

		void vert(inout appdata_full v)
		{
			float4 tex = tex2Dlod(_ExtrusionTex, float4(v.texcoord.xy, 0, 0));
			float extrusion = tex.r * 2 - 1;
			v.vertex.xyz += v.normal * _Amount * extrusion;
		}

		ENDCG
	}
	FallBack "Diffuse"
}
