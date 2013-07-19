# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.z
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$ ->
  if ($('.inputs').length > 0)
    $('#one').keyup () ->
      value = parseInt($(@).val())
      if isNaN(value)
        value = 0
      circles.transition()
        .attr('r', value)
    colors = d3.scale.linear().domain([1,100]).range(['yellow','red'])
    nodes = d3.range(200).map( -> return {radius: Math.random() * 12 + 4};)
    root = nodes[0]
    root.radius = 0
    root.fixed = true
    w = 800
    h = 600
    bodySelection = d3.select("body")

    svg = bodySelection.append("svg:svg")
                          .attr("width", w)
                          .attr("height",h)


    circles = svg.selectAll("circle").
      data(nodes.slice(1)).
      enter().
      append("circle")


    circleAttributes = circles
                     .attr("r", (d) -> return d.radius - 2)
                     .style("fill", 'red')
    force = d3.layout.force()
    .gravity(0.05)
    .charge((d,i) -> return i ? 0 : -2000;)
    .nodes(circles)
    .size([w, h])
    force.start()

    force.on("tick", (e) ->
      q = d3.geom.quadtree(nodes)
      i = 0
      n = nodes.length

      while (++i < n)
        q.visit(collide(nodes[i]))


      svg.selectAll("circle")
          .attr("cx", (d) -> return d.x)
          .attr("cy", (d) -> return d.y)
    )

    svg.on("mousemove", ->
      p1 = d3.mouse(this)
      root.px = p1[0]
      root.py = p1[1]
      force.resume()
    )

    collide = (node) ->
      r = node.radius + 16
      nx1 = node.x - r
      nx2 = node.x + r
      ny1 = node.y - r
      ny2 = node.y + r
      return (quad, x1, y1, x2, y2) ->
        if (quad.point && (quad.point != node))
          x = node.x - quad.point.x
          y = node.y - quad.point.y
          l = Math.sqrt(x * x + y * y)
          r = node.radius + quad.point.radius
          if (l < r)
            l = (l - r) / l * .5
            node.x -= x *= l
            node.y -= y *= l
            quad.point.x += x
            quad.point.y += y
        return x1 > nx2 || x2 < nx1 || y1 > ny2 || y2 < ny1
