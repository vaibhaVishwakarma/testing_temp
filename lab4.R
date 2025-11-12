zone_name_1005 = paste("Zone", 1:20)
rainfall_mm_1005 = sample(50:500, 20, replace = TRUE)
drainage_capacity_1005 = sample(30:500, 20, replace = TRUE)
population_1005 = sample(1000:9000, 20, replace = TRUE)
water_logging_cm_1005 = sample(50:200, 20, replace = TRUE)
green_cover_percent_1005 = sample(10:45, 20, replace = TRUE)


city_flood_data_1005 = list(
  zone_name = zone_name_1005,
  rainfall_mm = rainfall_mm_1005,
  drainage_capacity = drainage_capacity_1005,
  population = population_1005,
  water_logging_cm = water_logging_cm_1005,
  green_cover_percent = green_cover_percent_1005
)


display_data_structure_1005 = function(city_flood_data_1005) {
  print(city_flood_data_1005)
  str(city_flood_data_1005)
}


highest_rainfall_zone_1005 = city_flood_data_1005$zone_name[which.max(city_flood_data_1005$rainfall_mm)]
avg_water_logging_1005 = mean(city_flood_data_1005$water_logging_cm)
below_avg_green_cover_zones_1005 = city_flood_data_1005$zone_name[
  city_flood_data_1005$green_cover_percent < mean(city_flood_data_1005$green_cover_percent)
]
sorted_population_zones_1005 = city_flood_data_1005$zone_name[
  order(city_flood_data_1005$population, decreasing = TRUE)
]


#' Assess Flood Risk Level
#' @param rainfall Numeric. Rainfall received in millimeters.
#' @param drainage Numeric. Drainage capacity in millimeters.
#' @return Character string. One of "High", "Moderate", or "Low" indicating flood risk level.




assess_flood_risk_1005 = function(rainfall, drainage) {
  diff = rainfall - drainage
  if (diff > 200) {
    return("High")
  } else if (diff > 50) {
    return("Moderate")
  } else {
    return("Low")
  }
}


#' Suggest Mitigation Strategy
#' @param green_cover Numeric. Percentage of green cover in the zone.
#' @param population Numeric. Total population in the zone.
#' @return Character string. One of "Increase Tree Plantation", "Install Rain Gardens", or "Create Green Roofs".


suggest_mitigation_1005 = function(green_cover, population) {
  if (green_cover < 20 && population > 5000) {
    return("Increase Tree Plantation")
  } else if (green_cover < 30) {
    return("Install Rain Gardens")
  } else {
    return("Create Green Roofs")
  }
}


risk_level_1005 = mapply(assess_flood_risk_1005,
                          city_flood_data_1005$rainfall_mm,
                          city_flood_data_1005$drainage_capacity)


mitigation_suggestion_1005 = mapply(suggest_mitigation_1005,
                                     city_flood_data_1005$green_cover_percent,
                                     city_flood_data_1005$population)


city_flood_data_1005$risk_level = risk_level_1005
city_flood_data_1005$mitigation_suggestion = mitigation_suggestion_1005


adjusted_water_logging_cm_1005 = ifelse(
  city_flood_data_1005$green_cover_percent > 30,
  city_flood_data_1005$water_logging_cm * 0.8,
  city_flood_data_1005$water_logging_cm
)


severity_index_1005 = (city_flood_data_1005$rainfall_mm -
                          city_flood_data_1005$drainage_capacity +
                          adjusted_water_logging_cm_1005) /
  city_flood_data_1005$population


city_flood_data_1005$adjusted_water_logging_cm = adjusted_water_logging_cm_1005
city_flood_data_1005$severity_index = severity_index_1005


high_risk_indices_1005 = which(severity_index_1005 > 0.05)


high_risk_summary_1005 = data.frame(
  Zone = city_flood_data_1005$zone_name[high_risk_indices_1005],
  Severity_Index = round(severity_index_1005[high_risk_indices_1005], 4),
  Mitigation = city_flood_data_1005$mitigation_suggestion[high_risk_indices_1005]
)


display_data_structure_1005(city_flood_data_1005)
print(paste("Zone with Highest Rainfall:", highest_rainfall_zone_1005))
print(paste("Average Water Logging (cm):", round(avg_water_logging_1005, 2)))
print("Zones with Below-Average Green Cover:")
print(below_avg_green_cover_zones_1005)
print("Zones Sorted by Population (Descending):")
print(sorted_population_zones_1005)
print("--- High Risk Zone Summary ---")
print(high_risk_summary_1005)