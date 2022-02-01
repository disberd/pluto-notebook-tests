### A Pluto.jl notebook ###
# v0.17.1

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

# ╔═╡ 1b676488-3a39-4fbc-b226-38ecd6585e9a
begin
	import Pkg
	Pkg.activate("")
end

# ╔═╡ d4e4d4f7-5325-4e95-a817-60ebdfe7c091
using Revise

# ╔═╡ e7b1b722-bcf0-4aef-b1e2-160efeaef1fa
using UUIDs

# ╔═╡ a305df41-a3d4-4d70-9c30-a0d8fee105f9
using PlotlyBase

# ╔═╡ 63b622a0-dec0-11eb-1696-cb9ce54eaa95
using PlutoUtils

# ╔═╡ 5df49da5-ecef-49c9-bc4b-ab13f2b5a95c
html"""
<style>
	body.presentation .plutoui-toc.aside {
	display: none;
}
</style>
"""

# ╔═╡ d0e32469-82e3-4e83-8fb9-93e1822afe82
html"""
<script id=asdf>

	const right = document.querySelector('button.changeslide.next')
	const left = document.querySelector('button.changeslide.prev')

	let fullScreen = false


	const func = (e) => {
		if (e.key == "F10") {
			e.preventDefault()
			window.present()
			if (fullScreen) {
				document.exitFullscreen().then(() => fullScreen = false)
			} else {

				document.documentElement.requestFullscreen().then(() => fullScreen = true)
			}
		}
		if (document.body.classList.contains('presentation')) {
			if (e.target.tagName == "TEXTAREA") return
			if (e.key == "ArrowLeft") {
				left.click()
				return
			}

			if (e.key == "ArrowRight") {
				right.click()
				return
			}
			if (e.key == "Escape") {
				window.present()
				fullScreen = false
document.exitFullscreen().catch(() => {return})
			}
		}
	}

	document.addEventListener('keydown',func)

	invalidation.then(() => {document.removeEventListener('keydown',func)})
</script>
"""

# ╔═╡ fed7f33f-7d58-4eae-9d0d-4cc0d6274001
# Function to toggle disabling the UI
@htl """
<script id='toggle-ui-event'>

const helpbox = document.getElementById('helpbox-wrapper')
const disable_ui = () => {
	helpbox.style.display = "none"
	document.body.classList.toggle('disable_ui',true)
}

const enable_ui = () => {
	helpbox.style.display = "block"
	document.body.classList.toggle('disable_ui',false)
}


const keyEvent = (e) => {
	if (e.key == "F9" && e.ctrlKey) {
		document.body.classList.contains('disable_ui') ? enable_ui() : disable_ui()
		return
	}
}

document.addEventListener('keydown',keyEvent)

invalidation.then(() => {document.removeEventListener('keydown',keyEvent)})

return

</script>
"""

# ╔═╡ 580a8aa4-de0e-4073-9859-e1db07f0ec0a
# Style the CSS for presentation
@htl """
<style>
/* body.presentation main {
		max-width : 95%;
	}

body.presentation div.raw-html-wrapper {
	display: flex;
	text-align:center;
}

body.presentation div.raw-html-wrapper h1{
	margin-left: auto;
	margin-right: auto;
}

body.presentation div.raw-html-wrapper h2{
	font-size: 2.5em;
}
*/
</style> 
"""

# ╔═╡ 5fb17e6c-2d74-4a9d-a767-f4d44fa47e96
ToC()

# ╔═╡ 253ef5d5-2222-4e07-b128-d01187994316
@htl """
<h1>
	Functional Payload Modelling for Telecom System Tradeoffs
	<br>
	Implementation Example using <img src="https://upload.wikimedia.org/wikipedia/commons/thumb/1/1f/Julia_Programming_Language_Logo.svg/1280px-Julia_Programming_Language_Logo.svg.png" height="50" style="position: relative; bottom: -.3em"> and <img src="https://raw.githubusercontent.com/fonsp/Pluto.jl/dd0ead4caa2d29a3a2cfa1196d31e3114782d363/frontend/img/logo_white_contour.svg" height="50" style="position: relative; bottom: -.35em">
</h1>
"""

# ╔═╡ bc5f2848-0a72-47f5-9125-4990ed59a2b7
md"""
## Outline
"""

