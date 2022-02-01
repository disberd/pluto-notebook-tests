### A Pluto.jl notebook ###
# v0.14.8

using Markdown
using InteractiveUtils

# ╔═╡ c2b4c427-e0d0-465b-8195-66eb15d93a72
using PlutoDevMacros

# ╔═╡ 64a29f5e-3334-43bb-a23f-8bfda53af1a4
using HypertextLiteral

# ╔═╡ edd55419-df8a-45a5-8342-950749ae8980
@htl """
<script>
const h = document.createElement('h1')
h.innerText = 'Helper Functions'
const cell = currentScript.parentElement.closest('pluto-cell')
cell.toggleAttribute('hide-heading')
return h
</script>
"""

# ╔═╡ 5e2f2d6b-949e-4b91-af0a-0a6baf23d00e
"""
Generate headings with optional classes to interface with the custom ToC defined in this notebook.

All cells before the first Heading are hidden by default, as they usually contain initialization steps

# Arguments:

`text::String` : Text that will be included in the heading

`level::Int` : Level of the heading, from 1 to 6

# Keyword Arguments

`hide::Bool` : Set to true to have a heading appear hidden in the ToC (and in the notebook if the ToC title is clicked while pressing alt), defaults to false

`collapse::Bool`: Set to true to have a heading (and all its children) appear collapsed in the ToC
"""
function toc_heading(text,level::Int;hide=false,collapse=false) 
	tag = "h$level"
	attribute_names = []
	hide && (push!(attribute_names,"hide-heading"))
	collapse && (push!(attribute_names,"collapse"))
	attributes = join(attribute_names," ")
	@htl """
	<script>
		const cell = currentScript.parentElement.closest('pluto-cell')
		const h = document.createElement($tag)
		h.innerText = $text
		cell.toggleAttribute('hide-heading',$hide)
		cell.toggleAttribute('collapsed',$collapse)
		if (cell.classList.contains('show_input'))	cell.querySelector('pluto-shoulder button').click()
		return h
		
	</script>
	"""
end

# ╔═╡ 3ea419e5-f70c-404f-813d-be8cfad99b79
toc_heading("Asd",2,hide=true,collapse=true)

# ╔═╡ 561c2bcf-d405-4e46-bd9d-c74500995a94
md"""
### Gesu
"""

# ╔═╡ d5eccf35-9aa6-48b4-9140-7ccb5d311820
toc_heading("Test1",1;collapse=true)

# ╔═╡ d1784dd2-9a25-4add-90a8-121f1e2620e6
@htl """
<script>
const h = document.createElement('h2')
h.innerText = 'Test2'
const cell = currentScript.parentElement.closest('pluto-cell')
cell.removeAttribute('collapsed')
return h
</script>
"""

# ╔═╡ 1228ed04-b62f-4703-9e5d-e1f5cb0bf640
md"""
### Test3
"""

# ╔═╡ 358d4034-20c6-4746-8c37-f91e79a369eb
md"""
## Test22
"""

# ╔═╡ fa4699bb-78b0-43e9-9889-536af90af45b
toc_heading("ToC Definition",1,hide=true)

# ╔═╡ 9429e332-6543-4a1a-94d6-9c3733712b5c
toc_heading("Julia Strcut",2;hide=true)

# ╔═╡ 25b4cb5d-504f-4922-9923-7668f83dcc2f
md"""
The documentation of the function has to be updated
"""

# ╔═╡ 62f4b572-c28b-4f33-b1ac-355f147cbc24
js(x) = HypertextLiteral.JavaScript(x)

# ╔═╡ 08ea2095-cdf3-4f3c-8dd7-792245ac6e56
toc_heading("Javascript Code",2,hide=true)

# ╔═╡ 2aa06b9e-34cf-43de-8559-88ff9707216d
md"""
!!! note
	The curent implementations creates a lot of re-renders.
	Try improving it with better react-fu in the future
"""

# ╔═╡ 0b832124-aca0-4172-9121-8f41c3c34bc8
toc_heading("Main JS that includes the preact components",3,hide=true)

# ╔═╡ e2307fb5-f3f8-482f-abae-5509bf48fe2d
toc_heading("ToC Element Component Definition",3;hide=true)

# ╔═╡ 8b20a786-7020-4252-8e42-ffbd33fb19e4
ItemDef = """
const Item = ({text, hidden, hide, id, onClick, depth, collapsed, collapsed_parent, children}) => {
	if (collapsed_parent || (hidden && hide)) return null


let div_attrs = {
		class: hidden ? "hidden" : "",
		onClick: (e) => onClick(e,id),
		collapsed: collapsed && (children.length > 0),
	}
let a_attrs = {
		href: `#\${id}`,
		class: `toc-row H\${depth}`,
	}

	return html`<div ...\${div_attrs}><a ...\${a_attrs}>\${text}</a></div>`
}
""";

