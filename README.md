# Network_Analysis_Maastricht_Assignment_Nicoloso

The script enables the creation of a random Network by using multiple R packages. The network will be uploaded on Cytoscape for visualization. Not only that, the script will analize the basic feature of the network such the mean degree distribution of the nodes and will produce an HTML report file with statistics data and plots for further exploration. The file README contain a detailed description of the code while the file fastscript.R provide the code as a single command to launch directly on R. The file more_features offers more options for the creation and exploration of the network.

# Stage 0: R Packages
The packages required for this script can be summarized in three categories:

1) Packages needed for the creation of the network, its analysis and its transfer to Cytoscape
2) Packages needed for the plotting of the data extracted from the network 
3) Packages needed for the creation of the HTML report

The packages needed are these, make sure that they are all installed before launching the script. In case you miss some of them, open the installer page of the package, there you can find everything you need

```R
# Packages needed for the script
install.packages("igraph")
install.packages("ggplot2")
install.packages("htmltools")
install.packages("htmlwidgets")
if (!require("BiocManager", quietly = TRUE))
    install.packages("BiocManager")

BiocManager::install("RCy3")
```
```R
# Packages needed for the script
library(igraph)
library(ggplot2)
library(htmltools)
library(RCy3)
library(htmlwidgets)
```

# Stage 1: Network Creation
Now that all the packages are installed we can procede to the creation of the network. The package Igraph can provides different types of random networks. For this script we will utilize the erdos.renyi.game. In case you prefer at the beginning to have at your disposal a graph that remain constant you can provide a seed for reproducibility.
```R
# Set a seed for reproducibility. You can choose a number of your preference
set.seed(106)
```
```R
# Produce a random Network and visualize it
graph <- erdos.renyi.game(200, p = 0.05, directed = FALSE)
plot(graph, main = "Network")
```

With this script the network will be immediatly avaiable for vision. As you can see, most of the nodes are overlapping and it is difficult to visually interpret. The package Igraph provides a number of layout that can help to better analyze the network that we are working with. For a better visualization of the nodes the layout style graphopt is raccomanded

```R
# Modify the layout of the Network for better visualization, and create file PNG
layout <- layout.graphopt(graph)
plot(
    graph,
    layout = layout,
    main = "Network_Graphopt_Style",
    vertex.label.cex = 0.8,
    vertex.size = 8,
)
#Create PNG file of the stylized plot
png("Network_Graphopt_Style.png", width = 1000, height = 1000)
plot(
    graph,
    layout = layout,
    main = "Network_graphopt_style",
    vertex.label.cex = 0.8,
    vertex.size = 8,
)
dev.off()
# Assign HTML coordinates to the stylized Network for the HTML report
network_graphopt_style_dependency <- htmltools::htmlDependency(
    "network_graphopt_style", "1.0.0", src = "network_graphopt_style.png", script = FALSE,
    stylesheet = FALSE
)
network_graphopt_style_html <- sprintf('<div><img src="%s" alt="network graphopt style"></div>', network_graphopt_style_dependency$src)
```
The script will modify the layout of the network for a bettere visualization and saves the image producted as a PNG file in the work directory. The parameter for which we provide numbers are for the modification of the size of the nodes and the etichettes. These can be modified for the all the needs.
All we need now for stage 1 is to upload the network on Cytoscape. This is easily done with this script. WARNING: make sure that cytoscape is open before launching this script or it won't work. In case Cytoscape it is not installed here is the link for the dowload.

<pre>
#Dowload site for cytoscape
https://cytoscape.org/download.html
</pre>

```R
# WARNING: Cytoscape must be open before launching the script
#Connect to Cytoscape and upload the Network
cytoscapePing()
createNetworkFromIgraph(graph, title = "Network", collection = "Maastricht_Assignment")
```

# Stage 2: Analysis of the Network
Now to the Network's Analysis. This script will directly extract the information for a standard network analyis directly from the the list that compose the graph. The informations are not useful as they are but they will be utilized for the creation of the HTML report file

```R
# Extract the information needed for the analysis of the Network
degree_info <- degree(graph) # Number of edges that connect each nodes
closeness_info <- closeness(graph) # Closeness to the center to each nodes
betweenness_info <- betweenness(graph) # Crucial level of connectivity between nodes 
clustering_info <- transitivity(graph) # Tendencies of each Node to form a group
```

# Stage 3: Report
With the information obtained from the last script we can finally create a report file for our network. Before the compilation of the report we need to create plots useful for a visualize the data. Here is the script for each of them.

