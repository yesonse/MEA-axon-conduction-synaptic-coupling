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

##### 1) Spike detection and sorting
        Sorting_info(input,output)
        input and output is address, input is where you store HDF5 files, and output is where you store the generated data
##### 2) Propagation signal detection 
        PS_hist_time
        identify pairwise conduction signal, input is the output of function Sorting_info
##### 3) simplify PS network to single PS and visualization                                                                           
        output_PS_ORDER
        generate single identified PS, it includes .dat file and .pdf file
##### 4) visualize neuron in a dish                                                                                                       
        output_ps_well
        generate real location of a neuron in a well

#### Input Files

HDF5 files


#### Output Files

1 ps.csv

2 ps.dat

3 ps.pdf

4 ps_well.pdf

 ![ps_img](Screen Shot 2017-10-27 at 10.24.56 AM.png)
