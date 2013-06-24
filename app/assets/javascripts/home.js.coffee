# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$(document).ready ->
  $.ajax 'data.json',
    success: (data, status, xhr) ->
      color = d3.rgb(0,0,0)
      bodySelection = d3.select("body")
      svgSelection = bodySelection.append("svg")
                            .attr("width", 1200)
                            .attr("height", 800)
      gasData = data.dates

      circles = svgSelection.selectAll("circle")
                          .data(gasData)
                          .enter()
                          .append("circle")
      circleAttributes = circles
                       .attr("cx", (d,index) -> return index * 2)
                       .attr("cy", (d) -> return 800)
                       .attr("r", (d) -> return 0)
                       .style("fill", color)
                       .style("opacity",0.4)
      circles.transition()
                       .delay((d,index) ->index * 10)
                       .attr("cx", (d,index) -> return index * 2)
                       .attr("cy", (d) -> return 800/d.price)
                       .attr("r", (d) -> return d.price*5)
                       .style("fill", color)
                       .style("opacity",0.4)

    error: (xhr, status, err) ->
      console.log("nah "+err)
    complete : (xhr, status) ->
      console.log("comp")
