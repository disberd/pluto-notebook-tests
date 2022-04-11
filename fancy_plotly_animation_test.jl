### A Pluto.jl notebook ###
# v0.18.4

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
end

# ╔═╡ 17f92f1e-b8e9-11ec-2be7-e9b98d93fa8f
begin
	using PlutoPlotly
	using HypertextLiteral
	using PlutoUI
	using Unzip
	using Rotations
	using StaticArrays
end

# ╔═╡ 1960e778-cfc2-4c2f-aafd-b5170663fefa
TableOfContents()

# ╔═╡ d9e12866-0b72-42f7-a8e0-348c9c310753
angs = Ref(0.0)

# ╔═╡ e712e30f-9877-4a2a-b138-bd68c6227ca8
@bind cc Clock()

# ╔═╡ 72b02126-fbbd-4dd9-ae22-83683a2f75c9
ang = let
	cc
	angs[] = mod2pi(angs[]+ π/20)
	angs[]
end;

# ╔═╡ 0b308645-dbe1-4699-b14f-abd6478c0e7a
let
	y,x = sincos(ang)
	p = plot(scatter3d(; x = [x], y = [y], z = [0]), Layout(
		scene = attr(
		xaxis = attr(
			range = [-1.5,1.5]
		),
		yaxis = attr(
			range = [-1.5,1.5]
		),
		),
	))
 	push_script!(p, htl_js("PLOT.setAttribute('id','lol')"))
	p
end

# ╔═╡ b2757e5a-ab4c-4ef1-bb2a-03d3282bb16f
function upangs()
	angs[] = mod2pi(angs[]+ π/20)
	angs[] |> sincos
end

# ╔═╡ f6a12c28-3dd6-47b3-94d1-b2750b4c3805
@bind boda Clock()

# ╔═╡ b1cff3e0-c445-4665-a0d9-d746c3bc605f
let
	boda
	@htl """
<script>
	const PLOT = document.getElementById('lol')
	const data = PLOT.data
	const layout = PLOT.layout
layout.datarevision = Math.random()
	let asd = $(upangs())

	
	data[0].x[0] = asd[1]
	data[0].y[0] = asd[0]
	Plotly.react(PLOT, data, layout)

</script>
"""
end

# ╔═╡ 1403399b-c5da-4805-a7a5-ea92b40080be
let
	y,x = sincos(ang)
	p = plot(scatter3d(; x = [x], y = [y], z = [0]), Layout(
		scene = attr(
		xaxis = attr(
			range = [-1.5,1.5]
		),
		yaxis = attr(
			range = [-1.5,1.5]
		),
		),
	))
 	push_script!(p, "PLOT.setAttribute('id','lol2')")
 	push_script!(p, htl_js(
		"PLOT.addEventListener('mousedown',() => {PLOT.animating = false})
		PLOT.addEventListener('mouseup',() => {PLOT.animating = true})"
	))
	p
end

# ╔═╡ cbd9b1b6-318a-4769-b39f-915f12d1c359
let
	@htl """
	<script id='gesu'>
	let i = 0
	const PLOT = document.getElementById('lol2')
	const layout = PLOT.layout
	let data = PLOT.data

	function update() {
		let animating = PLOT.animating ?? true
		layout.datarevision = Math.random()
		i = i+1
		data[0].y[0] = Math.sin(i * Math.PI/30)
		data[0].x[0] = Math.cos(i * Math.PI/30)
		Plotly.react(PLOT, data, layout).then(() => {
		if (animating && i < 500) {
	
		//	console.log(data[0].x[0])
			requestAnimationFrame(update)
		}
		})
	}

	update()
	/*

	if (i < 50) {
		setTimeout(update, 1000)
	}
	
	setTimeout(update, 1000)

	invalidation.then(() => {
		i = 501
	})
	*/
	</script>
"""
end

