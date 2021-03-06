#' The input function of the dendrogram module
#' 
#' This provides the form elements to control the pca display
#' 
#' @param id Submodule namespace
#' @param eselist ExploratorySummarizedExperimentList object containing
#'   ExploratorySummarizedExperiment objects
#'   
#' @return output An HTML tag object that can be rendered as HTML using 
#'   as.character()
#'   
#' @keywords shiny
#'   
#' @examples
#' dendroInput(ns('boxplot'), eselist)

dendroInput <- function(id, eselist) {
    
    ns <- NS(id)
    
    expression_filters <- selectmatrixInput(ns("dendro"), eselist)
    
    dendro_filters <- list(selectInput(ns("corMethod"), "Correlation method", c(Pearson = "pearson", Spearman = "spearman", Kendall = "kendall")), 
        selectInput(ns("clusterMethod"), "Clustering method", c(`Ward minimum variance clustering` = "ward.D2", `Single linkage` = "single", 
            `Complete linkage` = "complete", `Average linkage` = "average", WPGMA = "mcquittye", UPGMC = "centroid")), groupbyInput(ns("dendro")))
    
    fieldSets(ns("fieldset"), list(clustering = dendro_filters, expression = expression_filters, export = plotdownloadInput(ns("dendro"))))
    
}

#' The output function of the boxplot module
#' 
#' This provides actual boxplot element for display by applications
#'
#' @param id Submodule namespace
#'
#' @return output An HTML tag object that can be rendered as HTML using 
#' as.character() 
#'
#' @keywords shiny
#' 
#' @examples
#' dendroOutput('dendro')

dendroOutput <- function(id) {
    ns <- NS(id)
    list(modalInput(ns("dendro"), "help", "help"), modalOutput(ns("dendro"), "Sample clustering dendrogram", includeMarkdown(system.file("inlinehelp", 
        "dendro.md", package = packageName()))), h3("Sample clustering dendrogram"), plotOutput(ns("sampleDendroPlot"), height = 600))
}

#' The server function of the dendrogram module
#' 
#' This function is not called directly, but rather via callModule() (see 
#' example).
#' 
#' @param input Input object
#' @param output Output object
#' @param session Session object
#' @param eselist ExploratorySummarizedExperimentList object containing
#'   ExploratorySummarizedExperiment objects
#'   
#' @keywords shiny
#'   
#' @examples
#' callModule(dendro, 'dendro', eselist)

dendro <- function(input, output, session, eselist) {
    
    # Get the expression matrix - no need for a gene selection
    
    unpack.list(callModule(selectmatrix, "dendro", eselist, select_genes = TRUE, var_n = 1000, provide_all_genes = TRUE, default_gene_select = "variance"))
    colorBy <- callModule(groupby, "dendro", eselist = eselist, group_label = "Color by")
    
    # Call to plotdownload module
    
    callModule(plotdownload, "dendro", makePlot = plotSampleDendroPlot, filename = "dendrogram.png", plotHeight = 600, plotWidth = 800)
    
    # Reactive for making a plot for download
    
    plotSampleDendroPlot <- reactive({
        clustering_dendrogram(selectMatrix(), selectColData(), colorBy(), cor_method = input$corMethod, cluster_method = input$clusterMethod, 
            matrixTitle())
        
    })
    
    # Render the actual plot
    
    output$sampleDendroPlot <- renderPlot({
        withProgress(message = "Making sample dendrogram", value = 0, {
            
            clustering_dendrogram(selectMatrix(), selectColData(), colorBy(), cor_method = input$corMethod, cluster_method = input$clusterMethod, 
                matrixTitle())
            
        })
    }, height = 600)
}

#' Make a clustering dendrogram with coloring by experimental variable
#' 
#' A simple function using \code{ggdendro} to make a sample dendrogram
#'
#' @param plotmatrix Expression/ other data matrix
#' @param experiment Annotation for the columns of plotmatrix
#' @param colorby Column name in \code{experiment} specifying how boxes should be colored
#'
#' @return output A \code{ggplot} output
#'
#' @keywords keywords
#'
#' @import ggplot2
#' @import ggdendro
#' 
#' @export
#' 
#' @examples
#' ggplot_boxplot(selectMatrix(), selectColData(), colorBy())

