set.seed(1005)


# Create city information
cities <- c(
  # North America (10)
  "New York", "Los Angeles", "Chicago", "Toronto", "Mexico City",
  "Vancouver", "Montreal", "San Francisco", "Boston", "Washington DC",
 
  # Europe (12)
  "London", "Paris", "Berlin", "Madrid", "Rome", "Amsterdam",
  "Stockholm", "Copenhagen", "Vienna", "Zurich", "Barcelona", "Prague",
 
  # Asia (15)
  "Tokyo", "Seoul", "Singapore", "Hong Kong", "Shanghai", "Beijing",
  "Mumbai", "Delhi", "Bangkok", "Kuala Lumpur", "Manila", "Jakarta",
  "Osaka", "Taipei", "Dubai",
 
  # South America (5)
  "São Paulo", "Buenos Aires", "Rio de Janeiro", "Bogotá", "Lima",
 
  # Africa (5)
  "Cairo", "Lagos", "Cape Town", "Johannesburg", "Nairobi",
 
  # Oceania (3)
  "Sydney", "Melbourne", "Auckland"
)


countries <- c(
  # North America
  "United States", "United States", "United States", "Canada", "Mexico",
  "Canada", "Canada", "United States", "United States", "United States",
 
  # Europe
  "United Kingdom", "France", "Germany", "Spain", "Italy", "Netherlands",
  "Sweden", "Denmark", "Austria", "Switzerland", "Spain", "Czech Republic",
 
  # Asia
  "Japan", "South Korea", "Singapore", "Hong Kong", "China", "China",
  "India", "India", "Thailand", "Malaysia", "Philippines", "Indonesia",
  "Japan", "Taiwan", "United Arab Emirates",
 
  # South America
  "Brazil", "Argentina", "Brazil", "Colombia", "Peru",
 
  # Africa
  "Egypt", "Nigeria", "South Africa", "South Africa", "Kenya",
 
  # Oceania
  "Australia", "Australia", "New Zealand"
)


continents <- c(
  # North America (10)
  rep("North America", 10),
 
  # Europe (12)
  rep("Europe", 12),
 
  # Asia (15)
  rep("Asia", 15),
 
  # South America (5)
  rep("South America", 5),
 
  # Africa (5)
  rep("Africa", 5),
 
  # Oceania (3)
  rep("Oceania", 3)
)


# Create initial dataframe
city_data <- data.frame(
  city = cities,
  country = countries,
  continent = continents,
  stringsAsFactors = FALSE
)


print(paste("Created dataset with", nrow(city_data), "cities"))
print("Distribution by continent:")
print(table(city_data$continent))


# Population in millions
population_values <- c(
  # North America
  18.8, 12.4, 9.5, 6.3, 22.5, 2.6, 4.3, 4.7, 4.9, 6.4,
 
  # Europe  
  9.6, 11.2, 3.7, 6.7, 4.3, 2.4, 2.4, 2.1, 1.9, 1.4, 5.6, 2.7,
 
  # Asia
  37.4, 9.7, 5.9, 7.5, 28.5, 21.0, 20.7, 32.9, 10.9, 8.6, 12.9, 10.8, 18.9, 7.0, 3.5,
 
  # South America
  22.6, 15.6, 12.3, 11.3, 10.7,
 
  # Africa
  21.3, 15.4, 4.6, 5.6, 5.1,
 
  # Oceania
  5.4, 5.2, 1.7
)


city_data$population_millions <- population_values


density_by_continent <- function(continent) {
  switch(continent,
         "Asia" = runif(1, 8000, 20000),
         "Europe" = runif(1, 3000, 8000),
         "North America" = runif(1, 1000, 5000),
         "South America" = runif(1, 4000, 12000),
         "Africa" = runif(1, 2000, 10000),
         "Oceania" = runif(1, 1500, 4000)
  )
}


city_data$density_km2 <- round(sapply(city_data$continent, density_by_continent))


age_by_continent <- function(continent) {
  switch(continent,
         "Europe" = runif(1, 40, 45),
         "North America" = runif(1, 35, 42),
         "Asia" = runif(1, 30, 40),
         "Oceania" = runif(1, 35, 40),
         "South America" = runif(1, 28, 35),
         "Africa" = runif(1, 25, 32)
  )
}


city_data$median_age <- round(sapply(city_data$continent, age_by_continent), 1)


gdp_by_city <- function(city_name, continent) {
  if(city_name %in% c("Zurich", "Singapore", "San Francisco", "Copenhagen", "Stockholm", "Boston", "Vienna", "Amsterdam", "Sydney", "Hong Kong", "Dubai")) {
    return(runif(1, 45000, 80000))
  }
 
  if(continent == "Europe") return(runif(1, 35000, 55000))
  if(continent == "North America") return(runif(1, 40000, 65000))
  if(continent == "Asia") return(runif(1, 15000, 45000))
  if(continent == "Oceania") return(runif(1, 45000, 55000))
  if(continent == "South America") return(runif(1, 8000, 18000))
  if(continent == "Africa") return(runif(1, 5000, 15000))
  return(30000) # default
}


city_data$gdp_per_capita_usd <- round(mapply(gdp_by_city, city_data$city, city_data$continent))


transit_by_city <- function(city_name, continent) {
  # High-transit cities
  if(city_name %in% c("Singapore", "Hong Kong", "Zurich", "Tokyo", "Seoul", "Vienna", "Copenhagen", "Amsterdam", "Stockholm", "Berlin", "Paris", "London")) {
    return(runif(1, 75, 95))
  }
  if(continent %in% c("North America", "Africa", "South America")) {
    return(runif(1, 30, 70))
  } else {
    return(runif(1, 50, 80))
  }
}


