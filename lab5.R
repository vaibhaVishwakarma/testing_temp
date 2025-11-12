set.seed(1005)
# Part A: Using Array 
# Create an array that stores the names of the planets and their corresponding orbital periods in days.
planets_1005 <- c("Mercury", "Venus", "Earth", "Mars", "Jupiter", "Saturn", "Uranus", "Neptune")
orbital_periods_days_1005 <- c(88, 225, 365, 687, 4333, 10759, 30687, 60190)

# Combining into a 2D array for planets and periods
solar_array <- array(c(planets_1005, orbital_periods_days_1005), dim = c(8, 2))
dimnames(solar_array) <- list(NULL, c("Planet", "Orbital_Period_Days"))

# Display the orbital period of Earth using array indexing
earth_index <- which(solar_array[, "Planet"] == "Earth")
earth_orbital_period <- solar_array[earth_index, "Orbital_Period_Days"]
print(paste("Orbital period of Earth:", earth_orbital_period, "days"))

# Part B: Using Matrix 
# Create a numeric matrix that stores the diameter (in km) and distance from Sun (in million km) for all 8 planets.
diameters_km <- c(4879, 12104, 12742, 6779, 139820, 116460, 50724, 49244)
distances_million_km <- c(57.9, 108.2, 149.6, 227.9, 778.5, 1432, 2867, 4515)

solar_matrix <- matrix(c(diameters_km, distances_million_km), nrow = 8, ncol = 2)
colnames(solar_matrix) <- c("Diameter_km", "Distance_MillionKm")
rownames(solar_matrix) <- planets_1005

# Extract and display the values for the outer planets (Jupiter to Neptune)
outer_planets_matrix <- solar_matrix[5:8, ]
print("Outer planets matrix:")
print(outer_planets_matrix)

# Part C: Using List 
# Create a list that stores the following information for Earth
earth_list_1005 <- list(
  Name = "Earth",
  Diameter_km = 12742,
  Distance_MillionKm = 149.6,
  Number_of_Moons = 1
)

# Access and display each element of the list separately
print("Earth List Elements:")
print(paste("Name:", earth_list_1005$Name))
print(paste("Diameter (km):", earth_list_1005$Diameter_km))
print(paste("Distance from Sun (million km):", earth_list_1005$Distance_MillionKm))
print(paste("Number of moons:", earth_list_1005$Number_of_Moons))

# Part D: Using Data Frame 
# Create a data frame with the specified columns
solar_df_1005 <- data.frame(
  Planet = planets_1005,
  Diameter_km = diameters_km,
  Distance_MillionKm = distances_million_km,
  Orbital_Period_days = orbital_periods_days_1005,
  No_of_Moons = c(0, 0, 1, 2, 95, 146, 28, 16)
)

# Display all terrestrial planets (Mercury, Venus, Earth, Mars)
terrestrial_planets_1005 <- solar_df_1005[solar_df_1005$Planet %in% c("Mercury", "Venus", "Earth", "Mars"), ]
print("Terrestrial Planets:")
print(terrestrial_planets_1005)

# Find and display the planet with the maximum number of moons
max_moons_planet_1005 <- solar_df_1005[which.max(solar_df_1005$No_of_Moons), ]
print("Planet with maximum number of moons:")
print(max_moons_planet_1005)

# Sort planets in ascending order of their distance from the Sun
sorted_by_distance_1005 <- solar_df_1005[order(solar_df_1005$Distance_MillionKm), ]
print("Planets sorted by distance from Sun:")
print(sorted_by_distance_1005)

# Part E: User-Defined Functions 
# 1. Function that converts orbital period in days to Earth years (365 days = 1 year)
convert_to_years_1005 <- function(days) {
  return(days / 365)
}

# Apply it to all planets and add as a new column
solar_df_1005$Orbital_Period_years <- sapply(solar_df_1005$Orbital_Period_days, convert_to_years_1005)
print("Data Frame with Orbital Period in Years:")
print(solar_df_1005)

#' Planet Properties Summary
#' @param planet_name Character string of the planet name (case-sensitive).
#' @return Formatted string summary or "Planet not found."
#' @examples
#' planet_summary_XXXX("Earth")
#' "Planet: Earth Diameter (km): 12742 Distance from Sun (million km): 149.6 Number of moons: 1"
planet_summary_1005 <- function(planet_name) {
  planet_data <- solar_df_1005[solar_df_1005$Planet == planet_name, ]
  if (nrow(planet_data) == 0) {
    return("Planet not found.")
  }
  summary <- paste(
    "Planet:", planet_data$Planet,
    "\nDiameter (km):", planet_data$Diameter_km,
    "\nDistance from Sun (million km):", planet_data$Distance_MillionKm,
    "\nNumber of moons:", planet_data$No_of_Moons
  )
  return(summary)
}

# Example usage
print("Summary for Earth:")
print(planet_summary_1005("Earth"))

# 3. Function to find Kepler k for all the planets
# Note: Convert distance to AU (1 AU = 149.6 million km)
kepler_k_1005 <- function(period_years, distance_million_km) {
  distance_au <- distance_million_km / 149.6
  return(period_years^2 / distance_au^3)
}

# Apply to data frame
solar_df_1005$Kepler_k <- mapply(kepler_k_1005, solar_df_1005$Orbital_Period_years, solar_df_1005$Distance_MillionKm)
print("Data Frame with Kepler k:")
print(solar_df_1005)
