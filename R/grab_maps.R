#!/usr/bin/env Rscript

library(here)

# extract map positions from Work/sa*.txt and Work/ss*.txt

args <- commandArgs(trailingOnly=TRUE)

if(length(args) > 0) {
    idir <- args[1]
} else {
    idir <- here("Work")
}

if(length(args) > 1) {
    ofile <- args[2]
} else {
    ofile <- "map.rds"
}

map <- NULL
for(chr in c(1:19, "X")) {
    cat(chr, "\n")
    sa_file <- file.path(idir, paste0("sa", chr, ".txt"))
    ss_file <- file.path(idir, paste0("ss", chr, ".txt"))
    if(!(file.exists(sa_file) && file.exists(ss_file))) next

    lines <- readLines(sa_file)
    lines <- lines[!grepl("allocated", lines)]

    first <- grep("map (", lines, fixed=TRUE)+2
    last <- grep("denotes recomb. frac.", lines, fixed=TRUE)-2
    stopifnot(length(first)==1, length(last)==1)

    lines <- lines[seq(first, last, by=2)]
    lines <- sub("^\\s+", "", lines)
    lines <- sub("\\s+$", "", lines)
    lines_spl <- strsplit(lines, "\\s+")
    marker <- sapply(lines_spl, "[", 2)
    sa_pos <- sapply(lines_spl, "[", 3)


    lines <- readLines(ss_file)

    first <- grep("map (", lines, fixed=TRUE)+2
    last <- grep("denotes recomb. frac.", lines, fixed=TRUE)-2
    stopifnot(length(first)==1, length(last)==1)

    lines <- lines[seq(first, last, by=2)]
    lines <- sub("^\\s+", "", lines)
    lines <- sub("\\s+$", "", lines)
    lines_spl <- strsplit(lines, "\\s+")
    marker2 <- sapply(lines_spl, "[", 2)
    female_pos <- sapply(lines_spl, "[", 3)
    male_pos <- sapply(lines_spl, "[", 4)

    stopifnot(length(marker) == length(marker2), all(marker == marker2))

    this_map <- data.frame(chr=rep(chr, length(marker)),
                           marker=marker,
                           ave=as.numeric(sa_pos),
                           female=as.numeric(female_pos),
                           male=as.numeric(male_pos),
                           stringsAsFactors=FALSE)

    if(is.null(map)) map <- this_map else map <- rbind(map, this_map)
}


saveRDS(map, ofile)
