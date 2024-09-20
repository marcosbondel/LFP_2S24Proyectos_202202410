from graphviz import Digraph

# Create a new directed graph
dot = Digraph()

# Add nodes
dot.node('A', 'Node A')
dot.node('B', 'Node B')
dot.node('C', 'Node C')

# Add edges
dot.edge('A', 'B', 'Edge from A to B')
dot.edge('B', 'C', 'Edge from B to C')
dot.edge('A', 'C', 'Edge from A to C')

# Render the graph to a file (e.g., PNG)
dot.render('graph', format='png', cleanup=True)

# Optionally, display the graph
dot.view()
