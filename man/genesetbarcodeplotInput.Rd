% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/genesetbarcodeplot.R
\name{genesetbarcodeplotInput}
\alias{genesetbarcodeplotInput}
\title{The UI input function of the genesetbarcodeplot module}
\usage{
genesetbarcodeplotInput(id, eselist)
}
\arguments{
\item{id}{Submodule namespace}

\item{eselist}{ExploratorySummarizedExperimentList object containing
ExploratorySummarizedExperiment objects}
}
\value{
output An HTML tag object that can be rendered as HTML using 
  as.character()
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
Leverages the \code{simpletable} module
}
\examples{
genesetbarcodeplotInput('experiment', eselist)
}
\keyword{shiny}