# ╔═╡ 82805fd4-bb3d-4fda-af9f-d7712c7cfa75
let 
	id = "b" * (uuid4() |> string)
	@htl """
<ul>
<li><p>Introduction to <img src="https://upload.wikimedia.org/wikipedia/commons/thumb/1/1f/Julia_Programming_Language_Logo.svg/1280px-Julia_Programming_Language_Logo.svg.png" height="50" style="position: relative; bottom: -.3em">
<li><p>Introduction to <img src="https://raw.githubusercontent.com/fonsp/Pluto.jl/dd0ead4caa2d29a3a2cfa1196d31e3114782d363/frontend/img/logo_white_contour.svg" height="40" style="position: relative; bottom: -.35em"> Notebooks
<li><p>Payload Modelling Tool (SPATIAL)
</ul>
<script>
const d = currentScript.parentElement.closest('div')
d.setAttribute('id',$id)
</script>
<style>
body.presentation div#$id li p{
	font-size: 2em;
	margin-bottom: 2.5em;
}
body.presentation div#$id{
	text-align:left;
}
"""
end

# ╔═╡ 70a2bf9d-c96c-475d-9ba1-eb5d2c27e210
@htl """
<h2>Introduction to <img src="https://upload.wikimedia.org/wikipedia/commons/thumb/1/1f/Julia_Programming_Language_Logo.svg/1280px-Julia_Programming_Language_Logo.svg.png" height="50" style="position: relative; bottom: -.3em">
"""

# ╔═╡ 4aaa6ab1-bde2-4707-931d-65378aa620ad
let
	a = md"""
- Young open-source language developed at MIT
- Very high level (easy to code in) yet very fast due to smart compilation approach
- Syntax is quite close to MATLAB, but doesn't require advanced vectorization to achieve speed
  - Code is easier to write and maintain/understand with for cycles
- Plug and Play, does not require license and can be downloaded as portable without installation
  - Many servers currently idle because they don't have licenses for the most used softwares
- Capable and active community, small but growing
- Can be used to call existing code with limited overhead
  - C, Python, R, MATLAB (requires working MATLAB installation and license)
"""	
	id = "b" * (uuid4() |> string)
@htl """
$a
<script>
const d = currentScript.parentElement.closest('div')
d.setAttribute('id',$id)
</script>
<style>
body.presentation div#$id li p{
	font-size: 1.5em;
	margin-bottom: 1.2em;
}
body.presentation div#$id {
	text-align:left;
}
</style>
"""
end

# ╔═╡ daa95ebc-e186-43c7-95ae-06a67affd214
@htl """
<h2>Introduction to <img src="https://raw.githubusercontent.com/fonsp/Pluto.jl/dd0ead4caa2d29a3a2cfa1196d31e3114782d363/frontend/img/logo_white_contour.svg" height="50" style="position: relative; bottom: -.3em"> Notebooks
"""

# ╔═╡ 5490f8a2-635b-4dfa-8f4c-86f3d0225f3a
let
	a = md"""
- Pluto is a package exclusive to Julia that provide notebook functionality
  - Support for markdown for rich format documentation together with code
  - Cells can directly evaluate Julia code or HTML/JavaScript
    - Can easily tweak visualization and exploit big code-base already existing online
  - Similar to Jupyter but bringing many additional benefits
- Reactivity: Cells dependencies are tracked by the julia backend
  - Whenever the content of a cell is changed, the cells affected by the change (and only those ones) are recomputed automatically
  - Extremely useful for prototyping and perform faster trade-offs once codebase is complete
- File format is a simple julia text file
  - The notebook itself can be inclued/imported in any julia file/notebook and its functions and definitions are added
- Convenient static HTML export that loses interactivity with Julia but keeps the JavaScript one
"""	
	id = "b" * (uuid4() |> string)
@htl """
$a
<script>
const d = currentScript.parentElement.closest('div')
d.setAttribute('id',$id)
</script>
<style>
body.presentation div#$id li p{
	font-size: 1.4em;
	margin-bottom: .7em;
}body.presentation div#$id{
	text-align:left;
}
</style>
"""
end

# ╔═╡ adf6844a-11ab-44af-bf5c-b55856fd9409
@htl """
<h2><img src="https://raw.githubusercontent.com/fonsp/Pluto.jl/dd0ead4caa2d29a3a2cfa1196d31e3114782d363/frontend/img/logo_white_contour.svg" height="50" style="position: relative; bottom: -.3em"> Examples: Execute Julia Code
"""

# ╔═╡ e74d4ada-a1c1-40ef-ba9e-cda74433dd18
md"""
Any Text put into a cell and ran is intepreted as julia code by default
"""

# ╔═╡ fa41ded8-5e6e-4ed7-81bd-ece427057cc9
2π + 12

# ╔═╡ 65c3cb2b-2fe1-46d2-87be-cbec551cb616
a = rand(10)

# ╔═╡ a346568a-d0ff-4783-9922-ec6d4bf0b58c
b = rand(10)

