# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$(document).ready ->
  $.ajax 'data.json',
    success: (data, status, xhr) ->
      myMouseOverFunction = ->
        circle = d3.select(this)
        circle.transition().style('fill','white')
        circleData = d3.select(this).data()
        d3.select(".infobox").style("display", "block")
        d3.select("p").text("The price of gas on " + circleData[0].date + " was $" + circleData[0].price)
      myMouseOutFunction = ->
        circle = d3.select(this)
        circle.transition().style("fill", (d) -> colors(Math.round(d.price*20)))
        d3.select(".infobox").style("display", "none")
      myMouseMoveFunction = ->
        infobox = d3.select(".infobox")
        console.log(infobox)
        infobox.transition()
        .style("left", (this.getAttribute('x') - 100) + 'px')
        .style("top", (this.getAttribute('y') - 40) + 'px')
      colors = d3.scale.linear().domain([1,100]).range(['yellow','red'])
      bodySelection = d3.select("body")
      svgSelection = bodySelection.append("svg")
                            .attr("width", 1200)
                            .attr("height", 600)
      gasData = data.dates

      circles = svgSelection.selectAll("circle")
                          .data(gasData)
                          .enter()
                          .append("rect")
                          .on('mousemove', myMouseMoveFunction)
      circleAttributes = circles
                       .attr("x", (d,index) -> return index * 2)
                       .attr("y", 600)
                       .attr("width", 2)
                       .attr("height",0)
                       .style("fill", 'white')
                       .on("mouseout", myMouseOutFunction)
                       .on("mouseover", myMouseOverFunction)
      circles.transition()
                       .delay((d,index) ->index * 10)
                       .attr("x", (d,index) -> return index * 2)
                       .attr("height", (d) -> return 600-(600/d.price))
                       .attr("y", (d) -> return 600/d.price)
                       .attr("width", 2)
                       .style("fill", (d) -> colors(Math.round(d.price*20)))

    error: (xhr, status, err) ->
      console.log("nah "+err)
    complete : (xhr, status) ->
      console.log("comp")
