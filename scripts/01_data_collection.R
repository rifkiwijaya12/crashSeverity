#define scope of research (time period)
years <- 2020:2024

#load dataset from stats19
#road safety uk statistics - vehicles
vehicles_all <-data.frame()
for (year in years){
  vehicles_data <- get_stats19(year = year, type = "veh")
  vehicles_all <-bind_rows(vehicles_all, vehicles_data)
}

vehicles_selection <- vehicles_all %>%
  dplyr::select(collision_index,
                vehicle_reference,
                generic_make_model,
                vehicle_type,
                propulsion_code,
                engine_capacity_cc,
                first_point_of_impact,
                age_of_vehicle,
                age_of_driver)

#road safety uk statistics - collisions
collisions_all <- data.frame()
for (year in years){
  collisions_data <- get_stats19(year = year, type = "collision")
  collisions_all <-bind_rows(collisions_all, collisions_data)
}

collisions_selection <- collisions_all %>%
  dplyr::select(collision_index,
                location_easting_osgr,
                location_northing_osgr,
                latitude,
                longitude,
                police_force,
                speed_limit,
                local_authority_district,
                light_conditions,
                weather_conditions,
                road_surface_conditions,
                urban_or_rural_area)

#road safety uk statistics - casualties
casualties_all <- data.frame()
for (year in years){
  casualties_data <- get_stats19(year = year, type = "cas")
  casualties_all <-bind_rows(casualties_all, casualties_data)
}

casualties_selection <- casualties_all %>% 
  dplyr::select(collision_index,
                vehicle_reference,
                casualty_type,
                casualty_severity,
                age_of_casualty,
                pedestrian_location,)

#load dataset from EEA for vehicle characteristics
d_raw = d_raw_euco2 <- readRDS("D:/Github/crashSeverity/Data/Raw/d_raw_euco2.Rds")
d_raw2 = d_raw |> 
  mutate(generic_make_model = paste(Make, Commercial_name))

veh_char <- d_raw2 %>% 
  dplyr::select(Mass_kg,
                Wheelbase,
                SteeringAxle,
                OtherAxle,
                Engine_capacity,
                Engine_power,
                Fuel_type,
                generic_make_model)

veh_char <- veh_char %>%
  distinct(Engine_capacity, Fuel_type, generic_make_model, .keep_all = TRUE) %>%
  rename(propulsion_code = Fuel_type,
         engine_capacity_cc = Engine_capacity) %>%
  mutate(propulsion_code = tolower(propulsion_code))

veh_char1 <- veh_char %>%
  group_by(generic_make_model) %>%
  slice(1) %>%  # only first row that will be used
  ungroup() %>%
  dplyr::select(-propulsion_code, -engine_capacity_cc)

#load dataset from euroNCAP
f <- "D:/Github/crashSeverity/Data/Raw/Vehicles_class.xlsx"

category_vehicles <- read_excel(f)