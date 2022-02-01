### A Pluto.jl notebook ###
# v0.15.1

using Markdown
using InteractiveUtils

# ╔═╡ a8faabeb-ce78-411b-891d-77a4ab99c095
using HypertextLiteral

# ╔═╡ 709a3b12-f20b-11eb-3186-dbf00f9261e0
# Add an event listener to this cell 
@htl """
<script>
	const cell = currentScript.closest('pluto-cell')

	/* Add some attribute to the cell */
	cell.setAttribute('cell_logger',"")
	
	const keylogFunc = e => console.log(e)

	cell.addEventListener('keydown',keylogFunc)

	invalidation.then(() => {cell.removeEventListener('keydown',keylogFunc)})
</script>
"""

# ╔═╡ 43e28ac0-597e-4a79-91a9-4ea47f641707
# Call a specific keyboard shortcut inside the codemirror entry
@htl """
<script>
	const cell_cm = document.querySelector("pluto-cell[cell_logger] .CodeMirror")
	cell_cm.CodeMirror.options.extraKeys["Shift-Enter"]()
</script>
"""

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

julia_version = "1.7.0-beta2"
manifest_format = "2.0"

[[deps.HypertextLiteral]]
git-tree-sha1 = "72053798e1be56026b81d4e2682dbe58922e5ec9"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.0"
"""

# ╔═╡ Cell order:
# ╠═a8faabeb-ce78-411b-891d-77a4ab99c095
# ╠═709a3b12-f20b-11eb-3186-dbf00f9261e0
# ╠═43e28ac0-597e-4a79-91a9-4ea47f641707
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