# ╔═╡ 71a2347d-fb17-4c12-8298-9d07511ffb05
toc_heading("""
Main ToC Preact class
""",3,hide=true)

# ╔═╡ 028c5069-fc3d-48a0-84e1-476689539f2c
TocDef = toc -> """
const Toc = () => {

	// console.log('toc_id:',toc_id)

	const getHeaderState = () => {
		const depth = Math.max(1, Math.min(6, $(toc.depth))) // should be in range 1:6
		const range = Array.from({length: depth}, (x, i) => i+1) // [1, ..., depth]
		
		const selector = range.map(i => `pluto-notebook pluto-cell h\${i}`).join(",")
		const initialArray = Array.from(document.querySelectorAll(selector), (item) => {
			const cell = item.closest('pluto-cell')
			return {
				id: cell.id,
				title: item.innerText,
				hidden: cell.hasAttribute('hide-heading') ? true : false,
				collapsed: cell.hasAttribute('collapsed') ? true : false,
				collapsed_parent: false,
				depth: Number(item.tagName[1]),
				children: [],
			}
		})
		return collapseDependency(initialArray)
	}

	const collapseDependency = (initialArray) => 	{
		// Create an array that contains the current parent for each level
		const iterArray = new Array($(toc.depth))
		const parentIdx = () => {
			const idx = _.findLastIndex(iterArray,x => x != undefined)
			// return idx == -1 ? $(toc.depth) : idx
			return idx
		}
		let currentParentLevel = parentIdx()
		initialArray.forEach((element,n) => {
			// Populate children
			// console.log('iter: ',n,'currentParent =',currentParentLevel,'depth:',element.depth)
			while (element.depth <= (currentParentLevel + 1)) {
				// Close parents with dephts up to the same of the element 
				iterArray[currentParentLevel] = null
				// console.log('prevParent: ',currentParentLevel)
				currentParentLevel = parentIdx()
				// console.log('nextParent: ',currentParentLevel)
			}
			// push the current element as child of the parent
			if (currentParentLevel >= 0) {
				iterArray[currentParentLevel].children.push(n)
				// console.log('children:',iterArray[currentParentLevel])
			}
			iterArray[element.depth - 1] = element
			// Check if the parent is collapsed
			let collapsed_parent = false
			if (collapseAll == 0) {
			console.log('standard-collapse')
			iterArray.forEach((x,nn) => {
				// Check each parent from the highest to the lower
				if (x == undefined || x === element || collapsed_parent) return
				collapsed_parent = collapsed_parent || x.collapsed
			})
		} else {
			collapsed_parent = element.depth == 1 ? false : collapseAll == 1
		}
			console.log('forced-collaps:',collapsed_parent)
			element.collapsed_parent = collapsed_parent
			currentParentLevel = parentIdx()

		});
		// console.log(initialArray)
		return initialArray
	}

	node.getHeaderState = getHeaderState

	const [hide,set_hide] = useState(false)
	const [collapseAll,set_collapseAll] = useState(0)
	const [state, set_toc_state] = useState(getHeaderState())
	const [collapseToc, set_collapseToc] = useState(false)
	node.set_toc_state = set_toc_state

	const hideCells = () => {
		
		const cell_order = window.editor_state.notebook.cell_order

		if (!hide) {
			cell_order.forEach(id => {
				const cell = document.getElementById(id)
				cell.removeAttribute('hidden')
			})
			return
		}

		// hide at default the cells before the first heading
		let hide_this = true
		let next_id = state[0].id
		let next_hindex = 0
		const hlength = state.length
		
		// Loop through all the cells and hide if the previous heading is flagged as hidden
		cell_order.forEach((id,n) => {

			if (id === next_id) {
				// console.log(n)
				hide_this = state[next_hindex].hidden
				next_hindex += 1
				next_id = next_hindex >= hlength ? '' : state[next_hindex].id
			}

			const cell = document.getElementById(id)
			const cm = cell.querySelector('.CodeMirror').CodeMirror
			if (hide_this && id != toc_id && cm.getValue() !== "") {
				cell.setAttribute('hidden',"")
			} else {
				cell.removeAttribute('hidden')
			}
		})
		
	}

	node.hideCells = hideCells

	useEffect(() => {
		hideCells()
	}
	)

	useEffect(() => {
		set_toc_state(getHeaderState())
	},[collapseAll]
	)

	const customClick = (e,id) => {
		const cell = document.getElementById(id)
		if (e.altKey) {
			e.preventDefault()
			cell.toggleAttribute('hide-heading')
			set_toc_state(oldState => {
				return getHeaderState()
			}
			)
		}
		if (e.ctrlKey) {
			e.preventDefault()
			cell.toggleAttribute('collapsed')
			set_toc_state(oldState => {
				return getHeaderState()
			}
			)
			set_collapseAll(0)
		}
	}

	const headerClick = (e) => {
		console.log(e)
		if (e.altKey) {
			e.preventDefault()
			set_hide(!hide)
			return
		}
		if (e.ctrlKey) {
			e.preventDefault()
			const newVal = collapseAll == 1 ? -1 : 1
			set_collapseAll(newVal)
			return
		}
		// e.preventDefault()
		set_collapseToc(!collapseToc)
	}

	const extractProps = item => ({
		hidden: item.hidden,
		text: item.title,
		id: item.id,
		key: item.id,
		onClick: customClick,
		hide: hide,
		depth: item.depth,
		collapsed: collapseAll === 0 ? item.collapsed : collapseAll == 1,
		collapsed_parent: item.collapsed_parent,
		children: item.children,
	})




	return  html`
	<mytag class='$(join(filter(x -> x isa String,(
		"plutoui-toc",
		toc.aside && "aside",
		toc.indent && "indent",
		))," "))\${collapseToc ? " collapse-toc" : ""}'>
	<header onClick=\${headerClick} class=\${hide ? "" : "show-hidden"}><span class="text">$(toc.title)</span><span class="filler"></span></header>
	<section>
		\${
		state.map(x => html`<\${Item} ...\${extractProps(x)}/>`)
		}
	</section>
	</mytag>`;
}
""";

