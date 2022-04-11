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

# ╔═╡ 21c2e141-f112-475f-a610-d37349eaf4ea
begin
	using DelimitedFiles
	using PlutoPlotly
	using Unzip
	using PlutoUI
end

# ╔═╡ 7ee34aa0-e77f-41b0-a1c7-49caf3c1212e
TableOfContents()

# ╔═╡ 4efec19e-6293-4caa-bb99-e3abbf3ca997
csv_file = download("https://data.giss.nasa.gov/gistemp/tabledata_v4/GLB.Ts+dSST.csv")

# ╔═╡ 6b627b80-44dc-4e31-84cc-d29effacd65d
data, headers = let
	mat, header = readdlm(csv_file, ','; skipstart = 1, header = true)
	vect = vec(mat[:, 2:13] |> permutedims)
	filter(x -> x isa Number ? true : false, vect) |> x -> float.(x), header
end

# ╔═╡ cf6e96a5-2931-4dc6-b0a8-e45b2ebd6548
md"""
## circle_3d
"""

# ╔═╡ f9e44e12-5134-47eb-9d29-e78d46e2bf7d
function circle_3d(val, offset, zid, color)
vals = map(0:100) do i
			angle = 2π * (i+3)/106
			y,x = sincos(angle) .* (val+offset)
			z = zid
			x,y,z
		end
		x,y,z = unzip(vals)
		plot = scatter3d(;(;x,y,z)..., 
			mode = "lines", 
			line = attr(
				color = color, 
				width = 6,
			),
			showlegend = false,
			hoverinfo = "skip",
		)

		annot = attr(
					text = "$(val)° C",
					font = attr(
						color = color
					),
					z = zid,
					y = 0,
					x = offset + val,
					showarrow = false,
					# bgcolor = "black",
				)
		return plot, annot
end

# ╔═╡ 03c76328-4337-46a6-a215-fb43f69ae8aa
md"""
## Plot
"""

# ╔═╡ 188c05a7-2d9f-401d-a4df-45d8c38903c0
@bind asd Slider(eachindex(data))

# ╔═╡ 40994cca-88e9-464b-aee6-f0a856a3cf70
md"""
## months
"""

# ╔═╡ 7043a666-fc99-4e89-a94d-d66463cedc2a
months(offset,zid) = map(enumerate(headers[2:13])) do e
	i,m = e
	angle = (i-1) * 2π/12
	y,x = sincos(-angle) .* (offset + 2)
	attr(;
		x,
		y,
		z = zid,
		text = "<b>$(uppercase(m))</b>",
		font = attr(
			color = "yellow",
			size = 16,
		),
		showarrow = false,
	)
end;

# ╔═╡ 0d69cbcc-f322-412d-98a2-59e7ba033ab2
let
	offset = 5
	scale = 1/length(data)
	temp_plot = let
		vals = map(1:asd) do i
			angle = mod(i-1,12) * 2π/12
			y,x = sincos(-angle) .* (data[i] + offset)
			z = scale * (i-1)
			x,y,z
		end
		x,y,z = unzip(vals)
		scatter3d(;x,y,z, mode = "lines", line = attr(
			color = data,
			width = 10,
		),
		showlegend = false,
		)
	end
	circs, annots = let
		lol = map((-1,0,+1),("yellow","green","yellow")) do val,col
			circle_3d(val,offset, asd * scale, col)
		end
		unzip(lol)
	end
	plot_data = [
		# Temperature data
		temp_plot,	
		circs...
	]
	p = plot(plot_data, Layout(
		scene = attr(
			xaxis = attr(
				visible = false,
				# range = [-1,1] .* 6,
			),			
			yaxis = attr(
				visible = false,
				# range = [-1,1] .* 6,
			),
			zaxis = attr(
				visible = false,
				range = [-.1,1.1],
			),
			aspectratio = attr(
				x = 1.75,
				y = 1.75,
				z = 2,
			),
			camera = attr(
				eye = attr(
					x = 0,
					y = 0,
					z = 1.25,
				),
				center = attr(
					z = 0,
				),
				projection_type = "orthographic",
			),
			annotations = [
				# Text of degrees circles
				annots...,
				# Months on the outside
				months(offset,asd*scale)...,
				# Year in the middle
				attr(
					x = 0,
					y = 0,
					z = asd*scale,
					showarrow = false,
					text = "<b>$(1880 + floor(Int,asd/12))</b>",
					font = attr(
						color = "yellow",
						size = 35,
					),
				),
			]
		),
		xaxis = attr(
			visible = false
		),
		yaxis = attr(
			visible = false
		),
		uirevision = 1,
		height = 600,
		paper_bgcolor = "black",
		# plot_bgcolor = "rgba(0,0,0,0)",
	))
	push!(p.script_contents, htl_js("
	PLOT.style.height = plot_obj.layout.height + 'px' 	
	//debugger
	"))
	# add_plotly_listener!(p, "plotly_relayouting", "e => {
	# console.log(e)
	# console.log(plot_obj.layout.scene.camera.eye)
	# }")
	p
end

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
DelimitedFiles = "8bb1440f-4735-579b-a4ab-409b98df4dab"
PlutoPlotly = "8e989ff0-3d88-8e9f-f020-2b208a939ff0"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
Unzip = "41fe7b60-77ed-43a1-b4f0-825fd5a5650d"

[compat]
PlutoPlotly = "~0.3.2"
PlutoUI = "~0.7.38"
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
git-tree-sha1 = "2fa481d57ce1b8ab50259017819706ea46de9252"
uuid = "8e989ff0-3d88-8e9f-f020-2b208a939ff0"
version = "0.3.2"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "Markdown", "Random", "Reexport", "UUIDs"]
git-tree-sha1 = "670e559e5c8e191ded66fa9ea89c97f10376bb4c"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.38"

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
# ╠═21c2e141-f112-475f-a610-d37349eaf4ea
# ╠═7ee34aa0-e77f-41b0-a1c7-49caf3c1212e
# ╠═4efec19e-6293-4caa-bb99-e3abbf3ca997
# ╠═6b627b80-44dc-4e31-84cc-d29effacd65d
# ╟─cf6e96a5-2931-4dc6-b0a8-e45b2ebd6548
# ╠═f9e44e12-5134-47eb-9d29-e78d46e2bf7d
# ╟─03c76328-4337-46a6-a215-fb43f69ae8aa
# ╟─188c05a7-2d9f-401d-a4df-45d8c38903c0
# ╠═0d69cbcc-f322-412d-98a2-59e7ba033ab2
# ╟─40994cca-88e9-464b-aee6-f0a856a3cf70
# ╠═7043a666-fc99-4e89-a94d-d66463cedc2a
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
