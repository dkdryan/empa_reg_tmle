# =============================================================================
# FOREST PLOT: EMPA-REG RCT VS REAL-WORLD TRIAL EMULATION
# =============================================================================

library(ggplot2)
library(dplyr)
library(tibble)


# =============================================================================
# 1. DATA
# =============================================================================

forest_data <- tribble(
  ~method,                          ~measure, ~estimate, ~lower, ~upper,
  "RCT",                            "HR",      0.69,      0.57,   0.82,
  "Unadjusted Cox Model",           "HR",      0.33,      0.27,   0.41,
  "Unadjusted Cox Model",           "RR",      0.35,      0.29,   0.43,
  "Regression adjusted Cox Model",  "HR",      0.60,      0.48,   0.76,
  "Regression adjusted Cox Model",  "RR",      0.66,      0.53,   0.80,
  "IPTW Cox Model",                 "HR",      0.39,      0.29,   0.53,
  "Parametric TMLE",                "RR",      0.55,      0.47,   0.65,
  "Superlearner TMLE",              "RR",      0.55,      0.48,   0.63
)


# =============================================================================
# 2. FORMAT VARIABLES
# =============================================================================

forest_data <- forest_data %>%
  mutate(
    
    # Order methods from TOP to BOTTOM
    method = factor(
      method,
      levels = rev(c(
        "RCT",
        "Unadjusted Cox Model",
        "Regression adjusted Cox Model",
        "IPTW Cox Model",
        "Parametric TMLE",
        "Superlearner TMLE"
      ))
    ),
    
    # HR first, RR second
    measure = factor(
      measure,
      levels = c("HR", "RR")
    ),
    
    # Effect estimate text
    result_label = sprintf(
      "%.2f (%.2f, %.2f)",
      estimate,
      lower,
      upper
    )
  )


# =============================================================================
# 3. RCT CI LIMITS
# =============================================================================

rct_lower <- 0.57
rct_upper <- 0.82


# =============================================================================
# 4. POSITION HR AND RR WITHIN EACH METHOD
# =============================================================================

pd <- position_dodge(width = 0.55)


# =============================================================================
# 5. FOREST PLOT
# =============================================================================

forest_plot <- ggplot(
  forest_data,
  aes(
    x = estimate,
    y = method,
    colour = measure,
    group = measure
  )
) +
  
  # ---------------------------------------------------------------------------
# SHADED REGION = RCT 95% CI
# ---------------------------------------------------------------------------

geom_rect(
  aes(
    xmin = rct_lower,
    xmax = rct_upper,
    ymin = -Inf,
    ymax = Inf,
    fill = "RCT 95% CI"
  ),
  inherit.aes = FALSE,
  alpha = 0.20,
  colour = NA
) +
  
  # RCT CI boundaries
  geom_vline(
    xintercept = c(rct_lower, rct_upper),
    linetype = "dotted",
    colour = "grey55",
    linewidth = 0.5
  ) +
  
  # ---------------------------------------------------------------------------
# NULL EFFECT
# ---------------------------------------------------------------------------

geom_vline(
  xintercept = 1,
  linetype = "dashed",
  colour = "grey35",
  linewidth = 0.6
) +
  
  # ---------------------------------------------------------------------------
# 95% CONFIDENCE INTERVALS
# ---------------------------------------------------------------------------

geom_errorbarh(
  aes(
    xmin = lower,
    xmax = upper
  ),
  height = 0,
  linewidth = 0.8,
  position = pd
) +
  
  # ---------------------------------------------------------------------------
# POINT ESTIMATES
# ---------------------------------------------------------------------------

geom_point(
  size = 3.2,
  position = pd
) +
  
  # ---------------------------------------------------------------------------
# NUMERICAL ESTIMATES ON RIGHT
# ---------------------------------------------------------------------------

geom_text(
  aes(
    x = 1.12,
    label = result_label
  ),
  position = pd,
  hjust = 0,
  colour = "black",
  size = 3.5,
  show.legend = FALSE
) +
  
  # ---------------------------------------------------------------------------
# LOG SCALE
# ---------------------------------------------------------------------------

scale_x_log10(
  breaks = c(
    0.25,
    0.50,
    0.75,
    1.00
  ),
  labels = c(
    "0.25",
    "0.50",
    "0.75",
    "1.00"
  )
) +
  
  # Space for numerical estimates
  coord_cartesian(
    xlim = c(0.23, 1.65),
    clip = "off"
  ) +
  
  # ---------------------------------------------------------------------------
# HR / RR COLOURS
# ---------------------------------------------------------------------------

scale_colour_manual(
  values = c(
    "HR" = "#0072B2",
    "RR" = "#D55E00"
  ),
  labels = c(
    "HR" = "Hazard ratio",
    "RR" = "3-year risk ratio"
  ),
  name = NULL
) +
  
  # ---------------------------------------------------------------------------
# RCT CI SHADING
# ---------------------------------------------------------------------------

scale_fill_manual(
  values = c(
    "RCT 95% CI" = "grey70"
  ),
  name = NULL
) +
  
  guides(
    colour = guide_legend(
      order = 1,
      override.aes = list(size = 3)
    ),
    fill = guide_legend(
      order = 2
    )
  ) +
  
  # ---------------------------------------------------------------------------
# LABELS
# ---------------------------------------------------------------------------

labs(
  title = paste0(
    "Comparison of treatment effect estimates for EMPA-REG: ",
    "RCT versus real-world trial emulation"
  ),
  x = "Hazard ratio / 3-year risk ratio",
  y = NULL
) +
  
  # ---------------------------------------------------------------------------
# THEME
# ---------------------------------------------------------------------------

theme_classic(base_size = 12) +
  
  theme(
    
    plot.title = element_text(
      size = 14,
      face = "bold",
      hjust = 0.5,
      margin = margin(b = 15)
    ),
    
    axis.text.y = element_text(
      size = 11,
      colour = "black"
    ),
    
    axis.text.x = element_text(
      size = 10,
      colour = "black"
    ),
    
    axis.title.x = element_text(
      size = 11,
      margin = margin(t = 10)
    ),
    
    legend.position = "right",
    
    legend.justification = "center",
    
    legend.title = element_blank(),
    
    legend.text = element_text(
      size = 10
    ),
    
    legend.box.margin = margin(
      l = 45
    ),
    
    plot.margin = margin(
      t = 10,
      r = 30,
      b = 10,
      l = 10
    ),
    
    panel.grid = element_blank()
  )


# =============================================================================
# 6. DISPLAY
# =============================================================================

forest_plot


# =============================================================================
# 7. SAVE
# =============================================================================

ggsave(
  filename = "forest_plot.png",
  plot = forest_plot,
  width = 10,
  height = 5.5,
  dpi = 300
)

ggsave(
  filename = "forest_plot.pdf",
  plot = forest_plot,
  width = 10,
  height = 5.5
)

ggsave(
  filename = "forest_plot.tiff",
  plot = forest_plot,
  width = 10,
  height = 5.5,
  dpi = 600,
  compression = "lzw"
)