# ╔═╡ 759e0c40-cea7-4c62-8123-179a97becc40
toc_js = toc -> """
const { html, render, Component, useEffect, useLayoutEffect, useState, useRef, useMemo, createContext, useContext, } = await import( "https://cdn.jsdelivr.net/npm/htm@3.0.4/preact/standalone.mjs")

const node = this ?? document.createElement("div")

const notebook = document.querySelector("pluto-notebook")


const toc_id = currentScript.parentElement.closest('pluto-cell').id


if(this == null){

	// PREACT APP STARTS HERE
	
$ItemDef

$(TocDef(toc))

	// PREACT APP ENDS HERE

render(html`<\${Toc}/>`, node);

// console.log('if')

}

const updateCallback = () => {
	const test = node.getHeaderState()
	node.set_toc_state(test)
}


// We have a mutationobserver for each cell:
const observers = {
	current: [],
}

const createCellObservers = () => {
	observers.current.forEach((o) => o.disconnect())
	observers.current = Array.from(notebook.querySelectorAll("pluto-cell")).map(el => {
		const o = new MutationObserver(updateCallback)
		o.observe(el, {attributeFilter: ["class"]})
		return o
	})
}
createCellObservers()

// And one for the notebook's child list, which updates our cell observers:
const notebookObserver = new MutationObserver(() => {
	updateCallback()
	createCellObservers()
})
notebookObserver.observe(notebook, {childList: true})

// And finally, an observer for the document.body classList, to make sure that the toc also works when if is loaded during notebook initialization
const bodyClassObserver = new MutationObserver(updateCallback)
bodyClassObserver.observe(document.body, {attributeFilter: ["class"]})

invalidation.then(() => {
	notebookObserver.disconnect()
	bodyClassObserver.disconnect()
	observers.current.forEach((o) => o.disconnect())
})

return node
"""

# ╔═╡ 9784edff-a6ac-4308-a1af-71fedd1f2096
toc_heading("CSS",3,hide=true)

# ╔═╡ 844f74f6-d59a-4651-866b-fd1bd2dbfc3c
toc_style = """

.plutoui-toc div.hidden a {
	background-color: rgba(0, 0, 0, 0.1);
}


.plutoui-toc header {
	display: flex;
	font-size: 1.5em;
	margin-top: 0.67em;
	margin-bottom: 0.67em;
	margin-left: 0;
	margin-right: 0;
	font-weight: bold;
	border-bottom: 2px solid rgba(0, 0, 0, 0.15);
}
.plutoui-toc header.show-hidden span.text {
	color: rgba(0, 0, 0, 0.4);
	background-color: rgba(0,0,0,0.1)
}
.plutoui-toc header span.filler {
	flex: 1 1 0;
}

@media screen and (min-width: 1081px) {
	.plutoui-toc.aside {
		position:fixed; 
		right: 1rem;
		top: 5rem; 
		width:25%; 
		padding: 10px;
		border: 3px solid rgba(0, 0, 0, 0.15);
		border-radius: 10px;
		box-shadow: 0 0 11px 0px #00000010;
		/* That is, viewport minus top minus Live Docs */
		max-height: calc(100vh - 5rem - 56px);
		overflow: hidden;
		z-index: 50;
		background: white;
	}
	.plutoui-toc.aside.collapse-toc header {
		margin: 0px 0px;
	}

	.plutoui-toc.aside.collapse-toc:not(:hover) {
		width: auto;
	}

	.plutoui-toc.aside.collapse-toc section {
		display: none;
	}
	.plutoui-toc.aside.collapse-toc:hover section {
		display: block;
	}

}


.plutoui-toc section .toc-row {
	white-space: nowrap;
	overflow: hidden;
	text-overflow: ellipsis;
	padding-bottom: 2px;
}

pluto-cell:not(.code_differs)[hidden] {
	display: none;
}

.plutoui-toc a {
	text-decoration: none;
	font-weight: bold;
	color: gray;
}

.plutoui-toc div[collapsed] a {
	text-decoration: underline;
}

.plutoui-toc div:hover a {
	color: black;
}

.plutoui-toc.indent a.H1 {
	margin-left: 0px;
}
.plutoui-toc.indent a.H2 {
	margin-left: 10px;
}
.plutoui-toc.indent a.H3 {
	margin-left: 20px;
}
.plutoui-toc.indent a.H4 {
	margin-left: 30px;
}
.plutoui-toc.indent a.H5 {
	margin-left: 40px;
}
.plutoui-toc.indent a.H6 {
	margin-left: 50px;
}
""";