# ╔═╡ e6dfff32-17b8-4e43-b551-2c631b79c90f
let
	x = [rand()]
	y = [rand()]
	@htl """
	<script>
	Plotly.animate('lol', {data: [{x: $x, y: $y, z: [0]}]}, 
	{
		frame: {
			duration: 0,
			redraw: true,
		},
	})
	"""
end

# ╔═╡ bb53e654-d614-466a-83de-f2b37aa56688
# ╠═╡ disabled = true
#=╠═╡
let
	y,x = unzip(map(sincos, range(0,2π,61)[1:end-1]))
	@htl """
	<script id='lol'>
	const x = $x
	const y = $y
	let i = -1
	let keepGoing = true

	function update() {
		i = (i+1) % 60
		Plotly.animate('asd', {
			data: [{x: [x[i]], y: [y[i]]}]
			}, {
				transition: {
					duration: 10,
			},
			frame: {
				duration: 10,
				redraw: false
			}
			})
	if (keepGoing) {
		requestAnimationFrame(update)
	}
	}

	
	requestAnimationFrame(update)

	invalidation.then(() => {
		keepGoing = false
	})
	</script>
"""
end
  ╠═╡ =#

# ╔═╡ 8c8bfd4f-8c5f-4837-a4de-b28442ab18ec
aaa = [1:10;]

# ╔═╡ 4c2e2e9c-d2c2-4b2c-a479-bbbfba63295b
lol = 3

# ╔═╡ e065149d-4cfd-4b91-8dcf-65e915e6c44f
let
	lol
	@htl """
<script id='dio'>
const x = $(PlutoRunner.publish_to_js(aaa))
console.log(x[0])
x[0] = Math.random()
console.log(x[0])
</script>
"""
end

# ╔═╡ d9a307cc-d2fa-4b42-af3e-949bcee63cbb
let
	p = plot(scatter3d(;x = [0], y = [0], z=[0], mode = "markers"), Layout(
		# scene = attr(
		# xaxis = attr(
		# 	range = [-1, 2],
		# ),
		# yaxis = attr(
		# 	range = [-1, 2],
		# ),
		# )
	))
	push_script!(p, htl_js("PLOT.setAttribute('id','asdasd')"))
	p
end

# ╔═╡ d8db81b1-742d-44e7-b33f-cd4d205fabf9
let
	@htl """
	<script>
	const PLOT = document.getElementById('asdasd')
	const data = PLOT.data
	const layout = PLOT.layout
	let currentArray = PLOT.ping
	let j = 0
	let isPing = true
	let last_ts = 0
	PLOT.i = 0
	function update(ts) {
		j = j+1
		if (ts == last_ts || j > 550) {return 1}
		PLOT.i = PLOT.i+1
		if (PLOT.i >= currentArray.length) {
			if (isPing) {
				currentArray = PLOT.pong
				isPing = false
			} else {		
				currentArray = PLOT.ping
				isPing = true
			}
			PLOT.i = 0
			requestAnimationFrame(update)
		}
		layout.datarevision = Math.random()
		data[0].x[0] = currentArray[PLOT.i]
		Plotly.react(PLOT,data, layout)
		last_ts = ts
			requestAnimationFrame(update)
	}
	requestAnimationFrame(update)
	// invalidation.then(() => PLOT.i = 5000)
	</script>
	"""
end

# ╔═╡ 411dba4a-ea69-489d-8d1d-0caa1722a90f
let
	@htl """
	<script>
	const PLOT = document.getElementById('asdasd')
	PLOT.ping = $(collect(range(0,1,20)))
	PLOT.pong = $(collect(range(1,0,20)))
	</script>
	"""
end

# ╔═╡ b3690f53-f4f7-4a4b-94b4-391286e40370
md"""
## Test Keybinding hack
"""

# ╔═╡ 235cce11-a1d9-41be-9b29-2731a441b26d
@htl """
<script>
const cell = currentScript.closest('pluto-cell')
cell.addEventListener('keydown', e => {
	if (e.key == "ArrowRight") {
		console.log(e)
		e.preventDefault()
		e.stopImmediatePropagation()
	}
}, true)
</script>
"""

