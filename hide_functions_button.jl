### A Pluto.jl notebook ###
# v0.14.8

using Markdown
using InteractiveUtils

# ╔═╡ 496bb0c7-8dd7-42b5-80aa-9c36792e6b62
using HypertextLiteral

# ╔═╡ d42d0701-27ec-476b-a336-413f40269057
macro js(s)
	:(eval(:(@htl $$(esc(s)))) |> HypertextLiteral.JavaScript)
end

# ╔═╡ 195b0bd7-4a99-4be3-aa50-54d809a70f10
md"""
## Test 3
"""

# ╔═╡ 7b8af1e0-dc2b-11eb-0634-37cc19e4885f
md"""
### Test 3
"""

# ╔═╡ 947b5ffd-1b12-44b4-9036-f1137e0dd5f5


# ╔═╡ 8c7cb1bb-1b0d-42dd-ab30-9ee408305e68
@htl """
<script>
	const getParentCell = el => el.closest("pluto-cell")

	const generate_el = (h) => {
		const parent_cell =  getParentCell(h)

		const det = html`<details 
			class="\${h.nodeName}"
			>
			<summary><a
			href="#\${parent_cell.id}"
			>h.innerText</a>
			</summary>
			</details>
		`
	}
	const asd = html`
	<details>
	<summary><a class="h1" href="#da1e895c-0420-4ebf-a4e6-80aa3f613e86">Test</a></summary>
		<details class="h2">
		<summary><a href="#3ea630c3-c8d3-47f3-83d9-61fa1919bea9">test2</a></summary>
		Test Gesu
		</details>
	</details>`
	return asd
</script>
<style>
	details.h2 {
		padding-left: 10px;
	}

/*
details>summary {
  list-style-type: none;
  outline: none;
  cursor: pointer;
  //border: 1px solid #eee;
  //padding: 5px;
  //border-radius: 5px;
}

details>summary::-webkit-details-marker {
  display: none;
}

details>summary::before {
  content: '+ ';
}

details[open]>summary::before {
  content: '- ';
}

/*details[open]>summary {
  margin-bottom: 0.5rem;
}*/
</style>
"""


# ╔═╡ b081e5bf-3102-49a2-99b1-5e22625975c7
@htl """
<div style="display: flex;">
<h3>Gesu</h3>
<button type="button" style="flex: 1 0 10px;">Click</button>
</div>
<script>
	const parentCell = currentScript.parentElement.closest('pluto-cell')
	parentCell.setAttribute('hide_below',true)

	let style = document.createElement('style')
	style.id = 'style_' + $(Main.PlutoRunner.currently_running_cell_id[] |> string)
	style.innerHTML = `
	pluto-cell[hide_below] ~ pluto-cell {
		display: block;
	}`
	document.body.appendChild(style)

	let state = "block"

	const rule = style.sheet.cssRules[0]

	const but = currentScript.parentElement.querySelector('button')
	
	but.addEventListener('click',() => {
		state = state == "block" ? "none" : "block"
		rule.style.display = `\${state}`
	})

	invalidation.then(() => style.parentNode.removeChild(style))
</script>
"""

# ╔═╡ dee8ddbd-f958-406c-a900-f6d65bb11bc5
md"""
## Magic234341
"""

# ╔═╡ 8ddb7965-bf59-435f-b64c-922ebc04f7c8
js(x) = HypertextLiteral.JavaScript(x)

# ╔═╡ 36e73300-e191-4ad1-a29f-1d0ff4b532ae
ItemDef = """
const Item = ({text, hidden, hideAll, id, onClick, level, }) => {
let attrs = {
		href: `#\${id}`,
	}

	return html`<li><a ...\${attrs}>\${text}</a></li>`
}
""";

# ╔═╡ 9eb0857b-98a4-4905-9883-187c318b15cc
@htl """
<script>
const p = document.createElement("p")
console.log(_.random())
p.innerText = _.range(_.random(0,5),_.random(6,10))
return p
</script>
"""

# ╔═╡ 1b242613-d225-4ca8-844c-d2c11ad55d0e
TocDef = """
const Toc = () => {

	const [state, set_toc_state] = useState([])
	node.set_toc_state = set_toc_state

	const extractProps = item => ({
		hidden: item.hidden,
		text: item.title,
		id: item.id,
		key: item.id,
		//onClick: onClick,
	})


	return html`<h5>Hello world!</h5>
		<ul>\${
		state.map(x => html`<\${Item} ...\${extractProps(x)}/>`)
	}</ul>`;
}
"""

# ╔═╡ 76c39cfd-4132-40dc-8fd2-3254fdde085a
@htl("""
<script type="module" id="toc-script">
	//await new Promise(r => setTimeout(r, 1000))
	
	const { html, render, Component, useEffect, useLayoutEffect, useState, useRef, useMemo, createContext, useContext, } = await import( "https://cdn.jsdelivr.net/npm/htm@3.0.4/preact/standalone.mjs")

	const node = this ?? document.createElement("div")
	
	
	const notebook = document.querySelector("pluto-notebook")

	const getHeaderState = () => {
		const selector = 'pluto-notebook h1, h2, h3'
		return Array.from(document.querySelectorAll(selector), (item) => {
			const cell = item.closest('pluto-cell')
			return {
				id: cell.id,
				title: item.innerText,
				hidden: cell.hasAttribute('hide-heading') ? true : false
			}
		})
	}
	
	if(this == null){
	
		// PREACT APP STARTS HERE
		
	$(js(ItemDef))

	$(js(TocDef))

		// PREACT APP ENDS HERE

        render(html`<\${Toc}/>`, node);
	
	}
	
	const updateCallback = () => {
		const test = getHeaderState()
		console.log(test)
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

	invalidation.then(() => {
	observers.current.forEach((o) => o.disconnect())
})
	
	return node
</script>
	
""")

# ╔═╡ b22c17b2-1c07-4368-9001-f97d098a34dd
style_toc = """
mytoc a {
	display: block;
}

mytoc a[hidden] {
	color: #a39f9f;
}
""";

# ╔═╡ Cell order:
# ╠═496bb0c7-8dd7-42b5-80aa-9c36792e6b62
# ╟─d42d0701-27ec-476b-a336-413f40269057
# ╠═195b0bd7-4a99-4be3-aa50-54d809a70f10
# ╠═7b8af1e0-dc2b-11eb-0634-37cc19e4885f
# ╠═947b5ffd-1b12-44b4-9036-f1137e0dd5f5
# ╠═8c7cb1bb-1b0d-42dd-ab30-9ee408305e68
# ╟─b081e5bf-3102-49a2-99b1-5e22625975c7
# ╠═dee8ddbd-f958-406c-a900-f6d65bb11bc5
# ╠═8ddb7965-bf59-435f-b64c-922ebc04f7c8
# ╠═76c39cfd-4132-40dc-8fd2-3254fdde085a
# ╠═36e73300-e191-4ad1-a29f-1d0ff4b532ae
# ╠═9eb0857b-98a4-4905-9883-187c318b15cc
# ╠═1b242613-d225-4ca8-844c-d2c11ad55d0e
# ╠═b22c17b2-1c07-4368-9001-f97d098a34dd
