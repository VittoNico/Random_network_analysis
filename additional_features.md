# Additional Features
As requested in the assignment, the script creates the network, covers the basic analysis of the network and prepares a report file with the results. This does not mean that we have to stop there. For example, we can make different styles of network that suit our needs at Stage 1. In the assignment, the graphopt layout was used to visualize an optimized network.

```R
layout <- layout.graphopt(graph)
```
However, in case we want to see the simple connection between each node without the obstruction of the structure of the network, we may use the circle layout. 

```R
layout <- layout.circle(graph)
```
Obviously, changing styles can create some problems of visualization. Nevertheless, this can be fixed by using the many parameters of the command plot. In the main script, we covered the manipulation of the nodes with the functions vertex.label.cex and vertex.size, but these can be further modified by changing their shape with vertex.shape or their colour with vertex.color. In addition, the edges of the network can be changed with the parameter edge, for example edge.width to modify the dimension of the edges.

The main script covers the basic features of the network analysis. But if a more in-depth exploration is required, Igraph offers a large number of analyses that can be added to Stage 2. Here is a small example of how to extract more information with Igraph and add this information to the report file at the end of Stage 3.

```R
# Other information of the graph
eccentricity_info <- eccentricity(graph) 
diameter_info <- diameter(graph)

# Add these information to the report file
"<h2>Eccentricity</h2>",
"<p>Mean Eccentricity: ", mean(eccentricity_info), " (mean eccentricity across all nodes. High values = nodes are far from each other in terms of the shortest path length.)</p>",
"<h2>Diameter</h2>",
"<p>Graph Diameter: ", diameter_info, " (the length of the longest shortest path in the graph.)</p>"
```
This is only a small example of the data that can be obtained from Igraph. For example, the function graph.coreness can test the network by removing a number of nodes to verify its solidity. The graph.motifs on the other hand can analyse the network to check if there is a particular motif inside it.
