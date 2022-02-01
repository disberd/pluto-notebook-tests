### A Pluto.jl notebook ###
# v0.14.7

using Markdown
using InteractiveUtils

# ╔═╡ fa09788b-d9a6-496c-a126-4a1639211aaa
begin
	using PlotlyBase
	using HypertextLiteral
end

# ╔═╡ a08c16a0-bc90-11eb-0274-e91d841ba34e


# ╔═╡ 923df2dc-3c00-493e-aac9-fbf03bd58fe7
begin
	# Custom abstract-trace array to string function
	TraceData(data::Array{<:AbstractTrace}) = join(["[",join(string.(data),","),"]"])
	
	function Base.show(io::IO, mimetype::MIME"text/html", p::PlotlyBase.Plot)
		show(io,mimetype,@htl("""
		<script src='https://cdn.plot.ly/plotly-latest.min.js'></script>
		<div>
			<script>
			let parentnode = currentScript.parentElement
			var config = {responsive: true};
		Plotly.newPlot(parentnode,$(HypertextLiteral.JavaScript(TraceData(p.data))),$(HypertextLiteral.JavaScript(string(p.layout))),config);
			</script>
		</div>
	"""))
	end
end

# ╔═╡ 61f33995-9083-4b9e-8aeb-69f5ba8be036
show1(p) = @htl("""
		<script src='https://cdn.plot.ly/plotly-latest.min.js'></script>
		<div>
			<script>
			let parentnode = currentScript.parentElement
			var config = {responsive: true};
		Plotly.newPlot(parentnode,$(HypertextLiteral.JavaScript(TraceData(p.data))),$(HypertextLiteral.JavaScript(string(p.layout))),config);
			</script>
		</div>
	""") 

# ╔═╡ 8ece7b31-8a9b-4abc-9867-4edf17c0e038
show2(p) = @htl("""
		<script src='https://cdn.plot.ly/plotly-latest.min.js'></script>
		<div>
			<script>
			let parentnode = currentScript.parentElement
			var config = {responsive: true};
		Plotly.newPlot(parentnode,$(HypertextLiteral.JavaScript(json(p.data))),$(HypertextLiteral.JavaScript(json(p.layout))),config);
			</script>
		</div>
	""") 

# ╔═╡ 893c24c8-2db2-4562-b145-6f52f710d52b
show3(p) = @htl("""
		<script src='https://cdn.plot.ly/plotly-latest.min.js'></script>
		<div>
			<script>
			let parentnode = currentScript.parentElement
			var config = {responsive: true};
		Plotly.newPlot(parentnode,$(HypertextLiteral.JavaScript(json(p))),config);
			</script>
		</div>
	""") 

# ╔═╡ 35c4a24e-c7e9-4b37-bc95-defb25f83f87
p = Plot(GenericTrace("sunburst",Dict(
  :type => "sunburst",
  :labels => ["Eve", "Cain", "Seth", "Enos", "Noam", "Abel", "Awan", "Enoch", "Azura"],
  :parents => ["", "Eve", "Eve", "Seth", "Seth", "Eve", "Eve", "Awan", "Eve" ],
  :values =>  [50, 14, 12, 10, 2, 6, 6, 4, 0],
  :leaf => Dict(:opacity => 0.4),
  :marker => Dict(:line => Dict(:width => 1)),
  :branchvalues => "total",
)))

# ╔═╡ 88745d56-29ff-48dd-bf0f-3d80d754625e
show1(p)

# ╔═╡ 9d79e300-fddc-48de-b28e-d518f977c2ea
show2(p)

# ╔═╡ bcc03030-83fb-434a-b1ff-6adbe9d8331b
show3(p)

# ╔═╡ Cell order:
# ╠═a08c16a0-bc90-11eb-0274-e91d841ba34e
# ╠═fa09788b-d9a6-496c-a126-4a1639211aaa
# ╠═923df2dc-3c00-493e-aac9-fbf03bd58fe7
# ╠═61f33995-9083-4b9e-8aeb-69f5ba8be036
# ╠═8ece7b31-8a9b-4abc-9867-4edf17c0e038
# ╠═893c24c8-2db2-4562-b145-6f52f710d52b
# ╠═35c4a24e-c7e9-4b37-bc95-defb25f83f87
# ╠═88745d56-29ff-48dd-bf0f-3d80d754625e
# ╠═9d79e300-fddc-48de-b28e-d518f977c2ea
# ╠═bcc03030-83fb-434a-b1ff-6adbe9d8331b
