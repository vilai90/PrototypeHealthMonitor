using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;

namespace Health_Monitor
{
    public partial class Mountspace : System.Web.UI.Page
    {

        List<PieChart> chartList = new List<PieChart>(); //list that contains each generated pie chart        
        Random rnd = new Random();

        //Pie charts source for testing
       // protected string jscharts = "{name: '#test', source: [{ 'label' : '10%', 'value' :'10'}, { 'label': '90% free', 'value' :'90'}]}";

        protected string jscharts;
        

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Request.Form["__EVENTTARGET"] == "Start")
            {
                GetPieChartValues(Convert.ToInt32(Request.Form["__EVENTARGUMENT"]));
                SetPieCharts();
            } 
        }

        /// <summary>
        /// This method sets all the display attributes for the pie charts and sends the calculated data to be processed on the front end
        /// </summary>
        private void SetPieCharts()
        {

            int commaIndex = 0; //determines where to put a commma in the piechart data string

            foreach (PieChart chart in chartList)
            {
                HtmlGenericControl pieDiv = new HtmlGenericControl("div"); //overall div that will house all the other divs
                HtmlGenericControl pieName = new HtmlGenericControl("div");
                HtmlGenericControl pieChart = new HtmlGenericControl("div"); //div that will store the piechart javascript
                HtmlGenericControl pieAmountMB = new HtmlGenericControl("div");
                HtmlGenericControl pieDelta = new HtmlGenericControl("div");//div that will indicate positive or negative changes by the hour
                HtmlGenericControl pieDeltaText = new HtmlGenericControl("div");


                commaIndex++;

                pieChart.ID = chart.name;

                if (chart.percentage < 1)
                {
                    chart.percentage = 0;
                }

                jscharts += "{name: '#" + chart.name + "', source: [{ 'label' : '" + chart.percentage + "%" + "', 'value' :'" + chart.percentage + "'}, { 'label': '" + (100 - chart.percentage) + "% free" + "', 'value' :'" + (100 - chart.percentage) + "'}]}"; //add pie chart to data string
                if (commaIndex < chartList.Count) //assign commas till the end of the data string
                {
                    jscharts += ", ";
                }

                pieName.InnerText = chart.name; 
                pieDeltaText.InnerText = string.Format("{0:n0}", (chart.delta / 1024)) + " MB";

                if (chart.delta > 0) //green triangle
                {
                    pieDeltaText.InnerText.Insert(0, "+");
                    pieDelta.Style["border-bottom"] = "10px solid green";
                }

                if (chart.delta < 0) //red triangle
                {
                    pieDelta.Style["border-top"] = "10px solid red";
                }

                pieDelta.Style["width"] = "0";
                pieDelta.Style["height"] = "0";
                pieDelta.Style["border-left"] = "10px solid transparent";
                pieDelta.Style["border-right"] = "10px solid transparent";

                pieDiv.Style["display"] = "inline-block";

                pieChart.Style["max-width"] = "150px";
                pieChart.Style["max-height"] = "150px";

                pieDiv.Controls.Add(pieName);
                pieDiv.Controls.Add(pieAmountMB);
                pieDiv.Controls.Add(pieChart);
                pieDiv.Controls.Add(pieDelta);
                pieDiv.Controls.Add(pieDeltaText);
                pieDiv.Style["cursor"] = "pointer";
           
                pieDiv.Attributes["onclick"] = "displayChart('" + chart.name + "',[" + SetLineChart() + "])"; //add onclick to pie chart
                PieChartPanel.Controls.Add(pieDiv); //add div to pie chart panel
            }

        }

        /// <summary>
        /// Create random values for param number of charts generated. 
        /// </summary>
        /// <param name="numberOfCharts">User inputted number</param>
        private void GetPieChartValues(int numberOfCharts)
        {
            for (int i = 0; i < numberOfCharts; i++)
            {

                PieChart chart = new PieChart();

                chart.name = "Chart" + (i + 1);
                chart.amount = rnd.Next(0, 1000000000);//bytes_used 
                if (chart.amount == 0)
                {
                    chart.percentage = 0;
                }
                else
                {
                    chart.percentage = rnd.Next(1, 100);  //percent_use
                }

                chart.date = DateTime.Now.ToString(); //readdate
                chart.delta = rnd.Next(-10000,10000); //hourly change in mb
                chartList.Add(chart);
            }

        }

        /// <summary>
        /// Populate string with calculations for line chart
        /// </summary>
        private string SetLineChart()
        {
            int number = 0;
            int commaIndex = 0;
            string lineChart="";
           
            int i_size = rnd.Next(1,10);

            for (int i = 0; i < i_size; i++)
            {
                commaIndex++;
                lineChart += "{x: " + number + ", y: " + rnd.Next(0, 10000) + "}"; //setup string for x and y axes
                //lineChart += "'"+DateTime.Now.AddDays(i)+"'"; //setup string for x axis labels
                if (commaIndex < i_size) 
                {
                    number++;
                    lineChart += ", ";
                    //xSource += ", ";
                    
                }
            }
            return lineChart;
            
        }
    }

}