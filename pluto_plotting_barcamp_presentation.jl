### A Pluto.jl notebook ###
# v0.19.0

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

# ╔═╡ 0cb94b33-2f7c-4fa0-9920-68f8bc286a0c
begin
	using PlutoUI
	using HypertextLiteral
	using PlutoPlotly
	using Rotations
	using StaticArrays
end

# ╔═╡ ba95d87d-4548-465c-98f2-990440cda4a9
md"""
!!! note 
	Try moving the mouse to the top-right corner of the TableOfContents window to show a button to hide and show hidden parts of the notebook!

	See the Helper Functions section of the notebook (if not hidden 😄)
"""

# ╔═╡ 90db5362-f8e3-4d57-9dfd-aa14a480fbe4
md"""
# Introduction to PlutoPlotly.jl
by Alberto Mengali (**@disberd**)
"""

# ╔═╡ ec6bde02-4d9f-499e-b0f3-82f51cff665f
md"""
## The Julia Plotting Ecosystem
"""

# ╔═╡ 06eefbf7-6de7-488e-97f9-ab07a56d3d71
md"""
The Julia ecosystem is full of Plotting packages:
- Plotly-based Packages
  - PlotlyJS/PlotlyBase
  - PlotlyLight.jl
  - **PlutoPlotly.jl**
  - *PlutoVista.jl*
- Plots.jl (various backends are independent packages)
  - PyPlot.jl
  - PlotlyJS.jl
  - InspectDR.jl
  - UnicodePlots.jl
  - PGFPlotsX.jl
  - UnicodePlots.jl
  - Gaston.jl
- Makie.jl
- VegaLite.jl
- more...
"""

# ╔═╡ d6424e80-39bf-41f1-a40a-51d9769838eb
md"""
With so many plotting packages, it can be daunting to decide which one to choose, each plotting packages have strenght and weaknesses and some are more mature than others
"""

# ╔═╡ 33c18cc2-e1d5-4d47-8158-da728c0c5bc4
md"""
## The usual suspect, Plots.jl
"""

# ╔═╡ 7c76eaa7-5b6d-4cd1-856f-3efc9c6bec5e
md"""
Most people end with Plots.jl when starting with Plotting in Julia, this package seem to be the most recommneded and has the following advantages:
- Unified and polished synthax for plotting
- Possibility of selecting many different backends, using the most suited to the task at hand
- Powerful recipe system and default support by many Julia packages.
- Nice way to make gifs/videos from your data

**Unfortunately, the biggest advantage of Plots is also its main drawback**

Each back-end is hidden under the public API, with Plots.jl capabilities often lagging behind updates and improvements in each of the single specific backends
"""

# ╔═╡ 1520dc3b-0f19-4146-84e1-9f95efcc29de
md"""
## The Plotly ecosystem
"""

# ╔═╡ d9799a40-08f0-4932-89fe-57e88d7552e9
md"""
[Plotly](https://plotly.com/julia/) is a well known plotting library written in JavaScript and providing extensive API for many programming languages such as:
- Julia
- Python
- R
- Matlab

It gives the capability of creating beautiful plots, with a huge amount of different trace types and extreme level of customization to the various kind of plots.

**Plotly keep working interactively inside exported HTML pluto notebooks!**

A very nice repo of beautiful 3D plotly examples (built with PlotlyJS) has been made by Emilia Petrisor (**@empet**) can be found on her [github repo](https://github.com/empet/3D-Viz-with-PlotlyJS.jl) 
(This currently uses Jupyter notebooks for the examples, I plan on re-implementing those in nicer Pluto notebooks :D)
"""

# ╔═╡ 80b89075-56d1-4e9f-b3b4-1f16f69fab57
md"""
## Gallery
"""

# ╔═╡ ec3edb6e-1400-4e00-a829-dece0dd5601e
PlutoUI.Resource(raw"https://raw.githubusercontent.com/empet/3D-Viz-with-PlotlyJS.jl/main/images/thumbnails1.png")

# ╔═╡ a7f1d5c5-8cd5-4cb7-abd0-3d57996aad56
PlutoUI.Resource(raw"https://raw.githubusercontent.com/empet/3D-Viz-with-PlotlyJS.jl/main/images/thumbnails2.png")

# ╔═╡ 321c721c-6c0e-42f4-9a08-d947d94d4fb3
md"""
## Why another Plotly Package?
"""

