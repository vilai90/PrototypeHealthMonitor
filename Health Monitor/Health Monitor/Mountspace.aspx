<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Mountspace.aspx.cs" Inherits="Health_Monitor.Mountspace" %>

<!DOCTYPE html>

<meta http-equiv="X-UA-Compatible" content="IE=edge" />

<html xmlns="http://www.w3.org/1999/xhtml">
    
<head id="Head1" runat="server">
    <title>StorageReport</title>
</head>

    <form id="Form1" runat="server" style="margin: auto; min-height:600px; height:100%; min-width:800px; width:100%;" >
    
        <h1>Server Storage</h1>
        
        <asp:label runat="server" text="Enter Number of Desired Pie Charts and Click 'Go':"></asp:label>
       
         <input type="text" id="numberBox" />
        
        <input type="button" id="goBtn" runat="server" onclick="goBtnOnClick()" value="Go">
        
        <asp:label runat="server" text="Note: Click on charts to display line graph."></asp:label>

        <Panel ID="PieChartPanel" runat="server" style="display:block;">   
           
        </Panel>
             
      <table>
          <tr>
         <td  >
           <Panel ID="LegendPanel" runat="server">
                         <td style="text-align: left">
                            <br />
                            <table>
                                <tr>
                                    <td>Free<br />
                                        <asp:Label ID="LightBlue" runat="server" BackColor="LightBlue" Width="40" Height="40" BorderWidth="2"></asp:Label>
                                    </td>
                                    <td>90%+<br />
                                        <asp:Label ID="Orange" runat="server" BackColor="#ff7f0e" Width="40" Height="40" BorderWidth="2"></asp:Label>
                                    </td>
                                    <td>95%+<br />
                                        <asp:Label ID="Red" runat="server" BackColor="#d62728" Width="40" Height="40" BorderWidth="2"></asp:Label>
                                    </td>
                                </tr>
                            </table>
                                </td>
                        </Panel>
              </td>

           </tr>

         </table>
        
        <Panel ID="StatusChartPanel"  runat="server">
      
        <div id="lineChart"  style="background-color:white; border:solid; width:1000px; height:500px; display:none;" onclick="hideChart()">          
                <svg id="visualisation"></svg>                    
            </div>
        </Panel> 

        <input type ="hidden" name ="__EVENTTARGET" value ="">
        <input type ="hidden" name ="__EVENTARGUMENT" value =""> 
        
    </form>

</html>

<script src="Scripts/d3.js" charset="utf-8"></script>
<script type="text/javascript">

    var charts = [<%=jscharts%>]; //string array that holds the values for all the pie charts
    
    
    charts.forEach(SetUpCharts); //display all pie charts
    

    function SetUpCharts(chart) {
        var w = 200;
        var h = 200;
        var r = h / 3;

        var vis = d3.select(chart.name).append("svg:svg").data([chart.source]).attr("width", w).attr("height", h).append("svg:g").attr("transform", "translate(" + r + "," + r + ")");
        var pie = d3.layout.pie().value(function (d) { return d.value; });

        // declare an arc generator function
        var arc = d3.svg.arc().outerRadius(r);

        // select paths, use arc generator to draw
        var arcs = vis.selectAll("g.slice").data(pie).enter().append("svg:g").attr("class", "slice");

        arcs.append("svg:path")

            .attr("fill", function (d, i) {

                if (d.data.label.indexOf('free') > -1) {
                    i = "lightblue";
                    return i;
                }

                if (d.data.value >= 90 && d.data.value < 95) {
                    i = "#ff7f0e";
                    return i;
                }
                else if (d.data.value >= 95) {
                    i = "#d62728";
                    return i;
                }
                else {
                    i = "#1f77b4";
                    return i;
                }

            })
            .attr("d", function (d) {
                // log the result of the arc generator to show how cool it is :)
                console.log(arc(d));
                return arc(d);
            });

        // add the text
        arcs.append("svg:text").attr("transform", function (d) {
            d.innerRadius = 0;
            d.outerRadius = r;
            return "translate(" + arc.centroid(d) + ")";
        }).attr("text-anchor", "middle").text(function (d, i) {
            return chart.source[i].label;
        }
                );
    }

    function displayChart(chartname, lineChartData) { //sets up line chart

        d3.select('#visualisation').remove();
        d3.select('#lineChart').append("svg")
        .attr("id", "visualisation")
        .attr("style", "height: 100%; width:100%;");

        lineChart.style.display = 'inline-block';
        
        
        var vis = d3.select('#visualisation'),
    WIDTH = lineChart.clientWidth,
    HEIGHT = lineChart.clientHeight - 150,
    MARGINS = {
        top: HEIGHT / 5,
        right: WIDTH / 7,
        bottom: HEIGHT / 5,
        left: WIDTH / 7
    },
    xRange = d3.scale.linear().range([MARGINS.left, WIDTH - MARGINS.right]).domain([d3.min(lineChartData, function (d) {
        return d.x;
    }), d3.max(lineChartData, function (d) {
        return d.x;
    })]),
    yRange = d3.scale.linear().range([HEIGHT - MARGINS.top, MARGINS.bottom]).domain([d3.min(lineChartData, function (d) {
        return d.y;
    }), d3.max(lineChartData, function (d) {
        return d.y;
    })]),
    xAxis = d3.svg.axis()
      .scale(xRange)
      .tickSize(5)
       
        .tickSubdivide(true),

    yAxis = d3.svg.axis()
      .scale(yRange)
      .orient('left')
      .tickSubdivide(true);

        vis.append('svg:g')
          .attr('class', 'x axis')
          .attr('transform', 'translate(0,' + (HEIGHT - MARGINS.bottom) + ')')
            
            .call(xAxis)
            
            .selectAll("text")
            .style("text-anchor", "end")
            .attr("dx", "-.8em")
            .attr("dy", ".15em")
            .attr("transform", function (d) {
                return "rotate(-65)"
            });

        vis.append('svg:g')
          .attr('class', 'y axis')
          .attr('transform', 'translate(' + (MARGINS.left) + ',0)')
          .call(yAxis);


        vis.append("text")
    .attr("x", MARGINS.left * 3)
    .attr("y", MARGINS.top / 2)
    .style("text-anchor", "middle")

    .text(chartname);

        var lineFunc = d3.svg.line()
  .x(function (d) {
      return xRange(d.x);
  })
  .y(function (d) {
      return yRange(d.y);
  })
  .interpolate('linear');

        vis.append('svg:path')

  .attr('d', lineFunc(lineChartData))
  .attr('stroke', 'blue')
  .attr('stroke-width', 2)
  .attr('fill', 'none');
    }


    function hideChart() { //onClick for lineChart. Will hide lineChart and set selected pieChart background color to original default
        lineChart.style.display = 'none';
       
    }

    function goBtnOnClick() {
      
        __doPostBack("Start", document.getElementById("numberBox").value);
        
    }

    function __doPostBack(eventTarget, eventArgument) {
        Form1.__EVENTTARGET.value = eventTarget;
        Form1.__EVENTARGUMENT.value = eventArgument;
        Form1.submit();
    }

    </script>