clustering_dendrogram <- function(plotmatrix, experiment, colorby = NULL, cor_method = "pearson", cluster_method = "ward.D", plot_title = "") {
    
    plotmatrix <- log2(plotmatrix + 1)
    
    hcd <- calculateDendrogram(plotmatrix, cor_method, cluster_method)
    
    ddata_x <- ggdendro::dendro_data(hcd)
    
    p2 <- ggplot(ggdendro::segment(ddata_x)) + geom_segment(aes(x = x, y = y, xend = xend, yend = yend))
    
    labs <- ggdendro::label(ddata_x)
    
    ymax <- max(ddata_x$segments$yend)
    
    # Things are much simpler without coloring the samples
    
    if (is.null(colorby)) {
        
        p3 <- p2 + geom_text(data = labs, angle = 90, hjust = 1, size = rel(6), aes_string(label = "label", x = "x", y = -(ymax/40)), show_guide = F)
        
        p3 <- p3 + ggdendro::theme_dendro() + ylim(-(ymax/3), ymax)
        
        p3 <- p3 + geom_point(data = labs, aes_string(x = "x", y = 0), size = 4)
        
    } else {
        
        labs[[colorby]] <- as.character(experiment[[colorby]][match(labs$label, rownames(experiment))])
        shapes <- rep(15:20, 10)[1:length(unique(experiment[[colorby]]))]
        
        p3 <- p2 + geom_text(data = labs, angle = 90, hjust = 1, size = rel(5), aes_string(label = "label", x = "x", y = -(ymax/40), colour = colorby), 
            show_guide = F)
        
        p3 <- p3 + ggdendro::theme_dendro() + ylim(-(ymax/4), ymax) + scale_color_discrete(name = prettifyVariablename(colorby))
        
        p3 <- p3 + geom_point(data = labs, aes_string(x = "x", y = 0, colour = colorby, shape = colorby), size = 4) + scale_shape_manual(values = shapes, 
            name = prettifyVariablename(colorby)) + theme(title = element_text(size = rel(1.8)), legend.text = element_text(size = rel(1.8))) + 
            ggtitle(plot_title)
        
    }
    
    if (!is.null(colorby)) {
        p3 <- p3 + guides(color = guide_legend(nrow = ceiling(length(unique(experiment[[colorby]]))/2)))
    }
    print(p3 + theme(title = element_text(size = rel(1.5)), legend.text = element_text(size = rel(1.5)), legend.position = "bottom") + ggtitle(plot_title))
}

#' Calculate a distance matrix based on correlation
#'
#' @param plotmatrix Expression/ other data matrix
#' @param cor_method 'spearman' or 'perason'
#'
#' @return output Object of class 'dist'
#'
#' @keywords keywords
#'
#' @export
#' 
#' @examples
#' calculateDist(mymatrix)

calculateDist <- function(plotmatrix, cor_method = "spearman") {
    as.dist(1 - cor(plotmatrix, method = cor_method))
}

#' Calculate a clustering dendgrogram based on correlation
#'
#' @param plotmatrix Expression/ other data matrix
#' @param cor_method 'spearman' or 'perason'
#' @param cluster_method Clustering method to pass to hclust (Default: 'ward.D2')
#'
#' @return output Object of class 'dist'
#'
#' @keywords keywords
#'
#' @export
#' 
#' @examples
#' calculateDist(mymatrix)

calculateDendrogram <- function(plotmatrix, cor_method = "spearman", cluster_method = "ward.D2") {
    
    dd <- calculateDist(plotmatrix, cor_method = cor_method)
    
    hc <- hclust(dd, method = cluster_method)
    
    as.dendrogram(hc)
} 