# ╔═╡ 238d4679-f935-4882-ba81-5c20b469202e
md"""
We have already not 1 but 2 packages dealing with Plotly, why in the world would you want another?

### PlotlyJS
- Relies on WebIO.jl, not currently supported on Pluto and **not needed!**
- Can have a significant TTFP
- I used a hack I posted on discourse till recently to just use PlotlyBase.jl inside Pluto

### PlotlyLight.jl
- PlotlyLight.jl is very recent and extremely light!
- TTFP is extremely low, but it's need too stay super light limits a bit expandability and how it can be exploited inside Pluto
"""

# ╔═╡ 418062b9-0903-4f5d-a9c9-543d62963eca
md"""

## PlutoPlotly.jl
- **Unleashing the full plotly power within Pluto!**
- Thought from the ground-up to be specficially used inside Pluto
- Uses HypertextLiteral.jl and `publish_to_js` (Pluto internal) to provide efficient and easy to customize communication between Pluto and the Plotly JS library
- Uses the same synthax of PlotlyJS.jl for convenience, but hopefully provides a better Pluto experience
- Ready for use for basic use, **capable of plugging custom javascript function/events for power use!**
$(Resource(raw"https://user-images.githubusercontent.com/12846528/161222951-bbe65007-334c-45aa-b44a-aa3ef548f01a.mp4", :height => 300))
"""

# ╔═╡ a2357316-4913-44f9-b812-e09a8a7c95f2
md"""
## Internals and Examples
"""

# ╔═╡ d3b93d1f-1fbc-4a06-9b4f-2040cc74648a
md"""
The rest of the presentation is on other testing notebooks.

Unfortunately I am the textbook example of the procrastinator from [Tim Urban's TED talk](https://www.ted.com/talks/tim_urban_inside_the_mind_of_a_master_procrastinator), so I spent more time trying out new cool things I could do with the package instead of preparing these slides...
$(Resource(raw"https://miro.medium.com/max/600/1*2gNdwLSZBjC7rz01fimO2Q.jpeg"))
"""

# ╔═╡ 1dde3c0c-a2fe-4618-a710-0340641e3222
md"""
## Present Shortcut
"""

# ╔═╡ b0749095-699b-4831-aa84-579edf9e5bae
@htl """
<script>
const listener = (e) => {
		if (e.shiftKey && e.key == "F11") {
			window.present()
		}

	}	
	document.addEventListener('keydown',listener, true)
	invalidation.then(() => {
		document.removeEventListener('keydown',listener)
	})
</script>
"""

# ╔═╡ 2aebc0ad-d6d7-41b4-ab42-f16a2914cfe9
md"""
## Hiding style
"""

# ╔═╡ 518284ae-d5f2-41a2-959f-4c44068be85e
md"""
## Custom button ToC
"""

# ╔═╡ 725c249f-f0b2-415b-964f-80671a7ba974
function custom_button(default::Bool)
	@htl """
	<script id='hide-button-span'>
		const sp = document.createElement('span')
		sp.classList.toggle('custom_hidden_button',true)
		sp.value = $default
		sp.addEventListener('click',() => {
			sp.value = !sp.value
			if (sp.value) {
				sp.setAttribute('hide','')
			} else {
				sp.removeAttribute('hide')
			}
			sp.dispatchEvent(new CustomEvent('input'))			
		})
		return sp
	</script>
	<style>
	.custom_hidden_button {
		width: 17px;
		height: 17px;
		background-size: 17px 17px;
		padding-left: 17px;
		background-repeat: no-repeat;
		position: absolute;
		top: 20px;
		right: 25px
	}
	.custom_hidden_button:hover {
		background-image: url('https://cdn.jsdelivr.net/gh/ionic-team/ionicons@5.5.1/src/svg/eye-outline.svg');
	}
	.custom_hidden_button[hide]:hover {
		background-image: url('https://cdn.jsdelivr.net/gh/ionic-team/ionicons@5.5.1/src/svg/eye-off-outline.svg');
	}
	</style>
	"""
end

# ╔═╡ 2b3a237e-e2ee-410e-81c5-da6e91b05f7e
md"""
## ToC
"""

