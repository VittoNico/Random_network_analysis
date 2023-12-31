# Network_analysis_Maastricht_Assignment_Nicoloso

The script enables the creation of a random Network by using multiple R packages. The network will be uploaded on cytoscape for visualization. Not only that, the script will analize the basic feature of the network such the mean degree distribution of the nodes and will produce an HTML report file with statistics data and plots for further exploration.

# Stage 0: R Packages
The packages required for this script can be summarized in three categories:
1) Packages needed for the creation of the network, its analysis and its transfer to Cytoscape
2) Packages needed for the creation of the HTML report
3) Packages needed for the plotting of the data extracted from the network

The packages needed are those, make sure that they are all installed before launching the script.

<pre>
library(igraph)
library(ggplot2)
library(htmltools)
library(RCy3)
library(htmlwidgets)
</pre>
