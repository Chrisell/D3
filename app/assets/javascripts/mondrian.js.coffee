# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$(document).ready ->
  if ($('.mondrian').length > 0)
    $.ajax 'companies.json',
      success: (data,status,xhr) ->
        height = width = 400
        eleFactor = (Math.random()*width) + 1
        eleWidth = width - eleFactor
        colors =['yellow','red','blue','white']
        gasData = data.companies

        bodySelection = d3.select("body")

        svgSelection = bodySelection.append("svg")
                              .attr("width", width)
                              .attr("height", height)


        circles = svgSelection.selectAll("rect")
                            .data(gasData)
                            .enter()
                            .append("rect")

        circleAttributes = circles
                         .attr("x", (d,index) ->
                           if ((index + 2) % 2 == 0)
                             return 0
                           else
                             return eleWidth
                         )
                         .attr("y", (d,index) ->
                           if (index < 2)
                             return d.percent/100*400
                           else
                             console.log(circles[index-2])

                         )
                         .attr("height", (d) -> return (d.percent/100)*400)
                         .attr("width", (d,index) ->
                           if ((index + 2) % 2 == 0)
                             return eleWidth
                           else
                             return eleFactor
                         )
                         .style("fill", (d,index) -> return colors[index])
                         .style("stroke", "black")
                         .style("stroke-width", "5")

      error: (xhr, status, err) ->
        console.log("nah "+err)
      complete : (xhr, status) ->
        console.log("comp")