# ╔═╡ 003a7fd4-da9c-4f72-861f-0778b98aa912
begin
	"""Generate Table of Contents using Markdown cells. Headers h1-h6 are used. 

	# Keyword arguments:
	`title` header to this element, defaults to "Table of Contents"

	`indent` flag indicating whether to vertically align elements by hierarchy

	`depth` value to limit the header elements, should be in range 1 to 6 (default = 3)

	`aside` fix the element to right of page, defaults to true

	`collapse` automatically collapse tock when not hovered on and aside==true, defaults to false

	# Examples:

	```julia
	TableOfContents()

	TableOfContents(title="Experiments 🔬")

	TableOfContents(title="📚 Table of Contents", indent=true, depth=4, aside=true)
	```
	"""
	Base.@kwdef struct ToC
		title::AbstractString="Table of Contents"
		indent::Bool=true
		depth::Integer=3
		aside::Bool=true
	end
	function Base.show(io::IO, mimetype::MIME"text/html", toc::ToC)
		show(io,mimetype,@htl """
			
<script type="module" id="asdf">
			$(js(toc_js(toc)))
			</script>
			
			<style>
			$toc_style
			</style>
			""")
	end
end

# ╔═╡ 1ca8ba46-c816-488e-b728-061288a4d75f
export ToC, toc_heading

# ╔═╡ 1a9e349a-8856-4c39-9bbf-f89001b2b8f2
@only_in_nb ToC(title="ToC")

# ╔═╡ Cell order:
# ╠═c2b4c427-e0d0-465b-8195-66eb15d93a72
# ╠═64a29f5e-3334-43bb-a23f-8bfda53af1a4
# ╠═1ca8ba46-c816-488e-b728-061288a4d75f
# ╠═1a9e349a-8856-4c39-9bbf-f89001b2b8f2
# ╠═edd55419-df8a-45a5-8342-950749ae8980
# ╠═5e2f2d6b-949e-4b91-af0a-0a6baf23d00e
# ╠═3ea419e5-f70c-404f-813d-be8cfad99b79
# ╠═561c2bcf-d405-4e46-bd9d-c74500995a94
# ╟─d5eccf35-9aa6-48b4-9140-7ccb5d311820
# ╠═d1784dd2-9a25-4add-90a8-121f1e2620e6
# ╠═1228ed04-b62f-4703-9e5d-e1f5cb0bf640
# ╠═358d4034-20c6-4746-8c37-f91e79a369eb
# ╠═fa4699bb-78b0-43e9-9889-536af90af45b
# ╠═9429e332-6543-4a1a-94d6-9c3733712b5c
# ╠═25b4cb5d-504f-4922-9923-7668f83dcc2f
# ╠═003a7fd4-da9c-4f72-861f-0778b98aa912
# ╟─62f4b572-c28b-4f33-b1ac-355f147cbc24
# ╠═08ea2095-cdf3-4f3c-8dd7-792245ac6e56
# ╠═2aa06b9e-34cf-43de-8559-88ff9707216d
# ╠═0b832124-aca0-4172-9121-8f41c3c34bc8
# ╠═759e0c40-cea7-4c62-8123-179a97becc40
# ╠═e2307fb5-f3f8-482f-abae-5509bf48fe2d
# ╠═8b20a786-7020-4252-8e42-ffbd33fb19e4
# ╠═71a2347d-fb17-4c12-8298-9d07511ffb05
# ╠═028c5069-fc3d-48a0-84e1-476689539f2c
# ╠═9784edff-a6ac-4308-a1af-71fedd1f2096
# ╠═844f74f6-d59a-4651-866b-fd1bd2dbfc3c
