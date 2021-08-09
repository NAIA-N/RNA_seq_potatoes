## query the table with ids

ids = c("PGSC0003DMG400000008", "PGSC0003DMG400000002")

id_table <- features[which(features$ensembl_gene_id %in% ids),]

# 
# > Sig_results
# [1] "DEG_sig_results_Controls_Leaf"       "DEG_sig_results_tolerant_T1_Leaf"    "DEG_sig_results_tolerant_T2_Leaf"   
# [4] "DEG_sig_results_tolerant_T3_Leaf"    "DEG_sig_results_susceptible_T1_Leaf" "DEG_sig_results_susceptible_T2_Leaf"
# [7] "DEG_sig_results_susceptible_T3_Leaf" "DEG_sig_results_Controls_Root"       "DEG_sig_results_tolerant_T1_Root"   
# [10] "DEG_sig_results_tolerant_T2_Root"    "DEG_sig_results_tolerant_T3_Root"    "DEG_sig_results_susceptible_T1_Root"
# [13] "DEG_sig_results_susceptible_T2_Root" "DEG_sig_results_susceptible_T3_Root"


dat_sus <- read.csv("DEG_sig_results_susceptible_T2_Leaf.csv")
dat_tol <- read.csv("DEG_sig_results_tolerant_T2_Leaf.csv")
common_genes <- read.csv("Upregulated_genes_common_T2_Leaf.csv")

up_dat_sus <- dat_sus[which(dat_sus$log2FoldChange > 1),] ## Remmeber to neg for downregulated
up_dat_tol <- dat_tol[which(dat_tol$log2FoldChange > 1),] ## Remmeber to neg for downregulated


up_dat_sus_common <- up_dat_sus[which(up_dat_sus$X %in% common_genes[,1]),]
up_dat_tol_common <- up_dat_tol[which(up_dat_tol$X %in% common_genes[,1]),]

up_dat_sus_common <- up_dat_sus_common[order(up_dat_sus_common$X), ]
up_dat_tol_common <- up_dat_tol_common[order(up_dat_tol_common$X), ]


up_dat_common <- cbind(up_dat_sus_common, up_dat_tol_common$padj)
up_dat_common <- up_dat_common[,c(1,7,8)]
rownames(up_dat_common)  <- up_dat_common$X
up_dat_common <- up_dat_common[,-1]
up_dat_common$padj_mean <- rowMeans(up_dat_common)

up_common_genes <- up_dat_common[order(up_dat_common$padj_mean), ]

id_table <- features[which(features$ensembl_gene_id %in% up_common_genes),]
