% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/genesetbarcodeplot.R
\name{genesetbarcodeplot}
\alias{genesetbarcodeplot}
\title{The server function of the genesetbarcodeplot module}
\usage{
genesetbarcodeplot(input, output, session, eselist)
}
\arguments{
\item{input}{Input object}

\item{output}{Output object}

\item{session}{Session object}

\item{eselist}{ExploratorySummarizedExperimentList object containing
ExploratorySummarizedExperiment objects}
}
\description{
This module displays gene set analysis tables stored as a list in the 
\code{gene_set_analyses} slot of an \code{ExploratorySummarizedExperiment}.
The keys of this list must match those of the \code{gene_sets} slot of the
containing \code{ExploratorySummarizedExperimentList}, and the row names
of each table must match the second-level keys. The module is based on the
output of roast() from \code{limma}, but it's fairly generic, and assumes
only the presence of a 'p value' and 'FDR' column, so the output of other
methods should be easily adapted to suit.
}
\details{
This function is not called directly, but rather via callModule() (see 
example). Essentially this just passes the results of \code{colData()} 
applied to the specified SummarizedExperiment object to the 
\code{simpletable} module
}
\examples{
callModule(genesetbarcodeplot, 'genesetbarcodeplot', eselist)
}
\keyword{shiny}