# ╔═╡ 3e98f50c-2470-4ff2-962f-9b147c680ae5
c = a .* b

# ╔═╡ 8ffa26a3-4cbe-4555-a777-04e4a1bb3743
print_num(x) = "The input number is: $x"	

# ╔═╡ acea80b8-9a66-47ae-a216-fc3bea2e7ef2
print_sum(a) = print_num(sum(a))

# ╔═╡ e21cbf28-0e3e-4d82-8617-30be11795e91
print_num(5)

# ╔═╡ abeb1b11-be79-461a-9fa7-522ef8f09b51
print_sum(1:5)

# ╔═╡ fdfeebc6-bd9d-4ad6-a907-c8514e5e59bc
md"""
### Markdown
"""

# ╔═╡ 9e7f7f60-c326-4216-b3a4-1b3362b60199
md"""
Text can be simply wrapped inside markdown delimiter and is interpreted:
- Inline Latex: $y = 3x + 2$
- _Italic_ and __Bold__ text
"""

# ╔═╡ 2ad76af4-349c-43a5-a377-0715b9a02633
md"""
## Plotting
"""

# ╔═╡ 1d0fbf83-8a60-4838-b60b-54ca8d62014a
md"""
Many Plotting packages also exist, Plotly is one JavaScript package that provide nice and interactive plots
"""

# ╔═╡ 4b909553-2027-4eeb-b970-5ce6b2dea1f0
p1 = Plot(rand(10,4))

# ╔═╡ dae3c053-86e9-4ec4-b287-d5344028e893
p2 = Plot(heatmap(z=rand(150,150)))

# ╔═╡ 65d7a66b-170b-497a-b1ad-d587f75a8d63
md"""
## Interactivty
"""

# ╔═╡ bfaf7d01-2b9c-4d89-8a3b-411c84cdd764
@bind a1 Editable(2.5)

# ╔═╡ 036a6b57-1c6a-4597-b661-cc74d16ee7cc
a2 = 10

# ╔═╡ b668b988-dc44-44a7-bddc-3bbe9e5c33a9
d = a1 + a2

# ╔═╡ 5b173882-2fde-48e5-8e7f-a01531808ff0
@bind cc Scrubbable(1:10)

# ╔═╡ 173dd761-b164-40cf-920f-5920078c4667
f(x) = cc*x

# ╔═╡ dce1478a-3f2a-4a25-8f3a-541792ea1c16
f(3)

# ╔═╡ 45359d52-8a96-4280-a1e6-e15cffc42f09
@bind nlines Scrubbable(1:5)

# ╔═╡ 516a71e6-6bfb-4074-a2fe-c4be0a10b4c0
Plot(rand(10,nlines))

# ╔═╡ ed539a7e-7e99-482a-9c67-a5a4f92e3066
@htl """
<h1>
SPATIAL: A Payload Optimization Tool for Satellites based on Active Antennas and On-Board Processing
"""

# ╔═╡ 7aae9577-232f-4e62-875f-6d5257d2d0fb
md"""
## Background
"""

# ╔═╡ 44d7fe61-02dc-41bb-acd0-fd3339815966
let
	a = md"""
- Satellite operators are urging for flexible and re-configurable payloads, where bandwidth, power and coverage can be tuned to follow user demand.
- At the same time, the need for cost reduction is pushing for modular payload components predisposed for serial production.
- Two payload elements are of particular interest for next generation systems:
  - Active Antennas
    - Possibility of easily shape and re-configure beam layouts through beam-forming
    - Inherent power-pooling of the solid state amplifiers, leading to increased reliability and graceful performance degradation in case of failure
  - On-Board Processors
    - Fast and Flexible channelization and routing of bandwidth between feeder and user link
    - Synergy with Active Antennas through potential for digital beamforming

"""	
	id = "b" * (uuid4() |> string)
@htl """
$a
<script>
const d = currentScript.parentElement.closest('div')
d.setAttribute('id',$id)
</script>
<style>
body.presentation div#$id li p{
	font-size: 1.8em;
	margin-bottom: .7em;
}
body.presentation div#$id li li p{
	font-size: 1.5em;
	margin-bottom: .7em;
}
body.presentation div#$id li li li p{
	font-size: 1em;
	margin-bottom: .7em;
}
body.presentation div#$id{
	text-align:left;
}
</style>
"""
end

# ╔═╡ bc4aa363-049c-4070-9523-d209f46b3666
md"""
## Need for the Tool
"""

