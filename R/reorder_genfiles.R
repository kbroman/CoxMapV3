#!/usr/bin/env Rscript
# reorder crimap gen files using build39 positions

library(here)

# extract data to working directory
ifile <- here("Data/final_gen.tgz")
odir <- here("WorkV3")
if(!dir.exists(odir)) dir.create(odir)
system(paste('cd', odir, "; tar xzvf", ifile, ">/dev/null"))

# read map information
map <- data.table::fread(here("Build39/mouse_map_conv_new_positions.csv"),
                         data.table=FALSE)
map <- map[!grepl("^zero",map$snpid),]
map <- map[!is.na(map$grcm39_bp),]

for(chr in c(1:19,"X")) {
    cat(chr, "\n")

    this_map <- map[map$chr==chr,]
    this_map <- this_map[order(this_map$grcm39_bp),]
    markers <- this_map$snpid

    genfile <- file.path(odir, paste0("final", chr, ".gen"))

    lines <- readLines(genfile)
    nfam <- as.numeric(lines[1])
    nmar <- as.numeric(lines[2])
    mar <- lines[3:(nmar+2)]

    stopifnot( all(markers %in% mar) )

    lines_rev <- c(lines[1], length(markers), markers)

    new_order <- match(markers, mar)
    stopifnot( !any(is.na(new_order)) )
    new_gorder <- as.numeric( rbind((new_order-1)*2 + 1, (new_order-1)*2 + 2) )

    last_line <- nmar+2
    offset <- length(lines_rev) - last_line
    lines_rev <- c(lines_rev, lines[-(1:(nmar+2))])
    for(ifam in 1:nfam) {
        fam <- lines[last_line+1]
        nind <- as.numeric(lines[last_line+2])
        last_line <- last_line + 2
        for(ind in 1:nind) {
            g <- strsplit(lines[last_line+2], "\\s+")[[1]]
            stopifnot(length(g) == nmar*2)
            lines_rev[last_line+2 + offset] <- paste(g[new_gorder], collapse=" ")
            last_line <- last_line + 2
        }
    }

    cat(paste0(lines_rev,"\n"), file=genfile, sep="")
}
