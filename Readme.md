# Age-dependent transcriptomic effects of morphine in the frontal cortex of female mice
This repository provides instructions, code, and supplementary data files to reproduce results and figures from our opioid and aging paper

> J Savage, A Rai, JD Lee, J Banahan, K Dujic, M Nunez, B Caldarone, S Ghoshal, FJ Slack, M Mavrikaki. Age-dependent transcriptomic effects of morphine in the frontal cortex of female mice. Neuropharmacology (In revision 2025).

## Abstract

Increasing lifespans make health problems in the elderly such as opioid misuse a more prominent concern. Understanding the effects that opioids may have on the aged brain can help us address age-related concerns of opioid exposure. This study aimed to assess potential interactions between aging and opioid exposure. Three-month-old (young adult) and 19-month-old (aged) C57BL/6JN mice were assigned to either a morphine (3mg/kg, i.p.) or saline group. A conditioned placed preference (CPP) task was used to assess reward sensitivity, while rotarod and beam walk tests were used to assess sensorimotor coordination. To assess for potential age-dependent effects of morphine on gene expression, we performed RNA sequencing in the prefrontal cortex (PFC). We found that morphine induced CPP in both age groups. Our results indicate impaired motor coordination in aged mice; however, morphine did not significantly affect motor coordination in either age group, although a trend toward an increased number of slips was observed in morphine-treated aged mice. Transcriptomic analysis revealed more robust effects of morphine on gene expression in the aged brain compared to the young brain. Interestingly, we found limited overlap between morphine-regulated genes in young and old mice, suggesting that the molecular effects of morphine are age-dependent. Taken together, while we found no significant interactions between morphine (at the tested dose) and aging in the behavioral assays, morphine caused age-dependent gene expression changes. Our findings suggest that age should be considered when prescribing opioids and that age-specific therapeutics may help address opioid use disorder in the elderly.
  
## Code information

The available R markdown file contains R scripts used to generate figures and data tables available with the current iteration of the manuscript. Last run 12/2/2025.

Files for corresponding visualization are in the ./VISUALIZATION/ folder. These were constructed by A. Rai.

## Session Info 

R version 4.3.3 (2024-02-29)
Platform: x86_64-apple-darwin20 (64-bit)
Running under: macOS 15.4

Matrix products: default
BLAS:   /System/Library/Frameworks/Accelerate.framework/Versions/A/Frameworks/vecLib.framework/Versions/A/libBLAS.dylib 
LAPACK: /Library/Frameworks/R.framework/Versions/4.3-x86_64/Resources/lib/libRlapack.dylib;  LAPACK version 3.11.0

locale:
[1] en_US.UTF-8/en_US.UTF-8/en_US.UTF-8/C/en_US.UTF-8/en_US.UTF-8

time zone: America/New_York
tzcode source: internal

attached base packages:
[1] stats4    stats     graphics  grDevices utils     datasets  methods   base     

other attached packages:
 [1] viridis_0.6.5               viridisLite_0.4.2           DESeq2_1.42.1              
 [4] SummarizedExperiment_1.32.0 MatrixGenerics_1.14.0       matrixStats_1.5.0          
 [7] GenomicRanges_1.54.1        GenomeInfoDb_1.38.8         tximport_1.30.0            
[10] reshape2_1.4.4              dplyr_1.1.4                 org.Mm.eg.db_3.18.0        
[13] biomaRt_2.58.2              fgsea_1.28.0                GO.db_3.18.0               
[16] AnnotationDbi_1.64.1        IRanges_2.36.0              S4Vectors_0.40.2           
[19] Biobase_2.62.0              BiocGenerics_0.48.1         ggrepel_0.9.6              
[22] ggplot2_4.0.0               stringr_1.5.1              

loaded via a namespace (and not attached):
 [1] DBI_1.2.3               bitops_1.0-9            gridExtra_2.3           rlang_1.1.6            
 [5] magrittr_2.0.3          compiler_4.3.3          RSQLite_2.4.2           png_0.1-8              
 [9] vctrs_0.6.5             pkgconfig_2.0.3         crayon_1.5.3            fastmap_1.2.0          
[13] dbplyr_2.5.0            XVector_0.42.0          labeling_0.4.3          rmarkdown_2.29         
[17] tzdb_0.5.0              bit_4.6.0               xfun_0.52               zlibbioc_1.48.2        
[21] cachem_1.1.0            jsonlite_2.0.0          progress_1.2.3          blob_1.2.4             
[25] DelayedArray_0.28.0     BiocParallel_1.36.0     parallel_4.3.3          prettyunits_1.2.0      
[29] R6_2.6.1                stringi_1.8.7           RColorBrewer_1.1-3      numDeriv_2016.8-1.1    
[33] Rcpp_1.1.0              knitr_1.50              readr_2.1.5             Matrix_1.6-5           
[37] tidyselect_1.2.1        rstudioapi_0.17.1       dichromat_2.0-0.1       abind_1.4-8            
[41] yaml_2.3.10             codetools_0.2-20        curl_6.4.0              lattice_0.22-7         
[45] tibble_3.3.0            plyr_1.8.9              withr_3.0.2             KEGGREST_1.42.0        
[49] S7_0.2.0                coda_0.19-4.1           evaluate_1.0.4          BiocFileCache_2.10.2   
[53] xml2_1.3.8              Biostrings_2.70.3       pillar_1.11.0           filelock_1.0.3         
[57] generics_0.1.4          vroom_1.6.5             RCurl_1.98-1.17         emdbook_1.3.14         
[61] hms_1.1.3               scales_1.4.0            glue_1.8.0              apeglm_1.24.0          
[65] tools_4.3.3             data.table_1.17.8       locfit_1.5-9.12         mvtnorm_1.3-3          
[69] XML_3.99-0.18           fastmatch_1.1-6         cowplot_1.2.0           grid_4.3.3             
[73] bbmle_1.0.25.1          bdsmatrix_1.3-7         colorspace_2.1-1        GenomeInfoDbData_1.2.11
[77] cli_3.6.5               rappdirs_0.3.3          S4Arrays_1.2.1          gtable_0.3.6           
[81] digest_0.6.37           SparseArray_1.2.4       farver_2.1.2            memoise_2.0.1          
[85] htmltools_0.5.8.1       lifecycle_1.0.4         httr_1.4.7              MASS_7.3-60.0.1        
[89] bit64_4.6.0-1
