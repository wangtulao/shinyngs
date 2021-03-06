% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/heatmap.R
\name{heatmap}
\alias{heatmap}
\title{The server function of the heatmap module}
\usage{
heatmap(input, output, session, eselist, type = "expression")
}
\arguments{
\item{input}{Input object}

\item{output}{Output object}

\item{session}{Session object}

\item{eselist}{ExploratorySummarizedExperimentList object containing
ExploratorySummarizedExperiment objects}

\item{type}{The type of heatmap that will be made. 'expression', 'samples' or
'pca'}
}
\description{
This function is not called directly, but rather via callModule() (see 
example).
}
\details{
This function assumes that the gene sets have one gene ID (e.g. Entrez) which
need to be converted to another (e.g. Symbol, Ensembl gene ID). This would be
common when dealign with MSigDB gene sets, for example.
}
\examples{
callModule(heatmap, 'heatmap', eselist, type = 'pca')
}
\keyword{shiny}

