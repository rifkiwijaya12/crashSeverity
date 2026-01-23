#Determine Model Variable
#Model 0 - multivariate binary logistic variable (confounding factor)
model_multi_con <- glm(
  ksi_severity ~  age_of_casualty +weather_group+road_surface_group+impact_group+urban_rural,
  data = veh_cas_clean,
  family = "binomial"
)

exp(coef(model_multi_con)) 

summary(model_multi_con)

#Model 1 - multivariate binary logistic variable (confounding factor + vehicle)
model_multi_veh <- glm(
  ksi_severity ~  Rating_VRU+ Mass_kg250+engine_capacity100+ age_of_casualty+
    weather_group+road_surface_group+impact_group+urban_rural,
  data = veh_cas_clean,
  family = "binomial"
)

exp(coef(model_multi_veh)) 

summary(model_multi_veh)

#Model 2 - multivariate binary logistic variable (confounding factor + vehicle + environment)
model_multi_veh_road <- glm(
  ksi_severity ~  Rating_VRU+ Mass_kg250+engine_capacity100+
    speed_group+
    age_of_casualty + +weather_group+road_surface_group+impact_group+urban_rural,,
  data = veh_cas_clean,
  family = "binomial"
)

exp(coef(model_multi_veh_road)) 

summary(model_multi_veh_road)
