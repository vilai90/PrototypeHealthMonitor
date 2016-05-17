using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Health_Monitor
{
    /// <summary>
    /// Class responsible for defining pie charts objects.
    /// </summary>
    public class PieChart
    {
        public string name { get; set; }
        public long delta { get; set; }
        public long amount { get; set; }
        public int percentage { get; set; }
        public string date { get; set; }
    }
}