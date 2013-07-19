# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$(document).ready ->
  if ($('.bars').length > 0)
    $.ajax 'orders.json',
    success: (data, status, xhr) ->
      nested_data = d3.nest()
              .key( (d) -> return d.id)
              .entries(data.result)
      console.log(nested_data)
      svgHeight = 600
      nested_data.forEach((s) ->
        s.median = d3.sum(s.values, (d) -> return d.balance)
      )

      myMouseOverFunction = ->
        circle = d3.select(this)
        circle.transition().style('fill','white')
        circleData = d3.select(this).data()
        d3.select(".infobox").style("display", "block")
        d3.select("p").text("The total of the order was $" + circleData[0].values[0].balance)
      myMouseOutFunction = ->
        circle = d3.select(this)
        circle.transition().style("fill", (d) -> colors(Math.round(d.values[0].balance*20)))
        d3.select(".infobox").style("display", "none")

      myMouseMoveFunction = ->
        infobox = d3.select(".infobox")
        infobox.transition()
        .style("left", (this.getAttribute('x') - 100) + 'px')
        .style("top", (this.getAttribute('y') - 40) + 'px')

      colors = d3.scale.linear().domain([1,100]).range(['yellow','red'])

      bodySelection = d3.select("body")

      svgSelection = bodySelection.append("svg")
                            .attr("width", 1200)
                            .attr("height", svgHeight)


      circles = svgSelection.selectAll("rect")
                          .data(nested_data)
                          .enter()
                          .append("rect")
                          .on('mousemove', myMouseMoveFunction)

      circleAttributes = circles
                       .attr("x", (d,index) -> return index * 2)
                       .attr("y", svgHeight)
                       .attr("width", 2)
                       .attr("height",0)
                       .style("fill", 'white')
                       .on("mouseout", myMouseOutFunction)
                       .on("mouseover", myMouseOverFunction)

      circles.transition()
                       .delay((d,index) ->index * 10)
                       .attr("x", (d,index) -> return index * 2)
                       .attr("height", (d) -> return svgHeight-(svgHeight/d.values[0].balance))
                       .attr("y", (d) -> return svgHeight/d.values[0].balance)
                       .attr("width", 2)
                       .style("fill", (d) -> colors(Math.round(d.values[0].balance*20)))

    error: (xhr, status, err) ->
      console.log("nah "+err)
    complete : (xhr, status) ->
      console.log("comp")
