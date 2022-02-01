### A Pluto.jl notebook ###
# v0.15.0

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : missing
        el
    end
end

# ╔═╡ 09e68c99-1ce1-4d4d-b84e-451055850af2
using HypertextLiteral

# ╔═╡ e5023339-a214-4926-89a5-04a86260a6b2
using PlutoUI

# ╔═╡ d669b49d-afdd-4a43-8319-2c52dd2457c4
md"""
Loading the cesium container is quite straightforward by including the relevant modules and css and calling the new Viewer from the script.

One has to remember to specify the fullscreenElement configuration option to the cesium div as explained in [this](https://github.com/articodeltd/angular-cesium/issues/158#issuecomment-591238766) github issue.
Full screen is otherwise broken as the fullscreenElement defaults to the `document.body` element
"""

# ╔═╡ 495aa3c8-ef8d-4ccf-929c-af13c1f32b5a
@htl """
<style>
.cesiumContainer {
	height: 500px;
}
</style>
"""

# ╔═╡ 1381ce72-1b91-44b3-9222-d7334104789d
md"""
Dynamic update of cesium properties can be done using the CallbackProperty function when defining the property.
An example can be found [here](https://programmersought.com/article/85746395916/)
"""

# ╔═╡ 67d3a39b-9966-4bfe-8adf-c01a7c39573d
@bind a Slider(0:20)

# ╔═╡ a9488275-eb46-4930-828a-d8d5c1c8242c
	@htl """
  <!-- Include the CesiumJS JavaScript and CSS files -->
  <script src="https://cesium.com/downloads/cesiumjs/releases/1.83/Build/Cesium/Cesium.js"></script>
  <link href="https://cesium.com/downloads/cesiumjs/releases/1.83/Build/Cesium/Widgets/widgets.css" rel="stylesheet">
  <script id="cesium">
    // Your access token can be found at: https://cesium.com/ion/tokens.
    // Replace `your_access_token` with your Cesium ion access token.
	const DIV = this ? this : document.createElement('div')
	
	if (this == undefined) {
		DIV.classList.toggle('cesiumContainer',true)

		Cesium.Ion.defaultAccessToken = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiJlZTRmNGM0ZC0wNzNmLTRjNTEtYmE2Ny05ODQ5MzgwZjRjZTIiLCJpZCI6NjAzMjEsImlhdCI6MTYyNDk3Nzk2OH0.zJU6nqKRttcZ2le5y8rl8cTUZAEw0EHtIKlmlpq7BGg';

		 let viewer = new Cesium.Viewer(DIV,{fullscreenElement: DIV});
		let position = 0

		const setPosition = newVal => {position = newVal}
	
var lon = -120;
var lat = 40;

function getPosition() {
lon += 0.05;
return Cesium.Cartesian3.fromDegrees(lon, lat);
}

viewer.entities.add({
position: new Cesium.CallbackProperty(getPosition, false),
ellipse : {
semiMinorAxis : 300000.0,
semiMajorAxis : 300000.0,
material : Cesium.Color.BLUE.withAlpha(0.8)
}
});
		 DIV.viewer = viewer;
		DIV.setPosition = setPosition;
}
	DIV.setPosition($a)
	return DIV
  </script>
 </div>
"""

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
HypertextLiteral = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
HypertextLiteral = "~0.8.0"
PlutoUI = "~0.7.9"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.7.0-beta2"
manifest_format = "2.0"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.HypertextLiteral]]
git-tree-sha1 = "1e3ccdc7a6f7b577623028e0095479f4727d8ec1"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.8.0"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "81690084b6198a2e1da36fcfda16eeca9f9f24e4"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.1"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.Parsers]]
deps = ["Dates"]
git-tree-sha1 = "c8abc88faa3f7a3950832ac5d6e690881590d6dc"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "1.1.0"

[[deps.PlutoUI]]
deps = ["Base64", "Dates", "InteractiveUtils", "JSON", "Logging", "Markdown", "Random", "Reexport", "Suppressor"]
git-tree-sha1 = "44e225d5837e2a2345e69a1d1e01ac2443ff9fcb"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.9"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.Random]]
deps = ["Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.Reexport]]
git-tree-sha1 = "5f6c21241f0f655da3952fd60aa18477cf96c220"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.1.0"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.Suppressor]]
git-tree-sha1 = "a819d77f31f83e5792a76081eee1ea6342ab8787"
uuid = "fd094767-a336-5f1f-9728-57cf17d0bbfb"
version = "0.2.0"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"
"""

# ╔═╡ Cell order:
# ╠═09e68c99-1ce1-4d4d-b84e-451055850af2
# ╠═e5023339-a214-4926-89a5-04a86260a6b2
# ╟─d669b49d-afdd-4a43-8319-2c52dd2457c4
# ╠═495aa3c8-ef8d-4ccf-929c-af13c1f32b5a
# ╟─1381ce72-1b91-44b3-9222-d7334104789d
# ╠═67d3a39b-9966-4bfe-8adf-c01a7c39573d
# ╠═a9488275-eb46-4930-828a-d8d5c1c8242c
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
