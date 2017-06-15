# Tools for Decoding Neuron Network in A Dish
============================================

Introduction
------------

New Techniques allows scientists to generate neurons in the plates and model mental disorders in a dish (Diseases In A Dish). Multielectrode arrays (MEAs) connect neurons to electronic circuitry, record the ion currents of neurons and enable us to study the neuron’s activities in neuronal cell culture.

By using the MEA recording data, we’ve developed some tools to study propagation signals along neuron axons (pre-synaptic signals). We identified the loci of axons, calculated the conduction velocity, explored axon branches and sizes, and simplify the neuron organizations in the well.

Neurons use synapses to pass signal and form networks. We also studied synaptic coupling and identified the connections between neurons. Together with the data of pre-synaptic signals, we can decode the neuron network in each well, compare the neuronal activity, network connectivity and network activity between samples.

This Tools :

- PS_modules, a Python module for interacting with multi-electrode data within Python. 
- A command line script for spike detection/spike sorting.
- [MEA Viewer](#mea-viewer), a Python application for high performance visualization of raw analog recordings and spike raster data.
- [MEA Tools](#mea-tools-gui), a Python application which provides an easy to use interface to the spike detection/spike sorting routines provided by the command line script.
- A Mathematica library for manipulating and analyzing analog and spike data.

## Installation
