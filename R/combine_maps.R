#!/usr/bin/env Rscript

# combine revised genetic map with the build 39 physical map
# shift the cM positions so 0 cM == 3 Mbp

library(here)

phy_file <- here("Build39/mouse_map_conv_new_positions.csv")
gen_file <- here("Build39/cox_build39.csv")

ofile <- here("cox_v3_map.csv")


pmap <- data.table::fread(phy_file, data.table=FALSE)
gmap <- data.table::fread(gen_file, data.table=FALSE)

pmap <- pmap[pmap$snpid %in% gmap$marker,]
stopifnot(all(pmap$snpid == gmap$marker) )

gmap$bp_grcm39 <- pmap$grcm39_bp
gmap$strand_grcm39 <- pmap$strand

# shift genetic maps so 3 Mbp == 0 cM
for(chr in c(1:19, "X")) {
    this_map <- gmap[gmap$chr==chr,]
    for(col in c("ave", "female", "male")) {
        this_map[,col] <- this_map[,col] +
            diff(range(this_map[,col]))/diff(range(this_map[,"bp_grcm39"]))*min(this_map[,"bp_grcm39"]-3e6)
        this_map[,col] <- round(this_map[,col], 5)
    }
    gmap[gmap$chr==chr,] <- this_map
}

# X chromosome should only have female map
gmap[gmap$chr=="X", "ave"] <- NA
gmap[gmap$chr=="X", "male"] <- NA

gmap[,1:2] <- gmap[,2:1]
colnames(gmap)[1:2] <- c("marker", "chr")
colnames(gmap)[3:5] <- paste0("cM_coxV3_", colnames(gmap)[3:5])

write.table(gmap, ofile, sep=",", quote=FALSE,
            row.names=FALSE, col.names=TRUE)
