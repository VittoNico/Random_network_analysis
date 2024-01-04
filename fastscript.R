# Packages needed for the script
library(igraph)
library(ggplot2)
library(htmltools)
library(RCy3)
library(htmlwidgets)

# Stage 1: Network Creation
Now that all the packages are installed we can procede to the creation of the network. The package Igraph can provides different types of random networks. For this script we will utilize the erdos.renyi.game. In case you prefer at the beginning to have at your disposal a graph that remain constant you can provide a seed for reproducibility.

# Set a seed for reproducibility. You can choose a number of your preference
set.seed(106)

# Produce a random Network and visualize it
graph <- erdos.renyi.game(200, p = 0.05, directed = FALSE)
plot(graph, main = "Network")

# Modify the layout of the Network for better visualization, and create file PNG
layout <- layout.graphopt(graph)
plot(
    graph,
    layout = layout,
    main = "Network_Graphopt_Style",
    vertex.label.cex = 0.8,
    vertex.size = 8,
    edge.arrow.size = 0.5 
)
#Create PNG file of the stylized plot
png("Network_Graphopt_Style.png", width = 1000, height = 1000)
plot(
    graph,
    layout = layout,
    main = "Network_graphopt_style",
    vertex.label.cex = 0.8,
    vertex.size = 8,
    edge.arrow.size = 0.5 
)
dev.off()
# Assign HTML coordinates to the stylized Network for the HTML report
network_graphopt_style_dependency <- htmltools::htmlDependency(
    "network_graphopt_style", "1.0.0", src = "network_graphopt_style.png", script = FALSE,
    stylesheet = FALSE
)
network_graphopt_style_html <- sprintf('<div><img src="%s" alt="network graphopt style"></div>', network_graphopt_style_dependency$src)

# WARNING: Cytoscape must be open before launching the script
#Connect to Cytoscape and upload the Network
cytoscapePing()
createNetworkFromIgraph(graph, title = "Network", collection = "Maastricht_Assignment")

# Extract the information needed for the analysis of the Network
degree_info <- degree(graph) # Number of bridge that connect each nodes
closeness_info <- closeness(graph) # Closeness to the center to each nodes
betweenness_info <- betweenness(graph) # Crucial level of connectivity between nodes 
clustering_info <- transitivity(graph) # Tendencies of each Node to form a group

# Create the plot of the Degree level
data_deg <- data.frame(Node = 1:length(degree_info), Degree = degree_info)
mean_graph <- ggplot(data_deg, aes(x = Degree)) +
    geom_histogram(binwidth = 1, fill = "blue", color = "black", alpha = 0.7) +
    labs(x = "Degree", y = "Frequency") +
    theme(axis.title=element_text(size=8)) +
    ggtitle("Degree Distribution") +
    theme(plot.title = element_text(hjust = 0.5))    
ggsave("mean_graph.png", mean_graph, device = "png", width = 5, height = 3)
mean_graph
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
