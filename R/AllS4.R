## All classifiers will extend this virtual class
setClass("ShikkenModel", contains="VIRTUAL")

## All kernel function will extend this
setClass("KernelFunction", representation(dot="function", params="list"))