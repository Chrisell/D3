# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$(document).ready ->
  if ($('.bars').length > 0)
    $.ajax 'data.json',
    success: (data, status, xhr) ->
      gas = d3.nest()
              .key( (d) -> return d.date)
              .entries(data.dates)
      gas.forEach((s) ->
        s.basePrice = d3.sum(s.values, (d) -> return d.price)
      )
      gas.sort((a, b) -> return a.basePrice - b.basePrice)
      lowestPrice = gas[0].basePrice
      highestPrice = gas[gas.length - 1].basePrice
      svgHeight = 600
      $('input[type=radio]').change (e) ->
        if ($(this).val() == '1')
          circles.transition()
            .delay((d,index) ->index * 10)
            .attr("x", (d,index) -> return index * 2)
            .attr("y", (d) -> return svgHeight/d.price)
            .attr("rx", (d) -> return (d.price * 5)/2)
            .attr("ry", (d) -> return (d.price * 5)/2)
            .attr("height", (d) -> return d.price * 5)
            .attr("width", (d) -> return d.price * 5)
            .style("fill", (d) -> colors(Math.round(d.price*20)))
        else if ($(this).val() == '0')
          circles.transition()
            .delay((d,index) ->index * 10)
            .attr("x", (d,index) -> return index * 2)
            .attr("height", (d) -> return svgHeight-(svgHeight/d.price))
            .attr("y", (d) -> return svgHeight/d.price)
            .attr("width", 2)
            .style("fill", (d) -> colors(Math.round(d.price*20)))
        else if ($(this).val() == '2')
          circles.transition()
            .delay((d,index) ->index * 10)
            .attr("x", (d,index) -> return index * 2)
            .attr("height", (d) -> return svgHeight-(svgHeight/d.price))
            .attr("y", (d) ->
              console.log((svgHeight/2) + ((svgHeight-(svgHeight/d.price))/2))
              return ((svgHeight/d.price)/2)
            )
            .attr("width", 2)
            .style("fill", (d) -> colors(Math.round(d.price*20)))

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
        infobox.transition()
        .style("left", (this.getAttribute('x') - 100) + 'px')
        .style("top", (this.getAttribute('y') - 40) + 'px')

      colors = d3.scale.linear().domain([1,100]).range(['yellow','red'])
      gasData = data.dates

      bodySelection = d3.select("body")

      svgSelection = bodySelection.append("svg")
                            .attr("width", 1200)
                            .attr("height", svgHeight)


      circles = svgSelection.selectAll("rect")
                          .data(gasData)
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
                       .attr("height", (d) -> return svgHeight-(svgHeight/d.price))
                       .attr("y", (d) -> return svgHeight/d.price)
                       .attr("width", 2)
                       .style("fill", (d) -> colors(Math.round(d.price*20)))

      error: (xhr, status, err) ->
        console.log("nah "+err)
      complete : (xhr, status) ->
        console.log("comp")
