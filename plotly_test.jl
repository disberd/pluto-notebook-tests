### A Pluto.jl notebook ###
# v0.14.7

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

# ╔═╡ f0d2c987-d197-4ba6-ad6c-73a86abea6bb
using PlotlyBase, HypertextLiteral

# ╔═╡ da36057c-227f-4970-a86f-266008dccdb1
using PlutoUI

# ╔═╡ 17d68c7d-b785-4274-8397-4f84ad55bdcb
p = let
	n = 200
	r = LinRange(1e-4,10,n)
	k = LinRange(0,2π,n)
	g = r * cos.(k)'
	f = r * sin.(k)'
	z = @. (g^2 * f^2) / (g^4 + f^4)
	Plot(surface(x=g,y=f,z=z))
end;

# ╔═╡ 3204aa8e-98e2-4edf-90f2-8989a3ee8492
function Base.show(io::IO, mimetype::MIME"text/html", p::PlotlyBase.Plot)
	show(io,mimetype,@htl("""
<script src='https://cdn.plot.ly/plotly-latest.min.js'></script>
	<div style="height: auto">
		<script id=plotly-show>
			const PLOT = this ?? document.createElement("div");
			(this == null ? Plotly.newPlot : Plotly.react)(PLOT,$(HypertextLiteral.JavaScript(json(p))));
			return PLOT
		</script>
	</div>
"""))
end

# ╔═╡ 3e7b639c-6ac7-4ee5-afbc-cac27dfd10c0
@bind default_show Clock(1.5)

# ╔═╡ 8a36d119-b382-43df-9ec5-9332b88bb5b4
default_show; p

# ╔═╡ 77e75c21-6e23-42e0-af3e-add446b5ae25
show1(p) = @htl("""	
	<script src='https://cdn.plot.ly/plotly-latest.min.js'></script>
	<div style="height: auto">
		<script id=show1>
		const PLOT = this ?? document.createElement("div");
	  (this == null ? Plotly.newPlot : Plotly.react)(PLOT,$(HypertextLiteral.JavaScript(json(p))));
		return PLOT
		</script>
	</div>
""")

# ╔═╡ b7d3cc4d-a11e-4d56-877a-10ab0b44f75e
begin
	# Custom abstract-trace array to string function
TraceData(data::Array{<:AbstractTrace}) = join(["[",join(string.(data),","),"]"])

show2(p) = @htl("""
	<script src='https://cdn.plot.ly/plotly-latest.min.js'></script>
	<div style="height: auto">
		<script id=show2>
		const PLOT = this ?? document.createElement("div"); // currentScript.parentElement.firstElementChild;
			(this == null ? Plotly.newPlot : Plotly.react)(PLOT,$(HypertextLiteral.JavaScript(TraceData(p.data))),$(HypertextLiteral.JavaScript(string(p.layout))));
		return PLOT
		</script>
	</div>
""")
end

# ╔═╡ 2e56d16d-755d-49a3-b0c6-0556853fcecd
begin
	
plotlylower(x) = x
		plotlylower(x::Vector{<:Number}) = x
		plotlylower(x::AbstractVector) = Any[plotlylower(z) for z in x]
		plotlylower(x::AbstractMatrix) = Any[plotlylower(r) for r in eachrow(x)]
		plotlylower(d::Dict) = Dict(
			k => plotlylower(v)
			for (k,v) in d
		)
	
	show3(plt) = @htl("""
			<div>
			<script id=asdf>
			const PLOT = this ?? document.createElement("div"); // currentScript.parentElement.firstElementChild;
			(this == null ? Plotly.newPlot : Plotly.react)(PLOT, $(HypertextLiteral.JavaScript(Main.PlutoRunner.publish_to_js(plotlylower((map(plt.data) do x x.fields end))))),$(HypertextLiteral.JavaScript(Main.PlutoRunner.publish_to_js(plotlylower(plt.layout.fields)))));
				return PLOT
			</script>
			</div>
	""")
end

# ╔═╡ 0526b2d9-58f0-4479-a4f9-c84321876f4e
@bind tick1 Clock()

# ╔═╡ fb68fae6-d91c-4edb-882b-78353346c279
tick1; show1(p)

# ╔═╡ bc33a205-f0f4-4b0b-ab9a-8ae34deb6b25
@bind tick2 Clock(1.5)

# ╔═╡ 67c8bb53-8593-4f1c-af5a-fada76f8bb7e
tick2; show2(p)

# ╔═╡ bcb128fb-bb96-4920-9818-d063af042d47
@bind tick3 Clock(1.5)

# ╔═╡ d086445e-1e61-47a0-924a-6a7c7ef13371
tick3; show3(p)

# ╔═╡ Cell order:
# ╠═f0d2c987-d197-4ba6-ad6c-73a86abea6bb
# ╠═da36057c-227f-4970-a86f-266008dccdb1
# ╠═17d68c7d-b785-4274-8397-4f84ad55bdcb
# ╠═3204aa8e-98e2-4edf-90f2-8989a3ee8492
# ╠═3e7b639c-6ac7-4ee5-afbc-cac27dfd10c0
# ╠═8a36d119-b382-43df-9ec5-9332b88bb5b4
# ╠═77e75c21-6e23-42e0-af3e-add446b5ae25
# ╠═b7d3cc4d-a11e-4d56-877a-10ab0b44f75e
# ╠═2e56d16d-755d-49a3-b0c6-0556853fcecd
# ╠═0526b2d9-58f0-4479-a4f9-c84321876f4e
# ╠═fb68fae6-d91c-4edb-882b-78353346c279
# ╠═bc33a205-f0f4-4b0b-ab9a-8ae34deb6b25
# ╠═67c8bb53-8593-4f1c-af5a-fada76f8bb7e
# ╠═bcb128fb-bb96-4920-9818-d063af042d47
# ╠═d086445e-1e61-47a0-924a-6a7c7ef13371