city_data$public_transit_score <- round(mapply(transit_by_city, city_data$city, city_data$continent), 1)


green_by_city <- function(city_name, continent) {
 
  if(city_name %in% c("Stockholm", "Copenhagen", "Vienna", "Sydney", "Melbourne", "Vancouver", "Auckland", "Zurich")) {
    return(runif(1, 18, 35))
  }
 
  if(continent %in% c("Asia", "Africa")) {
    return(runif(1, 5, 15))
  } else {
    return(runif(1, 8, 18))
  }
}


city_data$green_space_pct <- round(mapply(green_by_city, city_data$city, city_data$continent), 1)


# Air quality index (higher is worse)
city_data$air_quality_index <- round(
  # Base pollution from density
  (city_data$density_km2 / 1000) * 8 +
    # Inverse relationship with GDP
    (100000 / city_data$gdp_per_capita_usd) * 30 +
    # Inverse relationship with green space
    (30 / city_data$green_space_pct) * 5 +
    # Random noise
    rnorm(nrow(city_data), 0, 15), 1
)


# Ensure realistic AQI range
city_data$air_quality_index <- pmax(20, pmin(200, city_data$air_quality_index))


# Average commute time
city_data$avg_commute_time_min <- round(
  # Reduced by good transit
  -city_data$public_transit_score * 0.3 +
    # Random variation
    rnorm(nrow(city_data), 0, 8), 1
)


# Ensure realistic commute time range
city_data$avg_commute_time_min <- pmax(15, pmin(80, city_data$avg_commute_time_min))


# Happiness index (0-10) - comprehensive quality of life measure
continent_happiness_bonus <- c(
  "Europe" = 7, "Oceania" = 7.5, "North America" = 5,
  "Asia" = 4, "South America" = 5, "Africa" = 3
)


city_data$happiness_index <- round(
  # Base happiness from GDP
  (city_data$gdp_per_capita_usd / 10000) * 1.2 +
    # Bonus from green space
    city_data$green_space_pct * 0.05 +
    # Bonus from good transit
    city_data$public_transit_score * 0.02 +
    # Random variation
    rnorm(nrow(city_data), 0, 0.8), 2
)


# Ensure happiness stays within 1-10 range
city_data$happiness_index <- pmax(1, pmin(10, city_data$happiness_index))


# Introduce strategic missing values (about 3-4% missing data)
missing_columns <- c("median_age", "public_transit_score", "green_space_pct",
                     "air_quality_index", "avg_commute_time_min", "density_km2")




target_missing_n = round(nrow(city_data)*0.08) # 8% missing values


for(col in missing_columns) {
  missing_indices <- sample(nrow(city_data), target_missing_n, replace = FALSE)
  city_data[[col]][missing_indices] <- NA
 
}


cat("\nMissing values introduced:\n")
missing_summary <- sapply(city_data, function(x) sum(is.na(x)))
print(missing_summary)


write.csv(city_data, "city_metrics.csv", row.names = FALSE)










# Section A: Data Preparation & Initial Exploration
city_data <- read.csv("city_metrics.csv", stringsAsFactors = FALSE)
str(city_data)
summary(city_data)
sapply(city_data, function(x) sum(is.na(x)))


numeric_cols <- c("population_millions", "density_km2", "median_age", "gdp_per_capita_usd",
                  "public_transit_score", "green_space_pct", "air_quality_index",
                  "avg_commute_time_min", "happiness_index")


for (col in numeric_cols) {
  is_missing <- is.na(city_data[[col]])
  median_val <- median(city_data[[col]], na.rm = TRUE)
  city_data[[col]][is_missing] <- median_val
}

justification
since only 8% values are missing, imputing with median offers preservation of central tendency.



# Verify no missing values remain
sapply(city_data, function(x) sum(is.na(x)))




city_data$size_category <- factor(
  ifelse(city_data$population_millions < 5, "Small",
         ifelse(city_data$population_millions <= 10, "Medium", "Large")),
  levels = c("Small", "Medium", "Large")
)


# Section B: Univariate & Bivariate Visualizations
hist(city_data$gdp_per_capita_usd, main = "Distribution of GDP per Capita (USD)",
     xlab = "GDP per Capita (USD)", col = "lightblue", breaks = 15, freq = FALSE)
lines(density(city_data$gdp_per_capita_usd), col = "red", lwd = 2)


boxplot(happiness_index ~ continent, data = city_data,
        main = "Happiness Index by Continent", xlab = "Continent", ylab = "Happiness Index",
        col = rainbow(length(unique(city_data$continent))))


plot(city_data$gdp_per_capita_usd, city_data$air_quality_index,
     main = "GDP per Capita vs. Air Quality Index", xlab = "GDP per Capita (USD)",
     ylab = "Air Quality Index (Higher is Worse)", pch = 19, col = "blue")




# Section C: Multivariate & Advanced Visualizations
plot(city_data$gdp_per_capita_usd, city_data$air_quality_index,
     main = "GDP per Capita vs. Air Quality Index by Size Category",
     xlab = "GDP per Capita (USD)", ylab = "Air Quality Index (Higher is Worse)",
     pch = 19, col = as.integer(city_data$size_category))
legend("topright", legend = levels(city_data$size_category), col = 1:3, pch = 19)


library(plotly)
library(magrittr)


plot_ly(data = city_data, x = ~green_space_pct, y = ~happiness_index, type = "scatter", mode = "markers",
        text = ~paste("City:", city, "<br>Country:", country, "<br>Green Space %:", green_space_pct,
                      "<br>Happiness Index:", happiness_index)) %>%
  layout(title = "Happiness Index vs. Green Space Percentage",
         xaxis = list(title = "Green Space %"), yaxis = list(title = "Happiness Index"))