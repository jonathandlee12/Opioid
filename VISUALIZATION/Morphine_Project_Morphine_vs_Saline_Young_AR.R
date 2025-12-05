# Install and load necessary packages if you haven't already
if (!requireNamespace("readxl", quietly = TRUE)) install.packages("readxl")
if (!requireNamespace("ggplot2", quietly = TRUE)) install.packages("ggplot2")
if (!requireNamespace("ggrepel", quietly = TRUE)) install.packages("ggrepel")
if (!requireNamespace("dplyr", quietly = TRUE)) install.packages("dplyr") # Added for dplyr functionality

library(readxl)
library(ggplot2)
library(ggrepel)
library(dplyr)

# 1. Specify the path to your Excel file

excel_file_path <- ("C:\\Users\\arai2\\Desktop\\Morphine project\\txt file_morphine\\Morphine_RNAseqdata.xlsx")

# 2. Specify the sheet name (cortical layer) you want to use
sheet_name <- "Morphine_Young_vs_Saline_Young" 

# 3. Define the three sets of genes you want to highlight
genes_set1 <- c("Anln",
"Prss23"
) # Overlapping genes old (Saline) vs Young (Saline)
genes_set2 <- c("Ank1",
                "Inf2",
                "Serinc2",
                "Col24a1",
                "Onecut2"
) # Top DEGs
genes_set3 <- c("Sult1a1",
                "Wfs1",
                "Arc",
                "Dusp5",
                "Gramd1b"
) # Overlapping genes Old_Morphine_vs_Saline

# 4. Define the colors for highlighting and significance
color_set1 <- "black"
color_set2 <- "darkgreen"
color_set3 <- "magenta"
color_upregulated_significant <- "red"
color_downregulated_significant <- "blue"
color_nonsignificant <- "gray"

# Load the data from the specified Excel sheet
tryCatch({
  data <- read_excel(excel_file_path, sheet = sheet_name)
}, error = function(e) {
  stop(paste("Error reading Excel file or sheet:", e$message,
             "\nPlease ensure 'excel_file_path' and 'sheet_name' are correct and the file is accessible."))
})

# --- Column Renaming and Data Preprocessing ---
data <- data %>%
  rename(
    log2foldchange = log2FoldChange,
    gene_name = external_gene_name
  )

# Remove rows with NA in critical columns BEFORE calculations
data <- data %>%
  filter(!is.na(log2foldchange) & !is.na(padj) & !is.na(gene_name))

# --- FIX: Convert key columns to numeric ---
# This step is crucial to prevent "non-numeric argument" errors
data$padj <- as.numeric(data$padj)
data$log2foldchange <- as.numeric(data$log2foldchange)

# Handle padj = 0 by setting a very small non-zero value
data$padj[data$padj == 0] <- min(data$padj[data$padj > 0], na.rm = TRUE) / 10

# Convert padj to -log10(padj) for the y-axis
data$minus_log10_padj <- -log10(data$padj)

# Clean gene names in the data frame (remove leading/trailing spaces)
data$gene_name <- trimws(data$gene_name)

# Define significance thresholds
padj_threshold <- 0.05
log2fc_threshold <- 0.5 # Your desired log2FC threshold

# --- Create a new column to categorize genes for highlighting and significance ---
# Initialize all genes as "NS" (Non-Significant)
data$highlight_group <- "NS"

# 1. Classify *all* genes based on general significance thresholds (padj and log2FC).
# Upregulated Significant (high FC): padj < 0.05 AND log2FC >= 0.5
data$highlight_group[data$padj < padj_threshold & data$log2foldchange >= log2fc_threshold] <- "Upregulated Significant"

# Downregulated Significant (high FC): padj < 0.05 AND log2FC <= -0.5
data$highlight_group[data$padj < padj_threshold & data$log2foldchange <= -log2fc_threshold] <- "Downregulated Significant"

# Upregulated Significant (low FC): padj < 0.05 AND 0 < log2FC < 0.5
data$highlight_group[data$padj < padj_threshold & data$log2foldchange > 0 & data$log2foldchange < log2fc_threshold] <- "Upregulated Significant (low FC)"

