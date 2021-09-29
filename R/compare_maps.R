# compare original and revised maps

library(here)

orig <- data.table::fread(here("OrigMaps/CoxMaps_rev_build38.csv"), data.table=FALSE)
orig <- orig[!grepl("^zero", orig$snpID),]
new <-  data.table::fread(here("cox_v3_map.csv"), data.table=FALSE)

library(qtl2convert)
orig_ave <- map_df_to_list(orig, pos_column="ave_cM", marker_column="snpID", chr_column="chr_b37")
new_ave <- map_df_to_list(new, pos_column="cM_coxV3_ave")
orig_mal <- map_df_to_list(orig, pos_column="mal_cM", marker_column="snpID", chr_column="chr_b37")
new_mal <- map_df_to_list(new, pos_column="cM_coxV3_male")
orig_fem <- map_df_to_list(orig, pos_column="fem_cM", marker_column="snpID", chr_column="chr_b37")
new_fem <- map_df_to_list(new, pos_column="cM_coxV3_female")

# plot lengths
z <- cbind(summaryMap(new_ave), summaryMap(orig_ave))
grayplot(z[,2], z[,6])
abline(0,1)
text(z[,2], z[,6]+1, c(1:19, "X"))
# sex-averaged autosomes 1386 cM -> 1383 cM

# plot female lengths
z <- cbind(summaryMap(new_fem), summaryMap(orig_fem))[1:20,]
grayplot(z[,2], z[,6])
abline(0,1)
text(z[,2], z[,6]+1, c(1:19, "X"))
# female length 1518 -> 1512 cM

# plot female lengths
z <- cbind(summaryMap(new_mal), summaryMap(orig_mal))
grayplot(z[,2], z[,6])
abline(0,1)
text(z[,2], z[,6]+1, c(1:19, "X"))
# male length 1327 -> 1325 cM

# the chromosomes looked smaller, but that was because the zero position was included
# in original maps, which added ~4% length; removing those, we end up with maps
# that are hardly different

orig_c7 <- orig[orig$chr_b37==7,]
new_c7 <- new[new$chr==7,]

new_list <- new_ave; new_list["X"] <- new_fem["X"]
orig_list <- orig_ave; orig_list["X"] <- orig_fem["X"]
library(qtl)
plotMap(orig_list, new_list)

# look at recombination rate
orig$Mbp_b37 <- orig$bp_b37/1e6
orig_b37 <- map_df_to_list(orig, pos="Mbp_b37", marker_column="snpID", chr_column="chr_b37")

new$Mbp_grcm39 <- new$bp_grcm39/1e6
new_b39 <- map_df_to_list(new, pos="Mbp_grcm39")

library(xoi)
rr_new <- recrate2scanone(est.recrate(new_list, new_b39), new_b39)
rr_orig <- recrate2scanone(est.recrate(orig_list, orig_b37), orig_b37)

par(mfrow=c(5,4))
for(i in c(1:19,"X")) {
    plot(rr_new, chr=i, main=i, ylim=c(0, 2))
    plot(rr_orig, chr=i, add=TRUE, col="violetred")
}

rr_new_male <- recrate2scanone(est.recrate(new_mal[1:19], new_b39[1:19]), new_b39[1:19])
rr_orig_male <- recrate2scanone(est.recrate(orig_mal[1:19], orig_b37[1:19]), orig_b37[1:19])
par(mfrow=c(5,4))
for(i in 1:19) {
    plot(rr_new_male, chr=i, main=i, ylim=c(0, 2))
    plot(rr_orig_male, chr=i, add=TRUE, col="violetred")
}

rr_new_female <- recrate2scanone(est.recrate(new_fem[1:19], new_b39[1:19]), new_b39[1:19])
rr_orig_female <- recrate2scanone(est.recrate(orig_fem[1:19], orig_b37[1:19]), orig_b37[1:19])
par(mfrow=c(5,4))
for(i in 1:19) {
    plot(rr_new_female, chr=i, main=i, ylim=c(0, 2))
    plot(rr_orig_female, chr=i, add=TRUE, col="violetred")
}
