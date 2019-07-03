## First Steps Toward Concealing the Traces Left by Reversible Image Data Hiding
Hiding the expansion embedding traces and histogram shifting traces that incurred by prediction error expansion - histogram shifting (PEE-HS) based reversible image data hiding (RIDH).

## Source Code
This project includes the following MATLAB scripts (written in Matlab R2017a):

* **demo.m**: 
Demo for our proposed PEE-HS RIDH approach, which can hide the embedding traces while preserving the reversibility.

* **PEHypthosis.m**: 
The function for plotting the prediction error histogram and its hypothesis Laplacian model of a given image.

* **detParaCap2.m**: 
The function for finding the embedding capacity parameters, i.e., the T_l and T_r.

* **embed.m**: 
The function for embedding the data payload into the given image cover.

* **jsdiv.m**: 
The function for computing the JS divergence between two distributions (the histograms in the discrete case).

* **mockErrDet.m**: 
The function for generating the surrogate prediction errors.

* **recover.m**: 
The function for data extraction and image recovery.


## Authors

* **Li Dong** - [Homepage](http://www.escience.cn/people/dongli90/index.html) - For any inquries, please drop an Email at: dongli at nbu dot edu dot cn.