# Downregulated Significant (low FC): padj < 0.05 AND -0.5 < log2FC < 0
data$highlight_group[data$padj < padj_threshold & data$log2foldchange < 0 & data$log2foldchange > -log2fc_threshold] <- "Downregulated Significant (low FC)"

# 2. Now, override the categories for the specific highlighted gene sets.
data$highlight_group[data$gene_name %in% genes_set1] <- "Overlapping genes old (Saline) vs Young (Saline)"
data$highlight_group[data$gene_name %in% genes_set2] <- "Top DEGs"
data$highlight_group[data$gene_name %in% genes_set3] <- "Overlapping genes Old_Morphine_vs_Saline"


# Define colors for the plot, ensuring all categories have a color
custom_colors <- c(
  "NS" = color_nonsignificant,
  "Downregulated Significant (low FC)" = color_downregulated_significant, # Blue
  "Upregulated Significant (low FC)" = color_upregulated_significant,     # Red
  "Downregulated Significant" = color_downregulated_significant,          # Blue
  "Upregulated Significant" = color_upregulated_significant,              # Red
  "Overlapping genes old (Saline) vs Young (Saline)" = color_set1,                         # Black
  "Top DEGs" = color_set2,                              # Dark Green
  "Overlapping genes Old_Morphine_vs_Saline" = color_set3                                          # Magenta 
  )

# Order the levels for consistent plotting and legend order
data$highlight_group <- factor(data$highlight_group,
                               levels = c("NS",
                                          "Downregulated Significant (low FC)",
                                          "Upregulated Significant (low FC)",
                                          "Downregulated Significant",
                                          "Upregulated Significant",
                                          "Overlapping genes old (Saline) vs Young (Saline)",
                                          "Top DEGs",
                                          "Overlapping genes Old_Morphine_vs_Saline"))

# Create the volcano plot
volcano_plot <- ggplot(data, aes(x = log2foldchange, y = minus_log10_padj, color = highlight_group)) +
  geom_point(alpha = 0.8, size = 1.5) +
  scale_color_manual(values = custom_colors, drop = FALSE) +
  # Vertical dashed lines at log2FC thresholds (-0.5 and 0.5)
  geom_vline(xintercept = c(-log2fc_threshold, log2fc_threshold), linetype = "dashed", color = "black") +
  # Horizontal dashed line at padj threshold (0.05, i.e., -log10(0.05))
  geom_hline(yintercept = -log10(padj_threshold), linetype = "dashed", color = "black") +
  theme_minimal() +
  labs(
    title = paste("Volcano Plot for Morphine RNAseq (Sheet: ", sheet_name, ")", sep=""), # Updated title
    x = expression(Log[2]~"Fold Change"),
    y = expression(-Log[10]~"Adjusted P-value"),
    color = "Gene Group"
  ) +
  # Add a continuous x-axis scale with specific breaks for clarity
  scale_x_continuous(breaks = c(-2, -1, -log2fc_threshold, 0, log2fc_threshold, 1, 2), limits = c(-3, 3)) +
  scale_y_continuous(limits = c(0, 20)) + # ADDED: Set the y-axis scale range) +
  theme(
    plot.title = element_text(hjust = 0.5, face = "bold"),
    legend.position = "right",
    legend.direction = "vertical",
    legend.box = "horizontal",
    legend.text = element_text(size = 8),
    legend.title = element_text(size = 9)
  )

# Prepare data for labeling: only label genes in the specific sets, regardless of their final color
labeled_genes <- data[data$gene_name %in% c(genes_set1, genes_set2, genes_set3), ]

# Only apply geom_text_repel if there are genes to label
if (nrow(labeled_genes) > 0) {
  final_volcano_plot <- volcano_plot +
    geom_text_repel(data = labeled_genes,
                    aes(label = gene_name),
                    box.padding = 0.5,
                    point.padding = 0.5,
                    segment.color = 'grey50',
                    max.overlaps = Inf,
                    min.segment.length = 0)
} else {
  final_volcano_plot <- volcano_plot
  message("No genes found for custom labeling sets (Overlapping Between V2 and HD, Common in all layers of V2, Unique to Layer).")
}

# Display the plot
print(final_volcano_plot)

# To save the plot (optional)
# ggsave(paste0("volcano_plot_", sheet_name, ".png"), plot = final_volcano_plot, width = 10, height = 8, dpi = 300)
