#DEPENDENT VARIABLE
#adjustment on casualty_severity become binary slight = 0 and serious/fatal= 1
veh_cas_coll$ksi_severity <- ifelse(veh_cas_coll$casualty_severity == "Slight", 0, 1)

#INDEPENDENT VARIABLES
#adjustment speed limit category (1)
veh_cas_coll <- veh_cas_coll %>%
  mutate(speed_limit = as.numeric(as.character(speed_limit)),
         speed_group = case_when(
           speed_limit == 20 ~ "Low",
           speed_limit == 30 ~ "Medium",
           speed_limit >= 40 ~ "High",
           TRUE ~ NA_character_
         )) %>%
  mutate(speed_group = factor(speed_group, levels = c("Low", "Medium", "High")))

#combine road surface group, become binary dry vs non dry (2)
veh_cas_coll <- veh_cas_coll %>%
  mutate(road_surface_group = case_when(
    road_surface == "Dry" ~ "Dry",
    road_surface %in% c("Wet or damp", "Frost or ice", "Snow", "Flood over 3cm. deep") ~ "Non-dry",
    TRUE ~ NA_character_
  )) %>%
  mutate(road_surface_group = factor(road_surface_group, levels = c("Dry", "Non-dry")))

#combine weather  group, become binary Fine vs not fine (3)
veh_cas_coll <- veh_cas_coll %>%
  mutate(weather_group = case_when(
    weather == "Fine" ~ "Fine",
    weather %in% c("Raining", "Fog", "Snowing") ~ "Not fine",
    TRUE ~ NA_character_
  )) %>%
  mutate(weather_group = factor(weather_group, levels = c("Fine", "Not fine")))

#delete other useless category first point of impact (4),
veh_cas_coll <- veh_cas_coll %>%
  mutate(impact_group = case_when(
    first_point_of_impact == "Front" ~ "Front",
    first_point_of_impact == "Nearside" ~ "Nearside",
    first_point_of_impact == "Offside" ~ "Offside",
    first_point_of_impact == "Back" ~ "Back",
    TRUE ~ NA_character_
  )) %>%
  mutate(impact_group = factor(impact_group, levels = c("Front", "Nearside", "Offside", "Back")))

#define category into urban or rural only (5),
veh_cas_coll <- veh_cas_coll %>%
  mutate(urban_rural = ifelse(
    urban_or_rural_area %in% c("Unallocated", "Data missing or out of range"),
    NA,
    urban_or_rural_area
  ))

# check outlier of independent variable with continuous data
#Mass vehicle (6)
ggplot(veh_cas_coll, aes(y = Mass_kg250)) +
  geom_boxplot() +
  theme_minimal()

#replace outlier of Mass_kg with NA
veh_cas_coll <- veh_cas_coll %>%
  mutate(
    Mass_kg_raw = Mass_kg250,
    Mass_kg250 = ifelse(
      Mass_kg250 < quantile(Mass_kg_raw, 0.25, na.rm = TRUE) - 1.5 * IQR(Mass_kg_raw, na.rm = TRUE) |
        Mass_kg250 > quantile(Mass_kg_raw, 0.75, na.rm = TRUE) + 1.5 * IQR(Mass_kg_raw, na.rm = TRUE),
      NA,
      Mass_kg_raw
    )
  )

#Rating VRU (7)
ggplot(veh_cas_coll, aes(y = Rating_VRU)) +
  geom_boxplot() +
  theme_minimal()

#replace outlier of Rating VRU with NA
veh_cas_coll <- veh_cas_coll %>%
  mutate(
    Rating_VRU_raw = Rating_VRU,
    Rating_VRU = ifelse(
      Rating_VRU < quantile(Rating_VRU_raw, 0.25, na.rm = TRUE) - 1.5 * IQR(Rating_VRU_raw, na.rm = TRUE) |
        Rating_VRU > quantile(Rating_VRU_raw, 0.75, na.rm = TRUE) + 1.5 * IQR(Rating_VRU_raw, na.rm = TRUE),
      NA,
      Rating_VRU_raw
    )
  )

#engine_capacity_cc (8)
ggplot(veh_cas_coll, aes(y = engine_capacity100)) +
  geom_boxplot() +
  theme_minimal()

#replace outlier of engine_capacity_cc with NA
veh_cas_coll <- veh_cas_coll %>%
  mutate(
    engine_capacity_cc_raw = engine_capacity100,
    engine_capacity100 = ifelse(
      engine_capacity100 < quantile(engine_capacity_cc_raw, 0.25, na.rm = TRUE) - 1.5 * IQR(engine_capacity_cc_raw, na.rm = TRUE) |
        engine_capacity100 > quantile(engine_capacity_cc_raw, 0.75, na.rm = TRUE) + 1.5 * IQR(engine_capacity_cc_raw, na.rm = TRUE),
      NA,
      engine_capacity_cc_raw
    )
  )

#age_of_casualty (9)
ggplot(veh_cas_coll, aes(y = age_of_casualty)) +
  geom_boxplot() +
  theme_minimal()

#replace outlier of age_0f_casualty with NA
veh_cas_coll <- veh_cas_coll %>%
  mutate(
    age_of_casualty_raw = age_of_casualty,
    age_of_casualty = ifelse(
      age_of_casualty < quantile(age_of_casualty_raw, 0.25, na.rm = TRUE) - 1.5 * IQR(age_of_casualty_raw, na.rm = TRUE) |
        age_of_casualty > quantile(age_of_casualty_raw, 0.75, na.rm = TRUE) + 1.5 * IQR(age_of_casualty_raw, na.rm = TRUE),
      NA,
      age_of_casualty_raw
    )
  )

#data cleaning on each variable
veh_cas_clean <- veh_cas_coll %>% drop_na(
  Rating_VRU, Mass_kg250, engine_capacity100,
  age_of_casualty, speed_group, weather_group,
  road_surface_group,impact_group,urban_rural
)
