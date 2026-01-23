#DATA PREPROCESSING FOR VEHICLE VARIABLES
#filling missing data on generic_make model with value in the same accident index
vehicles_selection <- vehicles_selection %>%
  group_by(collision_index) %>%
  mutate(generic_make_model = ifelse(generic_make_model == "Data missing or out of range", 
                                     first(na.omit(generic_make_model)), 
                                     generic_make_model)) %>%
  ungroup() %>%
  mutate(propulsion_code = tolower(propulsion_code)) %>%
  group_by(generic_make_model) %>%
  mutate(propulsion_code = ifelse(propulsion_code == "undefined", 
                                  first(na.omit(propulsion_code)), 
                                  propulsion_code)) %>%
  ungroup() %>%
  group_by(generic_make_model) %>%
  mutate(engine_capacity_cc = ifelse(is.na(engine_capacity_cc), 
                                     first(na.omit(engine_capacity_cc)), 
                                     engine_capacity_cc)) %>%
  ungroup() %>%
  mutate(propulsion_code = ifelse(propulsion_code == "heavy oil", "diesel", propulsion_code)) %>%
  mutate(propulsion_code = ifelse(propulsion_code == "hybrid electric", "petrol/electric", propulsion_code)) %>%
  filter(generic_make_model != "Data missing or out of range")


#join vehicles_all dan veh_char
vehicles_joined1 <- left_join(vehicles_selection, veh_char,
                              by = c("generic_make_model", "propulsion_code", "engine_capacity_cc"))
vehicles_joined1_succeed <- vehicles_joined1 %>% drop_na(Mass_kg)

#select failed join due to different character but similar potential meaning 
vehicles_failed_rows <- vehicles_joined1 %>%
  filter(is.na(Mass_kg)) %>%
  mutate(model_key = str_extract(generic_make_model, "[A-Z\\s]+\\d*")) %>%
  dplyr::select(-Mass_kg, -SteeringAxle, -Wheelbase, -OtherAxle, -Engine_power)

veh_char_norm <- veh_char %>%
  mutate(model_key = str_extract(generic_make_model, "[A-Z\\s]+\\d*"))

veh_char_norm_unique <- veh_char_norm %>%
  group_by(model_key, propulsion_code, engine_capacity_cc) %>%
  slice(1) %>%
  ungroup()

vehicles_joined2 <- left_join(vehicles_failed_rows, veh_char_norm_unique,
                              by = c("model_key", "propulsion_code", "engine_capacity_cc"),
                              suffix = c("", ".new")) %>%
  dplyr::select(-model_key, -generic_make_model.new)

vehicles_joined2_succeed <- vehicles_joined2 %>% drop_na(Mass_kg)

vehicles_failed2_rows <- vehicles_joined2 %>%
  filter(is.na(Mass_kg)) %>%
  dplyr::select(-Mass_kg, -SteeringAxle, -Wheelbase, -OtherAxle, -Engine_power)

vehicles_joined3_succeed <- left_join(vehicles_failed2_rows, veh_char1,
                                      by = c("generic_make_model")) %>%
  drop_na(Mass_kg)

vehicles_all_char <- bind_rows(vehicles_joined1_succeed, vehicles_joined2_succeed, vehicles_joined3_succeed)

#joining column vehicle_category on vehicles_all_char to get rating VRU
vehicles_all_char <- left_join(vehicles_all_char, category_vehicles, by = "generic_make_model")


#DATA PREPROCESSING FOR CASUALTIES
#filter casualties only 0 (pedestrian) and 1 (cyclist)
casualties_filtered <- casualties_selection %>% filter(casualty_type %in% c("Pedestrian", "Cyclist"))


#JOIN DATASET casualty and vehicles based on accident index+vehicle reference
casualties_vehicle <- left_join(casualties_filtered, vehicles_all_char,
                                by = c("collision_index", "vehicle_reference"))

#JOIN DATASET casualty_vehicle and collision to get speed limit as predictor
veh_cas_coll <- left_join(casualties_vehicle, collisions_selection,
                          by = c("collision_index"))
veh_cas_coll <- veh_cas_coll %>% drop_na(generic_make_model)
veh_cas_coll <- veh_cas_coll %>% filter(vehicle_class != "Truck")

#combinining category adjustment - weather
veh_cas_coll$weather <- case_when(
  veh_cas_coll$weather_conditions %in% c("Fine no high winds", "Fine + high winds") ~ "Fine",
  veh_cas_coll$weather_conditions %in% c("Raining no high winds", "Raining + high winds") ~ "Raining",
  veh_cas_coll$weather_conditions %in% c("Snowing no high winds", "Snowing + high winds") ~ "Snowing",
  veh_cas_coll$weather_conditions == "Fog or mist" ~ "Fog",
  veh_cas_coll$weather_conditions %in% c("Other", "Unknown") ~ NA
)

#combinining category adjustment - road_surface_conditions variable
veh_cas_coll$road_surface <-veh_cas_coll$road_surface_conditions

#data cleaning - remove missing values
veh_cas_coll$road_surface <- case_when(
  veh_cas_coll$road_surface %in% c("Data missing or out of range", "unknown (self reported)") ~ NA,
  TRUE ~ veh_cas_coll$road_surface
)

veh_cas_coll$speed_limit <- case_when(
  veh_cas_coll$speed_limit %in% c("Data missing or out of range") ~ NA,
  TRUE ~ veh_cas_coll$speed_limit
)

#convert to factor in dependent variable (y)
veh_cas_coll$casualty_severity <- factor(veh_cas_coll$casualty_severity, 
                                         levels = c("Slight", "Serious", "Fatal"), 
                                         ordered = TRUE)

#convert to factor in independent variable (x)
veh_cas_coll$speed_limit <- factor(veh_cas_coll$speed_limit,
                                   levels = c("20","30", "40", "50", "60", "70"),
                                   ordered = FALSE)
veh_cas_coll$weather <- factor(veh_cas_coll$weather)
veh_cas_coll$road_surface <- factor(veh_cas_coll$road_surface)
veh_cas_coll$vehicle_class <- factor(veh_cas_coll$vehicle_class)

#scalling data independent variable
veh_cas_coll$Mass_kg250 <- veh_cas_coll$Mass_kg / 250
veh_cas_coll$engine_capacity100 <- veh_cas_coll$engine_capacity_cc / 100
