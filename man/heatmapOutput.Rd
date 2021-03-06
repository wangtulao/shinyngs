% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/heatmap.R
\name{heatmapOutput}
\alias{heatmapOutput}
\title{The output function of the heatmap module}
\usage{
heatmapOutput(id, type = "")
}
\arguments{
\item{id}{Submodule namespace}
}
\value{
output An HTML tag object that can be rendered as HTML using 
as.character()
}
\description{
This provides actual heatmap element for display by applications
}
\examples{
heatmapOutput('heatmap')
}
\keyword{shiny}