```R
# Create the plot of the Degree level
data_deg <- data.frame(Node = 1:length(degree_info), Degree = degree_info)
mean_graph <- ggplot(data_deg, aes(x = Degree)) +
    geom_histogram(binwidth = 1, fill = "blue", color = "black", alpha = 0.7) +
    labs(x = "Degree", y = "Frequency") +
    theme(axis.title=element_text(size=8)) +
    ggtitle("Degree Distribution") +
    theme(plot.title = element_text(hjust = 0.5))
mean_graph  
ggsave("mean_graph.png", mean_graph, device = "png", width = 5, height = 3)
# Create a plot of the Betweeness level
data_bet <- data.frame(Node = 1:length(betweenness_info), Betweenness = betweenness_info)
mean_betweenness <- mean(betweenness_info)
betw_graph <- ggplot(data_bet, aes(x = Node, y = Betweenness)) +
    geom_bar(stat = "identity", fill = "blue", alpha = 0.7) +
    geom_hline(yintercept = mean_betweenness, linetype = "dashed", color = "red", size = 1) +
    labs(x = "Node", y = "Betweenness") +
    theme(axis.title=element_text(size=8)) +
    ggtitle("Betweenness Distribution with Mean") +
    theme_minimal() +
    theme(plot.title = element_text(hjust = 0.5))
betw_graph
ggsave("betw_graph.png", betw_graph, device = "png", width = 5, height = 3)

# Assign HTML coordinates to the plots for the HTML report
mean_graph_dependency <- htmltools::htmlDependency(
    "mean_graph", "1.0.0", src = "mean_graph.png", script = FALSE,
    stylesheet = FALSE
)
betw_graph_dependency <- htmltools::htmlDependency(
    "betw_graph", "1.0.0", src = "betw_graph.png", script = FALSE,
    stylesheet = FALSE
)
betw_graph_html <- sprintf('<div><img src="%s" alt="Betw Graph"></div>', betw_graph_dependency$src)
mean_graph_html <- sprintf('<div><img src="%s" alt="Mean Graph"></div>', mean_graph_dependency$src)
```

The script not only will create PNG file of the plots but for each of them it will make an HTML address for adding them to the report file. With all the information and the plots ready, all we need is the final report. This is the script needed for obtained it. The style of the report can be modified by changing parameters between the 'style' set. The report contain also a short explanation of the data obtained
```R
report <- paste0(
    "<style>",
    "  body { font-family: 'Arial', sans-serif; font-size: 28px; color: #333; }",
    "  h1, h2 { color: #008080; }",
    "  p { line-height: 1.6; }",
    "  .highlight { background-color: #FFFF00; }",
    "  .center { text-align: center; }",
    "</style>",
    "<h1>Network Analysis Report</h1>",
    network_graphopt_style_html,
    "<h2>Basic Information</h2>",
    "<p>Number of Nodes: ", vcount(graph), " (the number of Nodes in your Network.)</p>",
    "<p>Number of Edges: ", ecount(graph), " (the number of Edges connecting the in your Network.)</p>",
    "<h2>Degree Distribution</h2>",
    "<p>Mean Degree: ", mean(degree_info), " (the mean of the degrees of the nodes in your graph. High values = more connected network.)</p>",
    mean_graph_html,
    "<p>Standard Deviation of Degree: ",  sd(degree_info), " (the standard deviation of node degrees. High values = heterogeneity in the degree distribution.)</p>",
    "<h2>Closeness Centrality</h2>",
    "<p>Mean Closeness Centrality: ", mean(closeness_info), " (average of closeness centrality values across all Nodes. High values = Nodes in the graph are closer to each other in terms of the shortest path length.)</p>",
    "<h2>Betweenness Centrality</h2>",
    "<p>Mean Betweenness Centrality: ", mean(betweenness_info), " (average betweenness centrality across all nodes in the graph. High values = nodes in the graph have a more crucial role in connecting different parts of the network.)</p>",
    betw_graph_html,
    "<h2>Clustering Coefficient</h2>",
    "<p>Global Clustering Coefficient: ", clustering_info, " (degree to which nodes in a graph tend to cluster together. High values = higher tendency for nodes in the graph to form clusters or groups)</p>"
)

writeLines(report, "network_analysis_report.html")
```
With this script you will obtain a report file filled with the information needed, and also plots and network imagines. For opening the HTML file you can use your standard web browser, and the internet connection is not needed.