# ╔═╡ 55ae59fb-afef-4ae3-a850-e9eaaee9da65
let
	a = md"""
- Flexible and reconfigurable payloads have a great number of parameters that can be tuned:
    - Bandwidth
    - Power
    - Number of Beams
    - Etc.. 
- An efficient way to assess the system performance as a function of these parameters is needed to guide the payload optimization
- Traditionally, performance estimation is tailored to the specific payload configuration
    - The method has to be revised each time the payload configuration changes
- A tool to provide fast throughput estimation modelling payload elements as functional blocks is needed
    - Different payloads configuration can be easily modified with this functional approach without changing the need to modify the throughput estimation procedure

"""	
	id = "b" * (uuid4() |> string)
@htl """
$a
<script>
const d = currentScript.parentElement.closest('div')
d.setAttribute('id',$id)
</script>
<style>
body.presentation div#$id li p{
	font-size: 1.5em;
	margin-bottom: 1em;
}
body.presentation div#$id li li p{
	font-size: 1em;
	margin-bottom: 1em;
}
body.presentation div#$id li li li p{
	font-size: 1em;
	margin-bottom: .7em;
}
body.presentation div#$id{
	text-align:left;
}
</style>
"""
end

# ╔═╡ d2e195c2-8489-47d8-a621-381cdb60bacc
md"""
## Introducing SPATIAL
"""

# ╔═╡ 30cdc005-fbc2-4622-9efb-bfb471851a5d
let
	a = md"""
- SPATIAL (System and PAyload joinT optImizAtion tool) was developed to address this need:
  - Based on payloads with OBP and Active Antennas
  - Automatic Payload dimensioning and Throughput estimation
  - Payload modeling via parameters specified as user inputs
  - Optimized for speed of throughput computation
  - Developed in MATLAB and currently being ported to open-source (Julia)
  - Estimate Mass and Power consumption of the payload elements
  - Provides the payload configuration maximizing system throughput while respecting user defined platform constraints


"""	
	id = "b" * (uuid4() |> string)
@htl """
$a
<script>
const d = currentScript.parentElement.closest('div')
d.setAttribute('id',$id)
</script>
<style>
body.presentation div#$id li p{
	font-size: 2em;
	margin-bottom: 1em;
}
body.presentation div#$id li li p{
	font-size: 1.2em;
	margin-bottom: 1em;
}
body.presentation div#$id li li li p{
	font-size: 1em;
	margin-bottom: .7em;
}
body.presentation div#$id{
	text-align:left;
}
</style>
"""
end

# ╔═╡ 70d1f9e0-c889-47af-98dc-fa9d53f98c2c
md"""
## SPATIAL: High Level Structure
"""

# ╔═╡ 270b5113-81e4-47df-a147-b72500e72e20
let
	l1 = md"""
- Optimization performed in 2-step:
  - Payload dimensioning and Throughput estimation for parameters to be optimized
  - Optimization by selecting the set of parameters providing maximum throughput while satisfying constraints
"""	
img=LocalResource(raw"C:\Users\Alberto Mengali\Dropbox\PhD\Papers\Overleaf\ASMS_2020\vector\simulator_diagram2.svg");

p1 = md"""
- Search Parameters:
  - Total System Bandwidth ($I_b$)
  - Total radiated power ($I_p$)
  - Downlink antenna size ($I_a$)
"""	
p2 = md"""
- Scenario Parameters:
  - TCoverage details 
  - Payload elements details
  - Mass & Power characterization
  - Etc.
"""	
p3 = md"""
- Platform Constraints:
  - Max antenna size - $C_s$
  - Max platform mass - $C_m$
  - Max platform power - $C_p$
  - Max OBP ports - $C_o$
  - Etc.
"""	
	id = "b" * (uuid4() |> string)
@htl """
<div class="f1">
	$l1
	$img
</div>
<div class="f1">
	$p1
	$p2
	$p3
</div>
<script>
const d = currentScript.parentElement.closest('div.raw-html-wrapper')
d.setAttribute('id',$id)
</script>
<style>
div#$id {
	display: block;
}
	
div#$id div.f1 {
	display: flex;
	//width: 80%;
	margin-bottom: 1em;
}


div#$id div.f1 img {
	flex: 1 0 auto;
	height: 240px;
	align-self: center;
}

div#$id div.f1 .markdown {
	flex: 1 1 auto;
	margin-right: 2em;
}

body.presentation div#$id li p{
	font-size: 2em;
	margin-bottom: 1.5em;
}
body.presentation div#$id li li p{
	font-size: 1.2em;
	margin-bottom: 1em;
}
body.presentation div#$id li li li p{
	font-size: 1em;
	margin-bottom: .7em;
}
body.presentation div#$id{
	text-align:left;
}
</style>
"""
end

