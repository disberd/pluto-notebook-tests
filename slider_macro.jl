### A Pluto.jl notebook ###
# v0.16.2

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

# ╔═╡ f0562ecb-c708-4534-bba2-4dde5d4d7434
using HypertextLiteral

# ╔═╡ 4f1c46d2-441b-4312-a6e0-1cc94ee72741
using PlutoUI

# ╔═╡ ce5d1d4b-483e-4df2-8fa6-ae8ca5893192
using MacroTools: postwalk

# ╔═╡ 275d01c3-d312-475f-afdb-eddeb63e0a4f
macro slidertable(list_of_prefixes)
    prefixes = getfield(__module__, list_of_prefixes)
    mdstr = "|Bound Variable|Sliders|\n"
    mdstr *= "|:--|:--|\n"
    for pre ∈ prefixes
        name = String(pre) * "slider"
        mdstr *= "|$name|\$(@bind $name Slider(1:10))|\n"
    end
    htl_string_expr = :(@htl """
	$(@md_str($mdstr))
	<script>
		const currentCell = currentScript.closest('pluto-cell')
		
	</script>
	""")
	updated_expr = postwalk(htl_string_expr) do x
		out = if x === :mdstr
			"$mdstr"
		elseif x === :list_of_prefixes
			"$list_of_prefixes"
		else
			x
		end
	end
		
	updated_expr
end

# ╔═╡ 945998f9-2d6b-4780-9e09-0b44a3e4e9e0
@bind testcheck MultiCheckBox(["Foo","Bar","Baz"])

# ╔═╡ b41db417-0734-46d6-a05f-ec8d6a93cda1
myvars = Tuple(testcheck)

# ╔═╡ df173d3b-e00a-42c1-8caf-d05908b721ee
begin
	myvars
	@slidertable myvars
end

# ╔═╡ d6e031e3-26e6-41d0-a65a-5f93961c5ad4
@macroexpand @slidertable myvars

# ╔═╡ 732ab487-216f-4f8b-866f-0cf0ceccd60c
asd = @macroexpand @htl """
$(@md_str("asd"))
<script>
	asd
	$b
</script>
"""

# ╔═╡ 69a3e449-df7e-41fa-9f4d-cc5db28b744c
macro testt()
	a = 3
	:("$a")
end

# ╔═╡ 1f410dab-ebd5-4ace-9bfc-5e5dfb47bc38
@macroexpand @testt

# ╔═╡ c2511798-c05e-4db4-ac68-c9d7f7727f97
@testt

# ╔═╡ a23be5b6-4ba5-447c-9305-8af4b570eed5
asd.args[3]

# ╔═╡ 85007ecb-6703-4b3b-9bed-840e7d8c4ff7
asdlol = let
	sleep(5)
	3
end

# ╔═╡ a3adce8b-2832-417c-a8c6-644250536629
let asd = asdlol
	sleep(5)
end

# ╔═╡ d282e71c-ce23-4b58-a7f2-cfedfad3d060
macro test1(s)
	println(typeof(s))
    println(s)
end

# ╔═╡ e6cf687a-5552-4b4d-8ce8-55f6a9242be3
@test1 "$a"

# ╔═╡ 44c6fc61-439c-4c01-b59b-71cb8ff6357c
let
	a = @htl """
	This is magic
	"""
	@macroexpand1 @htl """
	$a
	<script>
		console.log("voila")
	</script>
	"""
end

# ╔═╡ c02e67da-2850-4345-840a-6c474dc9241f
HypertextLiteral.interpolate(:("this is $a").args)

# ╔═╡ af661ee3-4d3e-43f1-a943-04bb805bae0f


# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
HypertextLiteral = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
MacroTools = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
HypertextLiteral = "~0.9.1"
MacroTools = "~0.5.8"
PlutoUI = "~0.7.16"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.7.0-rc1"
manifest_format = "2.0"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "8d511d5b81240fc8e6802386302675bdf47737b9"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.4"

[[deps.HypertextLiteral]]
git-tree-sha1 = "f6532909bf3d40b308a0f360b6a0e626c0e263a8"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.1"

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
git-tree-sha1 = "8076680b162ada2a031f707ac7b4953e30667a37"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.2"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "5a5bc6bf062f0f95e62d0fe0a2d99699fed82dd9"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.8"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.Parsers]]
deps = ["Dates"]
git-tree-sha1 = "f19e978f81eca5fd7620650d7dbea58f825802ee"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.1.0"

[[deps.PlutoUI]]
deps = ["Base64", "Dates", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "Markdown", "Random", "Reexport", "UUIDs"]
git-tree-sha1 = "4c8a7d080daca18545c56f1cac28710c362478f3"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.16"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.Random]]
deps = ["Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"
"""

# ╔═╡ Cell order:
# ╠═f0562ecb-c708-4534-bba2-4dde5d4d7434
# ╠═4f1c46d2-441b-4312-a6e0-1cc94ee72741
# ╠═ce5d1d4b-483e-4df2-8fa6-ae8ca5893192
# ╠═275d01c3-d312-475f-afdb-eddeb63e0a4f
# ╠═945998f9-2d6b-4780-9e09-0b44a3e4e9e0
# ╠═b41db417-0734-46d6-a05f-ec8d6a93cda1
# ╠═df173d3b-e00a-42c1-8caf-d05908b721ee
# ╠═d6e031e3-26e6-41d0-a65a-5f93961c5ad4
# ╠═732ab487-216f-4f8b-866f-0cf0ceccd60c
# ╠═69a3e449-df7e-41fa-9f4d-cc5db28b744c
# ╠═1f410dab-ebd5-4ace-9bfc-5e5dfb47bc38
# ╠═c2511798-c05e-4db4-ac68-c9d7f7727f97
# ╠═a23be5b6-4ba5-447c-9305-8af4b570eed5
# ╠═85007ecb-6703-4b3b-9bed-840e7d8c4ff7
# ╠═a3adce8b-2832-417c-a8c6-644250536629
# ╠═d282e71c-ce23-4b58-a7f2-cfedfad3d060
# ╠═e6cf687a-5552-4b4d-8ce8-55f6a9242be3
# ╠═44c6fc61-439c-4c01-b59b-71cb8ff6357c
# ╠═c02e67da-2850-4345-840a-6c474dc9241f
# ╠═af661ee3-4d3e-43f1-a943-04bb805bae0f
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
