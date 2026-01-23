#MODEL INTERPRETATION
#plot odds ratio
model_summary <- summary(model_multi_veh_road)
coef_table <- model_summary$coefficients

num_predictor <- length(coef(model_multi_veh_road))  
coef_table <- coef_table[1:num_predictor, , drop = FALSE]

# calculation of Odds Ratio
estimates_OR   <- coef_table[,"Estimate"]
std_error      <- coef_table[,"Std. Error"]
Odds_Ratio     <- exp(estimates_OR)
lower_CI  <- exp(estimates_OR - 1.96 * std_error)
upper_CI  <- exp(estimates_OR + 1.96 * std_error)

# create dataframe for ploting to ggplot
plot_df <- data.frame(
  variable    = rownames(coef_table),
  Odds_Ratio  = Odds_Ratio,
  lower       = lower_CI,
  upper       = upper_CI
)

plot_df$variable <- factor(plot_df$variable, 
                           levels = rownames(coef_table))

plot_df$variable <- as.character(plot_df$variable)

#plot of each odds ratio
ggplot(plot_df, aes(x = Odds_Ratio, y = variable)) +
  geom_point(size = 2) +
  geom_errorbarh(aes(xmin = lower, xmax = upper), height = 0.25, size = 1) +
  geom_vline(xintercept = 1, linetype = "dashed", color = "red", size = 1) +
  scale_x_log10() +
  labs(
    title = "Odds Ratio Plot (Multivariate Binary Logistic Regression)",
    x = "Odds Ratio",
    y = "Predictors"
  ) +
  theme_minimal(base_size = 14) + 
  theme(
    axis.text = element_text(color = "black", face = "bold"),
    axis.title = element_text(color = "black", face = "bold"),
    plot.title = element_text(hjust = 0.5, face = "bold", size = 16)
  )

# Average marginal effect for speed limit
ame_speed <- avg_comparisons(
  model_multi_veh_road,
  variables = "speed_group",
  vcov = "HC3"
)
summary(ame_speed)

ame_med_high <- avg_comparisons(
  model_multi_veh_road,
  variables = list(speed_group = c("Medium", "High")),
  vcov = "HC3"
)
summary(ame_med_high)

eff_speed <- ggpredict(model_multi_veh_road, terms = "speed_group")
pred_df <- data.frame(
  speed_group = eff_speed$x,
  prob = eff_speed$predicted,
  conf.low = eff_speed$conf.low,
  conf.high = eff_speed$conf.high
)

ame_df <- data.frame(
  from = c("Low", "Low", "Medium"),
  to   = c("Medium", "High", "High"),
  ame  = c(
    ame_speed$estimate[ame_speed$contrast == "Medium - Low"],
    ame_speed$estimate[ame_speed$contrast == "High - Low"],
    ame_med_high$estimate[ame_med_high$contrast == "High - Medium"]
  )
)
pred_df$speed_group <- factor(pred_df$speed_group,
                              levels = c("High", "Low", "Medium"))

ame_plot <- ame_df %>%
  left_join(pred_df, by = c("from" = "speed_group")) %>%
  rename(prob_from = prob,
         conf.low_from = conf.low,
         conf.high_from = conf.high) %>%
  left_join(pred_df, by = c("to" = "speed_group")) %>%
  rename(prob_to = prob,
         conf.low_to = conf.low,
         conf.high_to = conf.high)

ame_plot <- ame_plot %>%
  mutate(
    xmid = (as.numeric(from) + as.numeric(to)) / 2,
    ymid = (prob_from + (prob_from + ame)) / 2
  )

ggplot(pred_df, aes(x = speed_group, y = prob)) +
  geom_errorbar(aes(ymin = conf.low, ymax = conf.high), width = 0.1, size=1) +
  geom_point(size = 4, color = "steelblue") +
  # Panah AME
  geom_curve(data = ame_plot,
             aes(x = from, xend = to,
                 y = prob_from,
                 yend = prob_from + ame),
             curvature = 0.2, arrow = arrow(length = unit(0.02, "npc")),
             color = "darkred", inherit.aes = FALSE, size=1) +
  # Label AME
  geom_text(data = ame_plot,
            aes(x = xmid,
                y = ymid,
                label = paste0("+", round(ame*100, 1), " pp")),
            vjust = -0.5, color = "darkred", inherit.aes = FALSE)+
  scale_y_continuous(labels = scales::percent_format(accuracy = 1)) +
  labs(
    x = "Speed Limit Category",
    y = "Predicted Probability of KSI",
    title = "Predicted Probability & Marginal Effects of Speed Limit",
  ) +
  theme_minimal(base_size = 14)+
  theme(
    plot.title    = element_text(hjust = 0.5, face = "bold", size = 16, color = "black"),
    axis.title    = element_text(face = "bold", size = 14, color = "black"),
    axis.text     = element_text(size = 12, color = "black"),
    panel.grid    = element_line(color = "grey80")  # grid tetap abu2 biar lembut
  )


# average marginal effects for continous variables VRU rating
ame_rating <- avg_slopes(
  model_multi_veh_road,
  variables = c("Rating_VRU"),
  vcov = "HC3"  # robust SE
)
summary(ame_rating)
# VRU Rating
eff_rating <- ggpredict(model_multi_veh_road, terms = "Rating_VRU")
plot(eff_rating) +
  labs(
    x = "VRU Safety Rating",
    y = "Predicted Probability of KSI",
    title = "Predicted Probability of KSI on Vehicle Rating",
  )+
  theme(
    plot.title    = element_text(hjust = 0.5, face = "bold", size = 16, color = "black"),
    axis.title    = element_text(face = "bold", size = 14, color = "black"),
    axis.text     = element_text(size = 12, color = "black"),
    panel.grid    = element_line(color = "grey80")  # grid tetap abu2 biar lembut
  )