# ╔═╡ f466c3c8-8ac9-48bc-b81e-0964f01d9452
md"""
# Real Examples
"""

# ╔═╡ efdb8586-6b50-4392-938a-e4c5bb94ec3c
toc_heading("Functions",3;hide=true)

# ╔═╡ Cell order:
# ╠═1b676488-3a39-4fbc-b226-38ecd6585e9a
# ╠═d4e4d4f7-5325-4e95-a817-60ebdfe7c091
# ╠═e7b1b722-bcf0-4aef-b1e2-160efeaef1fa
# ╠═a305df41-a3d4-4d70-9c30-a0d8fee105f9
# ╠═63b622a0-dec0-11eb-1696-cb9ce54eaa95
# ╠═5df49da5-ecef-49c9-bc4b-ab13f2b5a95c
# ╠═d0e32469-82e3-4e83-8fb9-93e1822afe82
# ╠═fed7f33f-7d58-4eae-9d0d-4cc0d6274001
# ╠═580a8aa4-de0e-4073-9859-e1db07f0ec0a
# ╠═5fb17e6c-2d74-4a9d-a767-f4d44fa47e96
# ╟─253ef5d5-2222-4e07-b128-d01187994316
# ╟─bc5f2848-0a72-47f5-9125-4990ed59a2b7
# ╟─82805fd4-bb3d-4fda-af9f-d7712c7cfa75
# ╟─70a2bf9d-c96c-475d-9ba1-eb5d2c27e210
# ╟─4aaa6ab1-bde2-4707-931d-65378aa620ad
# ╟─daa95ebc-e186-43c7-95ae-06a67affd214
# ╟─5490f8a2-635b-4dfa-8f4c-86f3d0225f3a
# ╟─adf6844a-11ab-44af-bf5c-b55856fd9409
# ╟─e74d4ada-a1c1-40ef-ba9e-cda74433dd18
# ╠═fa41ded8-5e6e-4ed7-81bd-ece427057cc9
# ╠═65c3cb2b-2fe1-46d2-87be-cbec551cb616
# ╠═a346568a-d0ff-4783-9922-ec6d4bf0b58c
# ╠═3e98f50c-2470-4ff2-962f-9b147c680ae5
# ╠═8ffa26a3-4cbe-4555-a777-04e4a1bb3743
# ╠═acea80b8-9a66-47ae-a216-fc3bea2e7ef2
# ╠═e21cbf28-0e3e-4d82-8617-30be11795e91
# ╠═abeb1b11-be79-461a-9fa7-522ef8f09b51
# ╟─fdfeebc6-bd9d-4ad6-a907-c8514e5e59bc
# ╟─9e7f7f60-c326-4216-b3a4-1b3362b60199
# ╟─2ad76af4-349c-43a5-a377-0715b9a02633
# ╟─1d0fbf83-8a60-4838-b60b-54ca8d62014a
# ╠═4b909553-2027-4eeb-b970-5ce6b2dea1f0
# ╠═dae3c053-86e9-4ec4-b287-d5344028e893
# ╟─65d7a66b-170b-497a-b1ad-d587f75a8d63
# ╠═bfaf7d01-2b9c-4d89-8a3b-411c84cdd764
# ╠═036a6b57-1c6a-4597-b661-cc74d16ee7cc
# ╠═b668b988-dc44-44a7-bddc-3bbe9e5c33a9
# ╠═5b173882-2fde-48e5-8e7f-a01531808ff0
# ╠═173dd761-b164-40cf-920f-5920078c4667
# ╠═dce1478a-3f2a-4a25-8f3a-541792ea1c16
# ╠═45359d52-8a96-4280-a1e6-e15cffc42f09
# ╠═516a71e6-6bfb-4074-a2fe-c4be0a10b4c0
# ╟─ed539a7e-7e99-482a-9c67-a5a4f92e3066
# ╟─7aae9577-232f-4e62-875f-6d5257d2d0fb
# ╟─44d7fe61-02dc-41bb-acd0-fd3339815966
# ╟─bc4aa363-049c-4070-9523-d209f46b3666
# ╟─55ae59fb-afef-4ae3-a850-e9eaaee9da65
# ╟─d2e195c2-8489-47d8-a621-381cdb60bacc
# ╠═30cdc005-fbc2-4622-9efb-bfb471851a5d
# ╟─70d1f9e0-c889-47af-98dc-fa9d53f98c2c
# ╠═270b5113-81e4-47df-a147-b72500e72e20
# ╟─f466c3c8-8ac9-48bc-b81e-0964f01d9452
# ╟─efdb8586-6b50-4392-938a-e4c5bb94ec3c
