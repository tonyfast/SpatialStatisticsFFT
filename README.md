SpatialStatisticsFFT
====================

In practice, materials science information must be evaluated and compared in a statistical manner.  Traditional materials science practice involves pre-processing steps that identify material features; from there statistics of the features are extracted.  Examples of feature statistics are orientition distribution functions, volume fraction, variance; the statistics are feature identifiers in materials science. 

Spatial statistics provide a powerful objective statistical quantifier for materials science information.  Spatial statistics have effective statistical measures embedded in them such as [volume fraction](http://www.sciencedirect.com/science/article/pii/S1359645407007458) and [specific surface area](http://citeseerx.ist.psu.edu/viewdoc/summary?doi=10.1.1.49.1716).  

Getting Started
===============

[Quick Start](http://tonyfast.com/SpatialStatisticsFFT/2014/05/14/QuickStart---Get-started-in-Matlab.html) documentation in Matlab.

###  Steps 

1. Fork/Clone/Download the Repository
2. Add the top-level directory to the Matlab path.
3. Execute ``QuickStart.m`` 

Main Functions
==============

* ``SpatialStatsFFT`` - Compute the Spatial Statistics using Fast Fourier Transform algorithms for speak.
* ``PairCorrelationFFT`` - Compute the Pair Correlation by computing the vector-resolved Spatial Statistics and integrating over angle.
* ``FindPeaksSSFFT`` - Find the peaks (or valleys) in the vector-resolved Spatial Statistics
* ``PlotSlice`` - A requested visualization tool to plot individual slices in volumetric spatial statistics.

Applications
============

Spatial statistics have shown diverse applications in

* [Metallic feature identification](http://www.sciencedirect.com/science/article/pii/S1359645411004654)
* [Homogenization relations in fuel cells](http://scholar.google.com/citations?view_op=view_citation&hl=en&user=OWGKu6wAAAAJ&citation_for_view=OWGKu6wAAAAJ:zYLM7Y9cAGgC)
* [Electronic potential identification in Molecular Dynamics](http://tonyfast.com/Atomic-Positions/2014/05/15/Feature-Identifaction-in-Molecular-Dynamics-Potential-Comparisons.html)


Principal Analysis Matlab Code
==============================
I suggest using Mark Tygert's randomized Principal Component Analysis function that can be downloaded from http://cims.nyu.edu/~tygert/pca.m . 



