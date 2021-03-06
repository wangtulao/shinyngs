% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/scatterplot.R
\name{scatterplotInput}
\alias{scatterplotInput}
\title{Input function for the scatterplot module}
\usage{
scatterplotInput(id)
}
\arguments{
\item{id}{Module namespace}
}
\value{
output An HTML tag object that can be rendered as HTML using 
as.character()
}
\description{
Controls for this module are provided by the \code{scatterplotcontrols}
module, which is automatically called if reactives are not supplied to the 
server function. This setup allows the same set of controls to power 
multiple scatter plots.
}
\examples{
scatterplotInput('pca')
}

