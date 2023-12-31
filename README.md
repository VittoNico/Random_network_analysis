# Network_analysis_Maastricht_Assignment_Nicoloso


#STAGE1_Network_creation
library(igraph)
library(ggplot2)
library(htmltools)
library(RCy3)
library(htmlwidgets)

# Crea un grafo casuale con 200 nodi
set.seed(123)  # Imposta un seed per la riproducibilità
graph <- erdos.renyi.game(200, p = 0.05, directed = FALSE)

# Disegna il grafo
plot(graph, main = "Network")
layout <- layout.graphopt(graph)
plot(
    graph,
    layout = layout,
    main = "Network_graphopt_style",
    vertex.label.cex = 0.8,  # Dimensione delle etichette
    vertex.size = 8,  # Dimensione dei nodi
    edge.arrow.size = 0.5  # Dimensione delle frecce per gli archi diretti (se presenti)
)
png("network_graphopt_style.png", width = 1000, height = 1000)  # Specifica le dimensioni dell'immagine
dev.off()
# Creare una dipendenza HTML per l'immagine
network_graphopt_style_dependency <- htmltools::htmlDependency(
    "network_graphopt_style", "1.0.0", src = "network_graphopt_style.png", script = FALSE,
    stylesheet = FALSE
)
# Creare un tag HTML per l'immagine
network_graphopt_style_html <- sprintf('<div><img src="%s" alt="network graphopt style"></div>', network_graphopt_style_dependency$src)




# Imposta la dimensione dei nodi in base al grado
#node_size <- degree(graph) * 5  # Modifica il fattore di moltiplicazione per regolare la dimensione
#plot(graph, layout = layout, vertex.size = node_size, main = "Grafo Casuale con 200 Nodi")
# Aggiungi etichette e personalizza i colori
#plot(graph, layout = layout, vertex.size = node_size, vertex.label.dist = 1.5, vertex.label.cex = 0.8, 
     #vertex.label.color = "black", vertex.color = "lightblue", main = "Grafo Casuale con 200 Nodi")
# Migliora il layout del grafico
#plot(graph, layout = layout, vertex.size = node_size, vertex.label.dist = 1.5, vertex.label.cex = 0.8, 
     #vertex.label.color = "black", vertex.color = "lightblue", main = "Grafo Casuale con 200 Nodi",
     #edge.arrow.size = 0.5, edge.curved = TRUE, edge.color = "gray")

cytoscapePing()
createNetworkFromIgraph(graph, title = "prova", collection = "my_collection")

#STAGE2_Network_analysis

degree_info <- degree(graph)
closeness_info <- closeness(graph)
betweenness_info <- betweenness(graph)
clustering_info <- transitivity(graph)
connected_components <- clusters(graph)$csize

#STAGE2_Provisory_PLO
# Create a data frame for plotting
data <- data.frame(Node = 1:length(degree_info), Degree = degree_info)

# Plot a histogram (mean_degree)
mean_graph <- ggplot(data, aes(x = Degree)) +
    geom_histogram(binwidth = 1, fill = "blue", color = "black", alpha = 0.7) +
    labs(x = "Degree", y = "Frequency") +
    theme(axis.title=element_text(size=7, family="TT Times New Roman")) +
    ggtitle("Degree Distribution") +
    theme(plot.title = element_text(hjust = 0.5, family="TT Times New Roman"))
    
ggsave("mean_graph.png", mean_graph, device = "png", width = 5, height = 3)

# Creare una dipendenza HTML per l'immagine
mean_graph_dependency <- htmltools::htmlDependency(
    "mean_graph", "1.0.0", src = "mean_graph.png", script = FALSE,
    stylesheet = FALSE
)
# Creare un tag HTML per l'immagine
mean_graph_html <- sprintf('<div><img src="%s" alt="Mean Graph"></div>', mean_graph_dependency$src)


# Crea un dataframe con le informazioni sulla betweenness
data_bit <- data.frame(Node = 1:length(betweenness_info), Betweenness = betweenness_info)
# Calcola la media della betweenness
mean_betweenness <- mean(betweenness_info)
# Crea un grafico con ggplot2
betw_graph <- ggplot(data_bit, aes(x = Node, y = Betweenness)) +
    geom_bar(stat = "identity", fill = "blue", alpha = 0.7) +
    geom_hline(yintercept = mean_betweenness, linetype = "dashed", color = "red", size = 1) +
    labs(x = "Node", y = "Betweenness") +
    ggtitle("Betweenness Distribution with Mean") +
    theme_minimal() +
    theme(axis.title = element_text(size = 8), plot.title = element_text(size = 10))
ggsave("betw_graph.png", betw_graph, device = "png", width = 5, height = 3)
# Creare una dipendenza HTML per l'immagine
betw_graph_dependency <- htmltools::htmlDependency(
    "betw_graph", "1.0.0", src = "betw_graph.png", script = FALSE,
    stylesheet = FALSE
)
# Creare un tag HTML per l'immagine
betw_graph_html <- sprintf('<div><img src="%s" alt="Betw Graph"></div>', betw_graph_dependency$src)


#STAGE2_REPORT

report <- paste0(
    "<style>",
    "  body { font-family: 'Arial', sans-serif; font-size: 28px; color: #333; }",
    "  h1, h2 { color: #008080; }",  # Colore verde scuro per i titoli
    "  p { line-height: 1.6; }",  # Altezza della riga per i paragrafi
    "  .highlight { background-color: #FFFF00; }",  # Esempio di classe di evidenziazione
    "  .center { text-align: center; }",  # Classe per il centrare
    "</style>",
    "<h1>Network Analysis Report</h1>",
    network_graphopt_style_html,
    "<h2>Basic Information</h2>",
    "<p>Number of Nodes: ", vcount(graph), " (the number of Nodes in your Network.)</p>",
    "<p>Number of Edges: ", ecount(graph), " (the number of Bridges connecting the in your Network.)</p>",
    "<p>Number of Connected Components: ", length(connected_components), "</p>",
    "<h2>Degree Distribution</h2>",
    "<p>Mean Degree: ", mean(degree_info), " (the mean of the degrees of the nodes in your graph. High values = more connected network.)</p>",
    mean_graph_html,  # Aggiungi il mean_graph all'inizio del report
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
