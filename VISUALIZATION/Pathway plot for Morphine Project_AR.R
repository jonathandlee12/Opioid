# Title: NES Dot Plot for Single Layer Enrichment Results

# --- 1. Install and Load Necessary Packages ---
# If you don't have these packages installed, run the install.packages() commands below.
# You only need to install them once per R environment.
# install.packages("ggplot2")
# install.packages("dplyr")     # For data manipulation (e.g., calculating average NES)
# install.packages("readxl")    # To read data from Excel files
# install.packages("stringr")   # For wrapping long text labels
#install.packages("viridis")   # For perceptually uniform color scales (for padj)

# Load the packages. You need to do this every time you start a new R session
# and want to use functions from these packages.
library(ggplot2)
library(dplyr)
library(readxl)
library(stringr) # Load for string manipulation, specifically for str_wrap()
library(viridis) # For viridis color scales

# --- 2. Load Your Data from Excel ---

my_data <- read_excel("C:\\Users\\arai2\\Desktop\\Morphine project\\txt file_morphine\\Morphine_RNAseqdata.xlsx") # Replace with your Excel filename
  
my_data <- read_excel("C:\\Users\\arai2\\Desktop\\Morphine project\\txt file_morphine\\Morphine_RNAseqdata.xlsx", sheet = "Fgsea_old_vs_Young_rev") # or sheet = "fgsea_old_saline_morphine_rev"
  


# --- 3. Data Preparation ---
# Clamp padj values to avoid -Inf when taking -log10(padj)
# If padj is 0, setting it to a very small number like 1e-300 allows log transformation.
my_data$padj_clamped <- pmax(my_data$padj, 1e-300)
my_data$neg_log10_padj <- -log10(my_data$padj_clamped)

# Calculate the mean NES for each pathway for sorting
# Since we are assuming one layer per sheet, this is effectively just the NES for that pathway.
pathway_order <- my_data %>%
  group_by(pathway) %>%
  summarise(mean_NES = mean(NES, na.rm = TRUE)) %>%
  arrange(mean_NES) # Arrange in ASCENDING order of NES (lowest NES at the top)

# Convert 'pathway' to a factor with the desired order.
my_data$pathway <- factor(my_data$pathway, levels = pathway_order$pathway)

# Determine the layer name for the plot title (assuming it's consistent in the data)
#plot_layer <- unique(my_data$layer)[1] # Gets the first unique layer name


# --- 4. Create the Dot Plot using ggplot2 ---

p <- ggplot(my_data, aes(x = NES, y = pathway)) + # NES on x-axis, pathway on y-axis
  # Add points (circles) to the plot
  geom_point(aes(size = size, fill = neg_log10_padj), # Fill with -log10(padj)
             shape = 21, # Shape 21 allows for both fill and stroke
             color = "black", # Set a black stroke for the circles
             stroke = 0.5) + # Stroke width for the circle border
  
  # Add a solid vertical line at X = 0
  geom_vline(xintercept = 0, linetype = "solid", color = "black", size = 0.5) +
  
  # Set the fill color scale for -log10(padj)
  # Changed to a blue (low) to red (high) gradient for -log10(padj)
  scale_fill_gradient(low = "blue", high = "red", name = "-log10(padj)") +
  
  # Set the size scale for Gene Set Size
  scale_size_area(max_size = 10, name = "Gene Set Size", # Max size of circles
                  breaks = c(30, 80, 150, 250)) + # Adjust breaks based on your actual data's 'size' range
  
  
  # Add labels for axes and title for the plot
  labs(
    title = paste0("Old vs Young, Saline "), # Dynamic title with layer name
    x = "Normalized Enrichment Score (NES)", # X-axis label
    y = "Pathway" # Y-axis label
  ) +
  
  # Customize the Y-axis text for wrapping long pathway names
  scale_y_discrete(labels = function(x) str_wrap(x, width = 40)) + # Wraps labels at 35 characters
  
  # Customize the theme for a cleaner look
  theme_minimal() + # A clean, minimalist theme
  theme(
    plot.title = element_text(hjust = 0.5, size = 16, face = "bold"), # Center and style title
    axis.text.x = element_text(size = 10), # X-axis text appearance
    axis.text.y = element_text(size = 10), # Y-axis text appearance
    axis.title = element_text(face = "bold", size = 12), # Axis title style
    panel.grid.major = element_line(color = "#e0e0e0", linetype = "dashed"), # Dashed grid lines
    panel.grid.minor = element_blank(), # Remove minor grid lines
    legend.position = "top", # Legends at the top
    legend.box = "horizontal", # Arrange legends horizontally
    legend.title = element_text(face = "bold", size = 11), # Legend title style
    legend.text = element_text(size = 10), # Legend text style
    axis.line = element_line(color = "black") # Add axis lines for better definition
  )

# Explicitly print the plot object to display it in the RStudio plot pane
print(p)

# --- 5. Save Your Plot (Optional) ---
# You can save the plot to a file (e.g., PNG, PDF) if you need it outside RStudio.
# Uncomment the line below to save the plot.
# ggsave(paste0("spot_plot_", plot_layer, ".png"), plot = p, width = 10, height = 8, dpi = 300)
# ggsave(paste0("spot_plot_", plot_layer, ".pdf"), plot = p, width = 10, height = 8) # For vector graphics