# ╔═╡ b099f375-a860-4c95-a59b-2e8249882edc
md"""
## Circle + Track
"""

# ╔═╡ 653780c7-0b8f-4103-972f-223065cad328
radius_ref = Ref(0.0)

# ╔═╡ 3e35fe43-6ba0-4d31-a5dd-31351c47ff08
@bind radius Slider(.5:.1:1.5)

# ╔═╡ 4d4f3d75-a75d-4bb1-a263-8f1e3ff0e1fc
radius_ref[] = radius

# ╔═╡ 4a5aad49-115f-400d-9b2f-8647b7616a62
let
	y,x = map(range(0; step = π/20, length = 40)) do α
		sincos(α) .* radius
	end |> unzip
	@htl """
	<script>
	const PLOT = document.getElementById('trackanim')
	PLOT.ping = {x: $x, y: $y, z: $(zeros(length(y)))}
	// PLOT.inView = false
	</script>
"""
end

# ╔═╡ 82bf9638-506e-4189-8f9d-f8d918d3da95
let
	y,x = map(range(0; step = π/20, length = 40)) do α
		sincos(α) .* radius_ref[]
	end |> unzip
	p = plot([
		scatter3d(;x = x[1:14], y = y[1:14], z = zeros(length(x)), mode = "lines", line = attr(
			color = "red",
			width = 7,
		),
		showlegend = false,
		),
		scatter3d(;x = [x[15]], y = [y[15]], z=[0], mode = "markers",
		marker = attr(
			color = "red",
		),
		showlegend = false,
		),
	], Layout(
		scene = attr(
			xaxis = attr(
				range = [-1.5, 1.5],
				tickmode = "linear",
				tick0 = -1,
				dtick = 1
			),
			yaxis = attr(
				range = [-1.5, 1.5],
				tickmode = "linear",
				tick0 = -1,
				dtick = 1
			),
			zaxis = attr(
				range = [-1.5, 1.5],
			),
			aspectmode = "cube",
		),
		uirevision = 1,
		template = "none"
	))
	push_script!(p, "
		PLOT.setAttribute('id','trackanim')
		setTimeout(() => {
			let i = 14
			let last_ts = 0
			PLOT.ping = {x: $x, y: $y, z: $(zeros(length(y)))}
			PLOT.update = function (ts) {
				if (!PLOT.inView || ts == last_ts) {return 1}
				i = (i+1 % PLOT.ping.x.length)
				let ii = i % PLOT.ping.x.length
				const data = PLOT.data
				const layout = PLOT.layout
				const trace_range = [...Array(15).keys()].map(n => n - 15 + ii)
				data[0].x = trace_range.map(i => PLOT.ping.x.at(i))
				data[0].y = trace_range.map(i => PLOT.ping.y.at(i))
				data[0].z = trace_range.map(i => PLOT.ping.z.at(i))

				
				data[1].x = [PLOT.ping.x[ii]]
				data[1].y = [PLOT.ping.y[ii]]
				data[1].z = [PLOT.ping.z[ii]]
	
				layout.datarevision = Math.random()
				Plotly.react(PLOT,data,layout).then(() => {
					requestAnimationFrame(PLOT.update)
				})
			}
			requestAnimationFrame(PLOT.update)
	}, 100)
	",
	"
	let callback = function(e) {
		console.log(e)
		let ie = e[0]
		if (ie.isIntersecting) {
				PLOT.inView = true
				requestAnimationFrame(PLOT.update)
				console.log('asd')
		} else {
			PLOT.inView = false
		}
	}
	
	let options = {
	  rootMargin: '0px',
	  threshold: 1.0
	}
	
	let observer = new IntersectionObserver(callback, options);
	observer.observe(PLOT)
	")
	add_js_listener!(p, "mousedown", "e => {
		PLOT.inView = false
	}")
	add_js_listener!(p, "mouseup", "e => {
		if (e.button == 0) {
			PLOT.inView = true
			requestAnimationFrame(PLOT.update)
	}
	}")
end

# ╔═╡ dd9449ee-17ef-4948-8589-f76a745c96a9


# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
HypertextLiteral = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
PlutoPlotly = "8e989ff0-3d88-8e9f-f020-2b208a939ff0"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
Rotations = "6038ab10-8711-5258-84ad-4b1120ba62dc"
StaticArrays = "90137ffa-7385-5640-81b9-e52037218182"
Unzip = "41fe7b60-77ed-43a1-b4f0-825fd5a5650d"

[compat]
HypertextLiteral = "~0.9.3"
PlutoPlotly = "~0.3.3"
PlutoUI = "~0.7.38"
Rotations = "~1.3.0"
StaticArrays = "~1.4.3"
Unzip = "~0.1.2"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.7.1"
manifest_format = "2.0"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "8eaf9f1b4921132a4cff3f36a1d9ba923b14a481"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.1.4"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.Calculus]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "f641eb0a4f00c343bbc32346e1217b86f3ce9dad"
uuid = "49dc2e85-a5d0-5ad3-a950-438e2897f1b9"
version = "0.5.1"

[[deps.ChainRulesCore]]
deps = ["Compat", "LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "9950387274246d08af38f6eef8cb5480862a435f"
uuid = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
version = "1.14.0"

[[deps.ChangesOfVariables]]
deps = ["ChainRulesCore", "LinearAlgebra", "Test"]
git-tree-sha1 = "bf98fa45a0a4cee295de98d4c1462be26345b9a1"
uuid = "9e997f8a-9a97-42d5-a9f1-ce6bfc15e2c0"
version = "0.1.2"

[[deps.ColorSchemes]]
deps = ["ColorTypes", "Colors", "FixedPointNumbers", "Random"]
git-tree-sha1 = "12fc73e5e0af68ad3137b886e3f7c1eacfca2640"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.17.1"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "024fe24d83e4a5bf5fc80501a314ce0d1aa35597"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.0"

[[deps.Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "417b0ed7b8b838aa6ca0a87aadf1bb9eb111ce40"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.12.8"

[[deps.Compat]]
deps = ["Base64", "Dates", "DelimitedFiles", "Distributed", "InteractiveUtils", "LibGit2", "Libdl", "LinearAlgebra", "Markdown", "Mmap", "Pkg", "Printf", "REPL", "Random", "SHA", "Serialization", "SharedArrays", "Sockets", "SparseArrays", "Statistics", "Test", "UUIDs", "Unicode"]
git-tree-sha1 = "96b0bc6c52df76506efc8a441c6cf1adcb1babc4"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "3.42.0"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.DelimitedFiles]]
deps = ["Mmap"]
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"

[[deps.Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"

[[deps.DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "b19534d1895d702889b219c382a6e18010797f0b"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.8.6"

[[deps.Downloads]]
deps = ["ArgTools", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"

[[deps.DualNumbers]]
deps = ["Calculus", "NaNMath", "SpecialFunctions"]
git-tree-sha1 = "5837a837389fccf076445fce071c8ddaea35a566"
uuid = "fa6b7ba4-c1ee-5f82-b5fc-ecf0adba8f74"
version = "0.6.8"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[deps.Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "8d511d5b81240fc8e6802386302675bdf47737b9"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.4"

[[deps.HypertextLiteral]]
git-tree-sha1 = "2b078b5a615c6c0396c77810d92ee8c6f470d238"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.3"

[[deps.IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "f7be53659ab06ddc986428d3a9dcc95f6fa6705a"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.2"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.InverseFunctions]]
deps = ["Test"]
git-tree-sha1 = "91b5dcf362c5add98049e6c29ee756910b03051d"
uuid = "3587e190-3f89-42d0-90ee-14403ec27112"
version = "0.1.3"

[[deps.IrrationalConstants]]
git-tree-sha1 = "7fd44fd4ff43fc60815f8e764c0f352b83c49151"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.1.1"

[[deps.JLLWrappers]]
deps = ["Preferences"]
git-tree-sha1 = "abc9885a7ca2052a736a600f7fa66209f96506e1"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.4.1"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "3c837543ddb02250ef42f4738347454f95079d4e"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.3"

[[deps.LaTeXStrings]]
git-tree-sha1 = "f2355693d6778a178ade15952b7ac47a4ff97996"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.3.0"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"

[[deps.LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.LinearAlgebra]]
deps = ["Libdl", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.LogExpFunctions]]
deps = ["ChainRulesCore", "ChangesOfVariables", "DocStringExtensions", "InverseFunctions", "IrrationalConstants", "LinearAlgebra"]
git-tree-sha1 = "a7e100b068a6cbead98b9f4e5c8b488934b7aea0"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.11"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"

[[deps.NaNMath]]
git-tree-sha1 = "737a5957f387b17e74d4ad2f440eb330b39a62c5"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "1.0.0"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"

[[deps.OpenLibm_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "05823500-19ac-5b8b-9628-191a04bc5112"

[[deps.OpenSpecFun_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "13652491f6856acfd2db29360e1bbcd4565d04f1"
uuid = "efe28fd5-8261-553b-a9e1-b2916fc3738e"
version = "0.5.5+0"

[[deps.OrderedCollections]]
git-tree-sha1 = "85f8e6578bf1f9ee0d11e7bb1b1456435479d47c"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.4.1"

[[deps.Parameters]]
deps = ["OrderedCollections", "UnPack"]
git-tree-sha1 = "34c0e9ad262e5f7fc75b10a9952ca7692cfc5fbe"
uuid = "d96e819e-fc66-5662-9728-84c9c7592b0a"
version = "0.12.3"

[[deps.Parsers]]
deps = ["Dates"]
git-tree-sha1 = "621f4f3b4977325b9128d5fae7a8b4829a0c2222"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.2.4"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"

[[deps.PlotlyBase]]
deps = ["ColorSchemes", "Dates", "DelimitedFiles", "DocStringExtensions", "JSON", "LaTeXStrings", "Logging", "Parameters", "Pkg", "REPL", "Requires", "Statistics", "UUIDs"]
git-tree-sha1 = "180d744848ba316a3d0fdf4dbd34b77c7242963a"
uuid = "a03496cd-edff-5a9b-9e67-9cda94a718b5"
version = "0.8.18"

[[deps.PlutoPlotly]]
deps = ["AbstractPlutoDingetjes", "HypertextLiteral", "InteractiveUtils", "LaTeXStrings", "Markdown", "PlotlyBase", "PlutoUI", "Reexport"]
git-tree-sha1 = "6a3f31b8f4e5fc14a4edaad5ef5d469c6d2ab282"
uuid = "8e989ff0-3d88-8e9f-f020-2b208a939ff0"
version = "0.3.3"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "Markdown", "Random", "Reexport", "UUIDs"]
git-tree-sha1 = "670e559e5c8e191ded66fa9ea89c97f10376bb4c"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.38"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "d3538e7f8a790dc8903519090857ef8e1283eecd"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.2.5"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.Quaternions]]
deps = ["DualNumbers", "LinearAlgebra", "Random"]
git-tree-sha1 = "b327e4db3f2202a4efafe7569fcbe409106a1f75"
uuid = "94ee1d12-ae83-5a48-8b1c-48b8ff168ae0"
version = "0.5.6"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "838a3a4188e2ded87a4f9f184b4b0d78a1e91cb7"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.3.0"

[[deps.Rotations]]
deps = ["LinearAlgebra", "Quaternions", "Random", "StaticArrays", "Statistics"]
git-tree-sha1 = "a167638e2cbd8ac41f9cd57282cab9b042fa26e6"
uuid = "6038ab10-8711-5258-84ad-4b1120ba62dc"
version = "1.3.0"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.SharedArrays]]
deps = ["Distributed", "Mmap", "Random", "Serialization"]
uuid = "1a1011a3-84de-559e-8e89-a11a2f7dc383"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SparseArrays]]
deps = ["LinearAlgebra", "Random"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.SpecialFunctions]]
deps = ["ChainRulesCore", "IrrationalConstants", "LogExpFunctions", "OpenLibm_jll", "OpenSpecFun_jll"]
git-tree-sha1 = "5ba658aeecaaf96923dce0da9e703bd1fe7666f9"
uuid = "276daf66-3868-5448-9aa4-cd146d93841b"
version = "2.1.4"

[[deps.StaticArrays]]
deps = ["LinearAlgebra", "Random", "Statistics"]
git-tree-sha1 = "4f6ec5d99a28e1a749559ef7dd518663c5eca3d5"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.4.3"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.UnPack]]
git-tree-sha1 = "387c1f73762231e86e0c9c5443ce3b4a0a9a0c2b"
uuid = "3a884ed6-31ef-47d7-9d2a-63182c4928ed"
version = "1.0.2"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.Unzip]]
git-tree-sha1 = "34db80951901073501137bdbc3d5a8e7bbd06670"
uuid = "41fe7b60-77ed-43a1-b4f0-825fd5a5650d"
version = "0.1.2"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl", "OpenBLAS_jll"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
"""

# ╔═╡ Cell order:
# ╠═17f92f1e-b8e9-11ec-2be7-e9b98d93fa8f
# ╠═1960e778-cfc2-4c2f-aafd-b5170663fefa
# ╠═d9e12866-0b72-42f7-a8e0-348c9c310753
# ╠═e712e30f-9877-4a2a-b138-bd68c6227ca8
# ╠═72b02126-fbbd-4dd9-ae22-83683a2f75c9
# ╠═0b308645-dbe1-4699-b14f-abd6478c0e7a
# ╠═b2757e5a-ab4c-4ef1-bb2a-03d3282bb16f
# ╠═f6a12c28-3dd6-47b3-94d1-b2750b4c3805
# ╠═b1cff3e0-c445-4665-a0d9-d746c3bc605f
# ╠═1403399b-c5da-4805-a7a5-ea92b40080be
# ╠═cbd9b1b6-318a-4769-b39f-915f12d1c359
# ╠═e6dfff32-17b8-4e43-b551-2c631b79c90f
# ╠═bb53e654-d614-466a-83de-f2b37aa56688
# ╠═8c8bfd4f-8c5f-4837-a4de-b28442ab18ec
# ╠═4c2e2e9c-d2c2-4b2c-a479-bbbfba63295b
# ╠═e065149d-4cfd-4b91-8dcf-65e915e6c44f
# ╠═d9a307cc-d2fa-4b42-af3e-949bcee63cbb
# ╠═d8db81b1-742d-44e7-b33f-cd4d205fabf9
# ╠═411dba4a-ea69-489d-8d1d-0caa1722a90f
# ╟─b3690f53-f4f7-4a4b-94b4-391286e40370
# ╠═235cce11-a1d9-41be-9b29-2731a441b26d
# ╟─b099f375-a860-4c95-a59b-2e8249882edc
# ╠═653780c7-0b8f-4103-972f-223065cad328
# ╠═4d4f3d75-a75d-4bb1-a263-8f1e3ff0e1fc
# ╠═3e35fe43-6ba0-4d31-a5dd-31351c47ff08
# ╠═4a5aad49-115f-400d-9b2f-8647b7616a62
# ╠═82bf9638-506e-4189-8f9d-f8d918d3da95
# ╠═dd9449ee-17ef-4948-8589-f76a745c96a9
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
