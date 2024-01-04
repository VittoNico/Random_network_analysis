# More Feature
As the assignment asked, the script create the network, covers the basic analyis  of the network and prepare a report file with the results. That doesn't mean that we have to stop here. For example, we can make different styles of network that suit our needs. In the assignment the graphopt layout has been used to see an optimized network

```R
layout <- layout.graphopt(graph)
```
but in other case we my want to see the simple connection between each node without the obstruction of the structure of the network, we may use the layout circle

```R
layout <- layout.circle(graph)
```
Of course, changing styles can create some problem of visualization, but this can be fixed by

The script covers the basic features of the Network analysis. But if a more deep exploration is required, Igraph offers a large number of analysis that can be added to the STAGE 2. Here is a small example to how extract more information with Igraph and add those information to the report file at the end of STAGE 3.

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

This is only a small example of the data that can be obtained from Igraph. For example the function graph.coreness can test the network by removing a number of node to verify its solidity. The graph.motifs on the other hands can analyze the network to check if there is a particular motifs inside it.
