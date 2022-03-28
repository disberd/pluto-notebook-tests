### A Pluto.jl notebook ###
# v0.18.4

using Markdown
using InteractiveUtils

# ╔═╡ 45eaf798-5013-42ff-adbc-0456de7bacec
begin
	using PlotlyBase
	using HypertextLiteral
end

# ╔═╡ 5411e074-ec14-4b4f-88d2-0f3c52c84158
htl_js(x) = HypertextLiteral.JavaScript(x)

# ╔═╡ a56243b9-71c2-485a-bfc5-ea015f4d7c8f
begin
Base.@kwdef struct PlutoPlot
	Plot::PlotlyBase.Plot
	plotly_listeners::Dict{String, Any} = Dict{String, Any}()
end
PlutoPlot(p::PlotlyBase.Plot; kwargs...) = PlutoPlot(;kwargs..., Plot = p)
end

# ╔═╡ 2c8716cf-920f-4377-a437-94dac6a05a74
function _show(pp::PlutoPlot, script_id::String = "pluto-plotly-div")
@htl """
	<script id=$(script_id)>
		// Load the plotly library
		if (!window.Plotly) {
			const {plotly} = await import("https://cdn.plot.ly/plotly-2.11.1.min.js")
		}

		// Flag to check if this cell was  manually ran or reactively ran
		const firstRun = this ? false : true
		const PLOT = this ?? document.createElement("div");
		const parent = currentScript.parentElement
		const isPlutoWrapper = parent.classList.contains('raw-html-wrapper')

		// Publish the plot object to JS
		let plot_obj = $(htl_js(PlotlyBase.json(pp.Plot)))

		if (firstRun) {
			// It seem plot divs would not autosize themself inside flexbox containers without this
  			parent.appendChild(PLOT)
		}

		// Get the listeners
		const plotly_listeners = $(pp.plotly_listeners)

		// If width is not specified, set it to 100%
		PLOT.style.width = plot_obj.layout.width ? "" : "100%"
		
		// For the height we have to also put a fixed value in case the plot is put on a non-fixed-size container (like the default wrapper)
		PLOT.style.height = plot_obj.layout.height ? "" :
			(isPlutoWrapper || parent.clientHeight == 0) ? "400px" : "100%"
	
		Plotly.react(PLOT, plot_obj).then(() => {
			// Assign the Plotly event listeners
			for (const [key, value] of Object.entries(plotly_listeners)) {
			    PLOT.on(key, value)
			}
		}
		)

		invalidation.then(() => {
			// Remove all listeners
			PLOT.removeAllListeners()
		})

		return PLOT
	</script>
"""
end

# ╔═╡ 3296721a-6640-454d-89fb-0b26092060e2
PlutoPlot(Plot(rand(10)))

# ╔═╡ 0c979f81-f7ef-4493-b348-c8f5ed169e7a
@htl "$(PlutoPlot(Plot(rand(10))))"

# ╔═╡ 29761206-04fd-4ff3-bcce-f57ced86917c
md"""
## Unique Counter
"""

# ╔═╡ 4c56ff7b-4f49-43d3-b2ab-5de24e387de9
function unique_io_counter(io::IO, identifier = "script_id")
	!get(io, :is_pluto, false) && return -1 # We simply return -1 if not inside pluto
	# By default pluto inserts a dict inside the IOContext under key :extra_items. See https://github.com/fonsp/Pluto.jl/blob/10747db7ed512c6b3a9881c5cdb2a4daadea766d/src/runner/PlutoRunner.jl#L786
	dict = io.dict[:extra_items]
	# The dict has key of type Tuple{ObjectID, Int64}, so we a custom key with our custom identifier where we will store the counter 
	key = (objectid(identifier), 0)
	counter = get(dict, key, 0) + 1
	# Update the counter on the dict that is shared within this IOContext
	dict[key] = counter
end

# ╔═╡ 8853604b-cc75-4dc8-a4fd-b59998383672
# Using the unique_io_counter inside the show3 method allows to have unique counters for plots within a same cell.
# This does not ensure that the same plot object is always given the same unique script id if the plots are added to the cells with `if...end` blocks.
function plotly_script_id(io::IO)
	# counter = unique_io_counter(io, "plotly-plot")
	counter = 3
	return "plot_$counter"
end

# ╔═╡ eee5ebf9-9cfd-454e-bd9c-2665ddde6acb
function Base.show(io::IO, mime::MIME"text/html", plt::PlutoPlot)
	script_id = plotly_script_id(io)
	# show(io, mime, _show(plt, plotly_script_id(io)))
	show(io, mime, _show(plt))
end

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
HypertextLiteral = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
PlotlyBase = "a03496cd-edff-5a9b-9e67-9cda94a718b5"

[compat]
HypertextLiteral = "~0.9.3"
PlotlyBase = "~0.8.18"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.7.1"
manifest_format = "2.0"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

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

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.DelimitedFiles]]
deps = ["Mmap"]
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"

[[deps.DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "b19534d1895d702889b219c382a6e18010797f0b"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.8.6"

[[deps.Downloads]]
deps = ["ArgTools", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[deps.HypertextLiteral]]
git-tree-sha1 = "2b078b5a615c6c0396c77810d92ee8c6f470d238"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.3"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

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

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"

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
git-tree-sha1 = "85b5da0fa43588c75bb1ff986493443f821c70b7"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.2.3"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"

[[deps.PlotlyBase]]
deps = ["ColorSchemes", "Dates", "DelimitedFiles", "DocStringExtensions", "JSON", "LaTeXStrings", "Logging", "Parameters", "Pkg", "REPL", "Requires", "Statistics", "UUIDs"]
git-tree-sha1 = "180d744848ba316a3d0fdf4dbd34b77c7242963a"
uuid = "a03496cd-edff-5a9b-9e67-9cda94a718b5"
version = "0.8.18"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

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

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SparseArrays]]
deps = ["LinearAlgebra", "Random"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.UnPack]]
git-tree-sha1 = "387c1f73762231e86e0c9c5443ce3b4a0a9a0c2b"
uuid = "3a884ed6-31ef-47d7-9d2a-63182c4928ed"
version = "1.0.2"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

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
# ╠═45eaf798-5013-42ff-adbc-0456de7bacec
# ╠═5411e074-ec14-4b4f-88d2-0f3c52c84158
# ╠═a56243b9-71c2-485a-bfc5-ea015f4d7c8f
# ╠═2c8716cf-920f-4377-a437-94dac6a05a74
# ╠═eee5ebf9-9cfd-454e-bd9c-2665ddde6acb
# ╠═3296721a-6640-454d-89fb-0b26092060e2
# ╠═0c979f81-f7ef-4493-b348-c8f5ed169e7a
# ╠═29761206-04fd-4ff3-bcce-f57ced86917c
# ╠═4c56ff7b-4f49-43d3-b2ab-5de24e387de9
# ╠═8853604b-cc75-4dc8-a4fd-b59998383672
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
