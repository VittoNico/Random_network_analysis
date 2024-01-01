# Network_analysis_Maastricht_Assignment_Nicoloso

The script enables the creation of a random Network by using multiple R packages. The network will be uploaded on cytoscape for visualization. Not only that, the script will analize the basic feature of the network such the mean degree distribution of the nodes and will produce an HTML report file with statistics data and plots for further exploration.

# Stage 0: R Packages
The packages required for this script can be summarized in three categories:
1) Packages needed for the creation of the network, its analysis and its transfer to Cytoscape
2) Packages needed for the creation of the HTML report
3) Packages needed for the plotting of the data extracted from the network

The packages needed are those, make sure that they are all installed before launching the script.

```R
library(igraph)
library(ggplot2)
library(htmltools)
library(RCy3)
library(htmlwidgets)
```

# Stage 1: Network Creation
Now that all the packages are installed we can procede to the creation of the network. The package Igraph can provides different types of random networks. For this script we will utilize this

```R
set.seed(123)
graph <- erdos.renyi.game(200, p = 0.05, directed = FALSE)
plot(graph, main = "Network")
</pre>
With this script the network will be immediatly avaiable for vision. As you can see, most of the nodes are overlapping and it is difficult to visually interpret. The package Igraph provides a number of layout that can help to better analyze the network that we are working with. For a better visualization of the nodes the layout style graphopt is raccomanded

```R
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
```
The script will modify the layout of the network for a bettere visualization and saves the image producted as a PNG file in the work directory. The parameter for which we provide numbers are for the modification of the size of the nodes, the etichettes and the bridges. These can be modified for the all the needs.
All we need now for stage 1 is to upload the network on cytoscape. This is easily done with this script. WARNING: make sure that cytoscape is open before launching this script or it won't work.

```R
cytoscapePing()
createNetworkFromIgraph(graph, title = "Network", collection = "Maastricht_Assignment")
```

# Stage 2: Analysis of the Network
Now to the Network's Analysis. This script will directly extract info directly from the graph. This informations are not useful as they are but they will be utilized for the creation of the HTML report file

```R
degree_info <- degree(graph)
closeness_info <- closeness(graph)
betweenness_info <- betweenness(graph)
clustering_info <- transitivity(graph)
connected_components <- clusters(graph)$csize
```

# Stage 3: Report
With the information obtained from the last script we can finally create a report file for our network. Before the compilation of the report we need to create a couple plot more. Here is the script for each of them.

```R
data <- data.frame(Node = 1:length(degree_info), Degree = degree_info)
mean_graph <- ggplot(data, aes(x = Degree)) +
    geom_histogram(binwidth = 1, fill = "blue", color = "black", alpha = 0.7) +
    labs(x = "Degree", y = "Frequency") +
    theme(axis.title=element_text(size=7, family="TT Times New Roman")) +
    ggtitle("Degree Distribution") +
    theme(plot.title = element_text(hjust = 0.5, family="TT Times New Roman"))    
ggsave("mean_graph.png", mean_graph, device = "png", width = 5, height = 3)
mean_graph_dependency <- htmltools::htmlDependency(
    "mean_graph", "1.0.0", src = "mean_graph.png", script = FALSE,
    stylesheet = FALSE
)

data_bit <- data.frame(Node = 1:length(betweenness_info), Betweenness = betweenness_info)
mean_betweenness <- mean(betweenness_info)
betw_graph <- ggplot(data_bit, aes(x = Node, y = Betweenness)) +
    geom_bar(stat = "identity", fill = "blue", alpha = 0.7) +
    geom_hline(yintercept = mean_betweenness, linetype = "dashed", color = "red", size = 1) +
    labs(x = "Node", y = "Betweenness") +
    ggtitle("Betweenness Distribution with Mean") +
    theme_minimal() +
    theme(axis.title = element_text(size = 8), plot.title = element_text(size = 10))
ggsave("betw_graph.png", betw_graph, device = "png", width = 5, height = 3)
betw_graph_dependency <- htmltools::htmlDependency(
    "betw_graph", "1.0.0", src = "betw_graph.png", script = FALSE,
    stylesheet = FALSE
)
betw_graph_html <- sprintf('<div><img src="%s" alt="Betw Graph"></div>', betw_graph_dependency$src)
mean_graph_html <- sprintf('<div><img src="%s" alt="Mean Graph"></div>', mean_graph_dependency$src)
```

The script not only will create the plots but for each of them it will make an HTML address for adding them to the report file. To obtain it, all we need to do is to use this final script.
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
    "<p>Number of Edges: ", ecount(graph), " (the number of Bridges connecting the in your Network.)</p>",
    "<p>Number of Connected Components: ", length(connected_components), "</p>",
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
With this script you will obtain a report file filled with the information needed, and also plots and network imagines. Fot opening the file HTML you can use your standard web browser, and the internet connection it is not needed.
