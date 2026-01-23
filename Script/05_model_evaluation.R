#MODEL EVALUATION
pR2_values <- c(
  model0 = pR2(model_multi_con)["McFadden"],
  model1 = pR2(model_multi_veh)["McFadden"],
  model2 = pR2(model_multi_veh_road)["McFadden"]
)

AIC_values <- c(
  model0 = AIC(model_multi_con),
  model1 = AIC(model_multi_veh),
  model2 = AIC(model_multi_veh_road)
)


comparison_table <- data.frame(
  Model_0 = c(pR2(model_multi_con)["McFadden"], AIC(model_multi_con)),
  Model_1 = c(pR2(model_multi_veh)["McFadden"], AIC(model_multi_veh)),
  Model_2 = c(pR2(model_multi_veh_road)["McFadden"], AIC(model_multi_veh_road))
)

rownames(comparison_table) <- c("McFadden R²", "AIC")

print(comparison_table)

#Convergence
model_multi_veh_road$converged

# multi collinearity
check_collinearity(model_multi_veh_road)
