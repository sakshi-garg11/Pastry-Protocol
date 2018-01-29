PROJECT 3 – PASTRY
The goal of our project is to implement  the pastry protocol using the actor model in elixir. 

Team Members:
Shreya Sahani    UFID: 3345-8209  shreya.sahani@ufl.edu
Sakshi Garg      UFID: 9750-4936  sakshigarg.1@ufl.edu

Code Submitted:
project3.ex
worker.ex 

How To Run:
mix escript.build
./project3 numNodes numRequests


What is working:
Each node has a unique identifier which is called nodeId. When the node is provided with the message and the key, then that Pastry node routes the message to the node which has the nodeId closest to the key. It will check for the node amongst all the live Pastry nodes in the network. Each pastry node keeps track of its immediate neighbours in the nodeId space and even notifies applications on the arrival of any new node.It also manage network locality and minimises the distance messages travel, according to the number of IP routing hops. 

We tested the complete functionality of Join and Routing aspects of Pastry Algorithm. 
The output will be the number of log measures indicating the events occurring. The final and end line contains the average number of hops that were required to be calculated. 

It takes the input as number of nodes(numNodes) to be created in the network and number of requests(numRequests) that each node has to make. 
Each Pastry node is being initialised and maintains the routing table and leaf nodes. It is responsible for the message routing to the appropriate peer.
Once the network is built it sends number of messages to each of the pastry node actor specified by number of requests.
If the message is received at the destination node then it maintains the number of hops per node and at the end when all messages are received at the destination average number of hops are calculated which is then printed.

What is the largest network we can manage:
Larger network may be supported, but may take a longer time.
largest numNodes -> 70   and numRequests -> 5