# ╔═╡ ef9ee0d1-db86-4596-85bf-2ff7b22b8fc7
function ToC()
	@htl """
	$(TableOfContents())
	$(@bind hide_cells custom_button(false))
	<script>
		const cell = currentScript.closest('pluto-cell')
		const bond = cell.querySelector('bond')
		const ToC = cell.querySelector('nav')
		const hdr = ToC.querySelector('header')
		hdr.insertBefore(bond, null)
	
		function updateToc(val) {

				const rows = ToC.querySelectorAll('div.toc-row')
				for (const row of rows) {
					const aa = row.querySelector(`a`)
					const ref = aa.getAttribute('href').slice(1)
					const c = document.querySelector(`pluto-cell[id='\${ref}']`)
					console.log(c.hasAttribute('hidden-parent'))
					if (val && (c.hasAttribute('hidden') || c.hasAttribute('hidden-section') || c.hasAttribute('hidden-parent'))) {
						row.style.height = '0px'
						row.style.paddingBottom = '0px'
					} else {
						row.style.height = ''
						row.style.paddingBottom = ''
					}
		
				}
			}
		const tocobserver = new MutationObserver((m) => {
		//console.log("mutation!")
		console.log(m)
		setTimeout(() => updateToc(bond.firstChild.value),1)
	})

	tocobserver.observe(ToC, {childList: true})
		
		bond.firstChild.addEventListener('input',e => {
			setTimeout(() => {
				cell.classList.toggle('recompute')
	}, 100)
		})
	invalidation.then(() => {
		tocobserver.disconnect()
	})
	</script>
	<style>
	body.presentation .plutoui-toc {
		display: none;
	}
	"""
end

# ╔═╡ f438f1ce-6493-4f5e-8111-3e07b12793a4
ToC()

# ╔═╡ 92a50445-a32f-4b80-a913-a4d594f2ffab
@htl """
<style>
pluto-cell[hidden],pluto-cell[hidden-section],pluto-cell[hidden-parent] {
	min-height: $(hide_cells ? "0px" : nothing);
	visibility: $(hide_cells ? "hidden" : "visible");
	margin-top: $(hide_cells ? "0px" : nothing);
	height: $(hide_cells ? "0px" : nothing);
	display: $(hide_cells ? "none" : "block");
}
</style>
"""

# ╔═╡ 8fe47abb-35f6-4b91-966c-7eef80ab6749
md"""
## hide_cell
"""

# ╔═╡ dd674cd2-9d7c-4496-b4fa-067c0dbdb7b0
begin
	"""
	hide_cell(content)
Render the provided content using `@htl` and forces the containing cell to have an attribute `hidden` set.

To work, this function call must be the last output of the cell, or the javascript used for toggling the cell attribute on the front-end won't be executed
"""
function hide_cell(content)
	@htl """
		$content
		<script id='hide-cell'>
		const cell = currentScript.closest('pluto-cell')
		cell.setAttribute('hidden','')
		invalidation.then(() => {
			cell.removeAttribute('hidden')
		})
		</script>
	"""
end
end

# ╔═╡ a0295a3a-f21b-4e07-8898-823173d41888
macro set_hidden(content)
	:(hide_cell($(content))) |> esc
end

# ╔═╡ cbc9a299-1f32-4608-9c9d-34467b12eb8d
md"""
## hide_section
"""

# ╔═╡ 09363571-d064-4971-adf1-d9cfbde67e99
function hide_section(content)
	@htl """
	$content
	<script>
	// Get current cell
		const cell = currentScript.closest('pluto-cell')
		cell.setAttribute('hidden-section','')

		// Check if the cell has an header
		const header = cell.querySelector('h1, h2, h3, h4, h5, h6')

		if (!header) {return} // return if no heading found in the cell

		function updateToc(val) {
	
			return (c) => {
				const tocEntry = document.querySelector(`a[href='#\${c.id}']`)
	
				if (!tocEntry || !tocEntry.parentElement.classList.contains('toc-row')) {return}
				if (val) {
					tocEntry.parentElement.style.height = '0px'
				} else {	
					tocEntry.parentElement.style.height = ''
				}
	
			}
		}
	
		function hideToggle(name,val) {
			return (el) => {
				if (val) {
					el.setAttribute(name,'')
				} else {
					el.removeAttribute(name,'')				
				}
			}
		}

		const depth = parseInt(header.tagName[1])
		const range = Array.from({length: depth}, (x, i) => i+1) // [1, ..., depth]
		
		const selector = range.map(i => `h\${i}`).join(",")
		
		function updateHidden(val) {
		const cellsBelow = document.querySelectorAll(`pluto-cell[id='\${cell.id}'] ~ pluto-cell`)
		//console.log(cellsBelow)
		for (const el of cellsBelow) {
			if (!el.querySelector(selector)) {
				if (el.querySelector('.plutoui-toc')) {continue}
				hideToggle('hidden-parent',val)(el)
				// updateToc(val)(el)
			} else {
				//console.log('stop ',el)
				break;
			}
		}
		}
		updateHidden(true)

	const notebook = document.querySelector("pluto-notebook")
	// And one for the notebook's child list, which updates our cell observers:
	const notebookObserver = new MutationObserver((m) => {
		//console.log("mutation!")
		//console.log(m)
		updateHidden(true)
	})

	notebookObserver.observe(notebook, {childList: true})



	
		const ts = new Date()
		cell.lastSave = ts


	
		invalidation.then(() => {
			if (ts-cell.lastSave == 0) {
				cell.removeAttribute('hidden-section')
				updateHidden(false)
				
			notebookObserver.disconnect()
			}
		})
	</script>
	"""
