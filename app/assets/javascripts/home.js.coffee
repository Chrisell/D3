# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$(document).ready ->
  if ($('.bars').length > 0)
    $.ajax 'orders.json',
    success: (data, status, xhr) ->

      # Constants
      svgHeight = 600
      svgWidth = 1200
      stack = d3.layout.stack()
      states = 4
      #color = d3.scale.linear().domain([1,4]).range(['blue','red'])
      color = ['red','blue','green','yellow']

      nested_data = d3.nest()
              .key( (d) -> return d.placed_at)
              .entries(data.result)


      orders_by_day = stack(d3.range(states).map(-> nested_data))

      yGroupMax = d3.max(orders_by_day, (layer) -> d3.max(layer, (d) -> return d.y ))
      yStackMax = d3.max(orders_by_day, (layer) ->  d3.max(layer, (d,i) -> return d.values))

      x = d3.scale.ordinal()
            .domain(d3.range(31))
            .rangeRoundBands([0, svgWidth], .08)

      y = d3.scale.linear()
            .domain([0, 30])
            .range([svgHeight, 0])

      console.log(nested_data)
      console.log(orders_by_day)


      bodySelection = d3.select("body")

      svg = bodySelection.append("svg")
                            .attr("width", svgWidth)
                            .attr("height", svgHeight)

      layer = svg.selectAll(".layer")
                 .data(orders_by_day)
                 .enter().append("g")
                 .attr("class", "layer")
                 .style("fill", (d, i) -> color[i] )

      rect = layer.selectAll("rect")
                  .data((d) -> d)
                  .enter().append("rect")
                  .attr("x", (d,i) -> x(i))
                  .attr("y", svgHeight)
                  .attr("width", 10)
                  .attr("height", 0)

      rect.transition()
          .delay((d, i) ->  i * 10 )
          .attr("y", (d) -> y(d.values.length))
          .attr("height", (d,i) -> d.values[0].values[i].values.length)

    error: (xhr, status, err) ->
      console.log("nah "+err)
    complete : (xhr, status) ->
      console.log("comp")
