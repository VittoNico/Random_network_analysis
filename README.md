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

# Stage 1: Network Creation
Now that all the packages are installed we can procede to the creation of the network. The package Igraph can provides different types of random networks. For this script we will utilize this

<pre>
set.seed(123)
graph <- erdos.renyi.game(200, p = 0.05, directed = FALSE)
plot(graph, main = "Network")
</pre>
With this script the network will be immediatly avaiable for vision. As you can see, most of the nodes are overlapping and it is difficult to visually interpret. The package Igraph provides a number of layout that can help to better analyze the network that we are working with. For a better visualization of the nodes the layout style graphopt is raccomanded

<pre>
layout <- layout.graphopt(graph)
plot(
    graph,
    layout = layout,
    main = "Network_graphopt_style",
    vertex.label.cex = 0.8,
    vertex.size = 8,
    edge.arrow.size = 0.5 
)
png("network_graphopt_style.png", width = 1000, height = 1000)
dev.off()
</pre>
The script will modify the layout of the network for a bettere visualization and saves the image producted as a PNG file in the work directory. The parameter for which we provide numbers are for the modification of the size of the nodes, the etichettes and the bridges. These can be modified for the all the needs.
All we need now for stage 1 is to upload the network on cytoscape. This is easily done with this script. WARNING: make sure that cytoscape is open before launching this script or it won't work.

<pre>
cytoscapePing()
createNetworkFromIgraph(graph, title = "Network", collection = "Maastricht_Assignment")
</pre>