end

# ╔═╡ fe515ba0-3258-48a3-bbad-56c5fba5f543
md"""
# Utilities
""" |> hide_section

# ╔═╡ baaf12c6-6d9f-4503-9379-62f72eeb9fa4
md"""
# Helper Functions
""" |> hide_section

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
HypertextLiteral = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
PlutoPlotly = "8e989ff0-3d88-8e9f-f020-2b208a939ff0"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
Rotations = "6038ab10-8711-5258-84ad-4b1120ba62dc"
StaticArrays = "90137ffa-7385-5640-81b9-e52037218182"

[compat]
HypertextLiteral = "~0.9.3"
PlutoPlotly = "~0.3.3"
PlutoUI = "~0.7.38"
Rotations = "~1.3.0"
StaticArrays = "~1.4.3"
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
# ╠═0cb94b33-2f7c-4fa0-9920-68f8bc286a0c
# ╠═f438f1ce-6493-4f5e-8111-3e07b12793a4
# ╟─ba95d87d-4548-465c-98f2-990440cda4a9
# ╟─90db5362-f8e3-4d57-9dfd-aa14a480fbe4
# ╟─ec6bde02-4d9f-499e-b0f3-82f51cff665f
# ╟─06eefbf7-6de7-488e-97f9-ab07a56d3d71
# ╟─d6424e80-39bf-41f1-a40a-51d9769838eb
# ╟─33c18cc2-e1d5-4d47-8158-da728c0c5bc4
# ╟─7c76eaa7-5b6d-4cd1-856f-3efc9c6bec5e
# ╟─1520dc3b-0f19-4146-84e1-9f95efcc29de
# ╟─d9799a40-08f0-4932-89fe-57e88d7552e9
# ╟─80b89075-56d1-4e9f-b3b4-1f16f69fab57
# ╟─ec3edb6e-1400-4e00-a829-dece0dd5601e
# ╟─a7f1d5c5-8cd5-4cb7-abd0-3d57996aad56
# ╟─321c721c-6c0e-42f4-9a08-d947d94d4fb3
# ╟─238d4679-f935-4882-ba81-5c20b469202e
# ╟─418062b9-0903-4f5d-a9c9-543d62963eca
# ╟─a2357316-4913-44f9-b812-e09a8a7c95f2
# ╟─d3b93d1f-1fbc-4a06-9b4f-2040cc74648a
# ╟─fe515ba0-3258-48a3-bbad-56c5fba5f543
# ╟─1dde3c0c-a2fe-4618-a710-0340641e3222
# ╠═b0749095-699b-4831-aa84-579edf9e5bae
# ╠═baaf12c6-6d9f-4503-9379-62f72eeb9fa4
# ╠═2aebc0ad-d6d7-41b4-ab42-f16a2914cfe9
# ╠═92a50445-a32f-4b80-a913-a4d594f2ffab
# ╟─518284ae-d5f2-41a2-959f-4c44068be85e
# ╠═725c249f-f0b2-415b-964f-80671a7ba974
# ╠═2b3a237e-e2ee-410e-81c5-da6e91b05f7e
# ╠═ef9ee0d1-db86-4596-85bf-2ff7b22b8fc7
# ╠═8fe47abb-35f6-4b91-966c-7eef80ab6749
# ╠═dd674cd2-9d7c-4496-b4fa-067c0dbdb7b0
# ╠═a0295a3a-f21b-4e07-8898-823173d41888
# ╠═cbc9a299-1f32-4608-9c9d-34467b12eb8d
# ╠═09363571-d064-4971-adf1-d9cfbde67e99
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
