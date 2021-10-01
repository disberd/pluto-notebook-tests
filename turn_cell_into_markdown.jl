### A Pluto.jl notebook ###
# v0.16.0

using Markdown
using InteractiveUtils

# ╔═╡ f32f2370-227a-11ec-3255-f784ccc32484
using HypertextLiteral

# ╔═╡ 2dd090d4-1fc8-4533-9b7b-16dd2db59a1b
# To change a variable in another module in Pluto we must use a hack
do_external_thing(args...) = Main.Distributed.remotecall_eval(Main,Main.Distributed.myid(),:(tempvar = rand()))

# ╔═╡ d3ee9d22-48c4-4cef-aafb-5643760d923d
do_external_thing(1,3,"test")

# ╔═╡ 7d710570-0e58-490e-923a-669306974e6b
Main.tempvar

# ╔═╡ 175ed583-5fae-43f0-aa78-bb8a7b12fcdb
md"""
timestamp: 01/10/2021, 09:10:11
```julia
do_external_thing(1,3,"test")
```
"""

# ╔═╡ f897638d-7b63-4e55-91b5-cbed648704ab
macro run_and_log(ex::Expr)
	ex = esc(ex)
	blk = Expr(:block) # Create the block
	push!(blk.args,ex) # Add the input expression for execution
	# Here we create the javascript snippet that will be sent to the output and thus be executed.
	script = :(@htl("""
		<script>
			// Get the current timestamp
			let currentdate = new Date(); 
			let dateTime = currentdate.toLocaleString();
			
			// Change the cell input contents
			const cell = currentScript.closest('pluto-cell')
			const cm = cell.querySelector('pluto-input .CodeMirror').CodeMirror
			let new_text = cm.getValue().replace('@run_and_log ','')
			const newVal = `md\"\"\"
timestamp: \${dateTime}
\\`\\`\\`julia
\${new_text}
\\`\\`\\`
\"\"\"`
			cm.setValue(newVal)
			
			// Simulate pressing the run button
			cell.querySelector('.runcell').click()
			
		</script>
	"""))
	push!(blk.args,script)
	blk
end

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
HypertextLiteral = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"

[compat]
HypertextLiteral = "~0.9.0"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.7.0-rc1"
manifest_format = "2.0"

[[deps.HypertextLiteral]]
git-tree-sha1 = "72053798e1be56026b81d4e2682dbe58922e5ec9"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.0"
"""

# ╔═╡ Cell order:
# ╠═f32f2370-227a-11ec-3255-f784ccc32484
# ╠═2dd090d4-1fc8-4533-9b7b-16dd2db59a1b
# ╠═d3ee9d22-48c4-4cef-aafb-5643760d923d
# ╠═7d710570-0e58-490e-923a-669306974e6b
# ╠═175ed583-5fae-43f0-aa78-bb8a7b12fcdb
# ╠═f897638d-7b63-4e55-91b5-cbed648704ab
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
