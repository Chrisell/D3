# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$(document).ready ->
  $.ajax 'data.json',
    success: (data, status, xhr) ->
      colors = d3.scale.linear().domain([1,100]).range(['yellow','red'])
      bodySelection = d3.select("body")
      svgSelection = bodySelection.append("svg")
                            .attr("width", 1200)
                            .attr("height", 800)
      gasData = data.dates

      circles = svgSelection.selectAll("circle")
                          .data(gasData)
                          .enter()
                          .append("rect")
      circleAttributes = circles
                       .attr("x", (d,index) -> return index * 2)
                       .attr("y", 800)
                       .attr("width", 2)
                       .attr("height",0)
                       .style("fill", 'white')
                       .style("opacity",0.4)
      circles.transition()
                       .delay((d,index) ->index * 10)
                       .attr("x", (d,index) -> return index * 2)
                       .attr("height", (d) -> return 800-(800/d.price))
                       .attr("y", (d) -> return 800/d.price)
                       .attr("width", 2)
                       .style("fill", (d) -> colors(Math.round(d.price*20)))
                       .style("opacity",0.4)

    error: (xhr, status, err) ->
      console.log("nah "+err)
    complete : (xhr, status) ->
      console.log("comp")
