# Tools for Decoding Neuron Network in A Dish
============================================================

Introduction
------------

New Techniques allows scientists to generate neurons in the plates and model mental disorders in a dish (Diseases In A Dish). Multielectrode arrays (MEAs) connect neurons to electronic circuitry, record the ion currents of neurons and enable us to study the neuron’s activities in neuronal cell culture.

By using the MEA recording data, we’ve developed some tools to study propagation signals along neuron axons (pre-synaptic signals). We identified the loci of axons, calculated the conduction velocity, explored axon branches and sizes, and simplify the neuron organizations in the well.

Neurons use synapses to pass signal and form networks. We also studied synaptic coupling and identified the connections between neurons. Together with the data of pre-synaptic signals, we can decode the neuron network in each well, compare the neuronal activity, network connectivity and network activity between samples.

This Tools runs under Windows, Linux and Mac. It requires MATLAB 2016 (R2016a) or higher. It hase several modules including:



How-to
------

#### Installation
Matlab 

#### Basic Instructions

#### 1) Spike detection and sorting
        Sorting_info.m
#### 2) Propagation signal detection 
        PS_hist_time.m
#### 3simplify PS network to single PS and visualization                                                                                     output_PS_ORDER.m       

4 # visualize neuron in a dish                                                                                                            output_ps_well.m

#### Input Files

HDF5 files from cluster


#### Output Files

1 ps.csv

2 ps.dat

3 ps.pdf

4 ps_well.pdf
