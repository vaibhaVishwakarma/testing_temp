Okay, I will read the `readme.md` file and then provide explanations and demo snippets for the first five topics you mentioned:

1.  Effective use of built-in R functions
2.  Code readability
3.  Dataset creation
4.  Vector operations
5.  Filtering

Let's start by reading the `readme.md` file.



[1 tool called]

The `readme.md` file provides a good overview of basic R syntax, including variables, vectors, lists, functions, conditional statements, loops, comments, data frames, and pipes. It uses examples directly from `lab3.R`, `lab4.R`, and `lab11.R` for clarification.

Now, let's dive into the first five topics you requested, providing demo snippets for better clarification.

---

### 1. Effective use of built-in R functions

R has a rich set of built-in functions for various tasks. Effective use of these functions can lead to concise, efficient, and readable code.

**Explanation:**
Instead of writing custom logic for common operations, R's built-in functions often provide optimized and robust solutions.

**Demo Snippets:**

**Example 1: Generating random numbers and sequences**

*   `sample()`: Generates random samples.
*   `rep()`: Replicates elements of vectors.
*   `seq.Date()`: Generates sequences of dates.

```r
# From lab3.R
# Generate a random number for num_bikes
num_bikes <- sample(800:2000, 1)
print(paste("Number of bikes:", num_bikes))

# From lab3.R
# Create a vector of 5 zeros
bike_used <- rep(0, 5)
print(paste("Initial bike_used vector:", paste(bike_used, collapse = ", ")))

# From lab6.R
# Generate a sequence of dates
start_date <- as.Date("2023-09-04")
end_date <- as.Date("2025-09-04")
all_dates <- seq.Date(start_date, end_date, by = "day")
print(paste("First 5 dates in sequence:", paste(head(all_dates, 5), collapse = ", ")))
```

**Example 2: Mathematical operations and aggregation**

*   `sum()`: Calculates the sum of all values in a vector.
*   `mean()`: Calculates the arithmetic mean.
*   `median()`: Calculates the median.
*   `max()`, `min()`: Finds the maximum and minimum values.
*   `round()`: Rounds numbers.

```r
# From lab3.R
bike_capacity <- sample(150:500, 5)
car_capacity <- sample(150:500, 4)
vip_capacity <- 10
vip_used <- sample(0:10, 1)

# Sum of capacities
total_capacity <- sum(bike_capacity) + sum(car_capacity) + vip_capacity
print(paste("Total Capacity:", total_capacity))

# From lab4.R
rainfall_mm_1005 = sample(50:500, 20, replace = TRUE)
avg_rainfall <- mean(rainfall_mm_1005)
print(paste("Average Rainfall:", round(avg_rainfall, 2)))

# From lab8.R (custom skewness function using built-in sd, mean, length)
sk <- function(x) {
  x <- x[!is.na(x)]
  s <- sd(x)
  n <- length(x)
  if(s == 0 | n < 3) NA else sum((x - mean(x))^3) / ((n - 1) * s^3)
}
vec_for_skewness <- rnorm(100, 0, 1)
print(paste("Skewness of a normal distribution sample:", round(sk(vec_for_skewness), 2)))
```

---

### 2. Code readability

Code readability is crucial for collaboration and maintainability. R's syntax allows for clear and expressive code.

**Explanation:**
Good practices like meaningful variable names, clear function definitions, comments, and consistent formatting enhance readability. The pipe operator (`%>%`) from `magrittr`/`dplyr` significantly improves readability for sequential data manipulation tasks.

**Demo Snippets:**

**Example 1: Meaningful variable and function names**

*   Instead of `x`, `y`, `f1`, use descriptive names like `bike_capacity`, `allocate_parking`.

```r
# From lab3.R
# Clearly describes its purpose
allocate_parking <- function(arrivals, capacity_vec, used_vec) {
  # ... function logic ...
  return(used_vec)
}

# Variable names are self-explanatory
bike_capacity <- sample(150:500, 5)
car_used <- rep(0, 4)
```

**Example 2: Comments for clarification**

*   Use `#` for single-line comments.
*   Provide function documentation (as seen in `lab3.R` and `lab4.R`).

```r
# From lab3.R
# Initialize parking capacities
bike_capacity <- sample(150:500, 5)

#' Allocate parking to vehicles based on capacity and usage
#'
#' @param arrivals Integer. Number of arriving vehicles.
#' @param capacity_vec Integer vector. Maximum capacity of each parking slot.
#' @param used_vec Integer vector. Current used count in each slot.
#'
#' @return Integer vector. Updated used_vec after allocation.
allocate_parking <- function(arrivals, capacity_vec, used_vec) {
  # ... function logic ...
}
```

**Example 3: Using the pipe operator (`%>%`) for chained operations (from `lab11.R`)**

*   This makes the sequence of operations clear, reading from left to right.

```r
# From lab11.R (simplified)
library(dplyr) # Assume dplyr is loaded for %>% and mutate

data_example <- data.frame(
  DateTime = as.POSIXct(c("2025-10-01 08:00:00", "2025-10-01 09:00:00")),
  Value = c(10, 20)
)

data_processed <- data_example %>%
  mutate(Date = as.Date(DateTime)) %>%
  mutate(Hour = lubridate::hour(DateTime)) # Assuming lubridate::hour is available
print(data_processed)
```

---

### 3. Dataset creation

Creating datasets, whether synthetic or from external sources, is a fundamental step. The repository demonstrates various methods.

**Explanation:**
Datasets can be created as vectors, lists, matrices, or data frames depending on the structure and types of data. Synthetic data generation is useful for testing code and demonstrating concepts.

**Demo Snippets:**

**Example 1: Creating vectors and lists (from `lab4.R`)**

```r
# Create vectors
zone_name_1005 = paste("Zone", 1:20)
rainfall_mm_1005 = sample(50:500, 20, replace = TRUE)
drainage_capacity_1005 = sample(30:500, 20, replace = TRUE)

# Combine vectors into a list
city_flood_data_1005 = list(
  zone_name = zone_name_1005,
  rainfall_mm = rainfall_mm_1005,
  drainage_capacity = drainage_capacity_1005
)
print("City Flood Data List Structure:")
str(city_flood_data_1005)
```

**Example 2: Creating a matrix (from `lab5.R`)**

```r
planets_1005 <- c("Mercury", "Venus", "Earth", "Mars", "Jupiter", "Saturn", "Uranus", "Neptune")
diameters_km <- c(4879, 12104, 12742, 6779, 139820, 116460, 50724, 49244)
distances_million_km <- c(57.9, 108.2, 149.6, 227.9, 778.5, 1432, 2867, 4515)

solar_matrix <- matrix(c(diameters_km, distances_million_km), nrow = 8, ncol = 2)
colnames(solar_matrix) <- c("Diameter_km", "Distance_MillionKm")
rownames(solar_matrix) <- planets_1005
print("Solar System Matrix:")
print(head(solar_matrix))
```

**Example 3: Creating a data frame (from `lab6.R`)**

```r
set.seed(1005)
n_records <- 100
uid <- 1:n_records
age <- sample(18:65, n_records, TRUE)
gender <- sample(c("Male", "Female", "Other"), n_records, TRUE)

data_df <- data.frame(
  UID = uid,
  Age = age,
  Gender = gender
)
print("Sample Data Frame Head:")
print(head(data_df))
```

---

### 4. Vector operations

Vectors are the most basic data structure in R, and many operations are vectorized, meaning they can be applied to entire vectors without explicit loops.

**Explanation:**
Vectorized operations are typically much faster and more concise than using loops in R. This includes arithmetic operations, logical operations, and applying functions to each element.

**Demo Snippets:**

**Example 1: Arithmetic operations on vectors**

```r
# From lab4.R
rainfall_mm = c(100, 250, 80, 300)
drainage_capacity = c(70, 150, 90, 120)

# Vectorized subtraction
diff_rainfall_drainage <- rainfall_mm - drainage_capacity
print(paste("Difference (rainfall - drainage):", paste(diff_rainfall_drainage, collapse = ", ")))

# From lab5.R
orbital_periods_days <- c(88, 225, 365)
# Vectorized division
orbital_periods_years <- orbital_periods_days / 365
print(paste("Orbital periods in years:", paste(round(orbital_periods_years, 2), collapse = ", ")))
```

**Example 2: Logical operations and indexing**

```r
# From lab4.R
green_cover_percent = c(15, 35, 25, 40, 10)
avg_green_cover = mean(green_cover_percent)
print(paste("Average Green Cover:", avg_green_cover))

# Filter elements based on a condition
below_avg_green_cover_zones <- green_cover_percent < avg_green_cover
print(paste("Zones with below-average green cover (logical):", paste(below_avg_green_cover_zones, collapse = ", ")))

zone_names <- c("A", "B", "C", "D", "E")
# Use logical vector for indexing
print(paste("Zone names with below-average green cover:", paste(zone_names[below_avg_green_cover_zones], collapse = ", ")))
```

**Example 3: Applying functions to vectors (`sapply`, `lapply`)**

```r
# From lab5.R
convert_to_years <- function(days) {
  return(days / 365)
}

orbital_periods_days <- c(88, 225, 365, 687)
# Apply function to each element of the vector
orbital_periods_years <- sapply(orbital_periods_days, convert_to_years)
print(paste("Orbital Periods in Earth Years:", paste(round(orbital_periods_years, 2), collapse = ", ")))

# From lab6.R (custom price function applied using lapply and unlist)
putPrice <- function(catg){
  if(catg == "Electronics") return(sample(1:200,1))
  if(catg == "Clothing") return(sample(200:400,1 ))
  if(catg == "Grocery") return(sample(400:600,1 ))
  return(sample(600:800,1 ))
}
productCat_sample = c("Electronics", "Clothing", "Furniture", "Grocery")
price_sample = unlist(lapply(as.list(productCat_sample), putPrice))
print(paste("Sample prices for categories:", paste(price_sample, collapse = ", ")))
```

---

### 5. Filtering

Filtering (or subsetting) data based on conditions is a common operation. This can be done on vectors, matrices, lists, and data frames.

**Explanation:**
R provides powerful indexing capabilities to select specific elements or rows/columns that meet certain criteria.

**Demo Snippets:**

**Example 1: Filtering vectors (as shown in section 4, Example 2)**

```r
green_cover_percent = c(15, 35, 25, 40, 10)
zone_names <- c("A", "B", "C", "D", "E")
avg_green_cover = mean(green_cover_percent)

# Filter by direct logical comparison
zones_low_green <- zone_names[green_cover_percent < avg_green_cover]
print(paste("Zones with low green cover:", paste(zones_low_green, collapse = ", ")))
```

**Example 2: Filtering rows in a data frame based on a condition**

```r
# From lab5.R
solar_df <- data.frame(
  Planet = c("Mercury", "Venus", "Earth", "Mars", "Jupiter", "Saturn"),
  Diameter_km = c(4879, 12104, 12742, 6779, 139820, 116460),
  Distance_MillionKm = c(57.9, 108.2, 149.6, 227.9, 778.5, 1432),
  No_of_Moons = c(0, 0, 1, 2, 95, 146)
)

# Filter for terrestrial planets
terrestrial_planets <- solar_df[solar_df$Planet %in% c("Mercury", "Venus", "Earth", "Mars"), ]
print("Terrestrial Planets (filtered by name):")
print(terrestrial_planets)

# Filter for planets with more than 100 moons
gas_giants_many_moons <- solar_df[solar_df$No_of_Moons > 100, ]
print("Gas Giants with Many Moons (filtered by condition):")
print(gas_giants_many_moons)
```

**Example 3: Filtering with multiple conditions**

```r
# From lab8.R (conceptual, using data frame 'data')
# Assuming 'data' dataframe exists from lab8.R
data_subset <- data.frame(
  customer_age = c(25, 30, 45, 28, 50),
  customer_income = c(50000, 75000, 120000, 60000, 150000),
  region = c("North", "South", "North", "East", "West")
)

# Filter for customers in "North" region AND age > 40
filtered_customers <- data_subset[data_subset$region == "North" & data_subset$customer_age > 40, ]
print("Filtered Customers (North region and age > 40):")
print(filtered_customers)
```


Great! Let's continue with the next three topics:

6.  Proper matrix construction and subsetting
7.  Array operations
8.  List operations

---

### 6. Proper matrix construction and subsetting

Matrices in R are 2-dimensional homogeneous data structures. They are fundamental for numerical computing, especially in linear algebra and statistical modeling.

**Explanation:**
Matrices are created using the `matrix()` function, specifying the data, number of rows, and number of columns. Elements can be accessed using `[row, column]` indexing. `colnames()` and `rownames()` can be used to label the dimensions, improving readability.

**Demo Snippets:**

**Example 1: Creating a matrix (from `lab5.R`)**

```r
# Data for planets: Diameter (km) and Distance from Sun (million km)
diameters_km <- c(4879, 12104, 12742, 6779, 139820, 116460, 50724, 49244)
distances_million_km <- c(57.9, 108.2, 149.6, 227.9, 778.5, 1432, 2867, 4515)
planets <- c("Mercury", "Venus", "Earth", "Mars", "Jupiter", "Saturn", "Uranus", "Neptune")

# Create a matrix with 8 rows (for planets) and 2 columns (for properties)
# By default, matrix fills by column
solar_matrix <- matrix(c(diameters_km, distances_million_km), nrow = 8, ncol = 2)

# Assign meaningful column and row names
colnames(solar_matrix) <- c("Diameter_km", "Distance_MillionKm")
rownames(solar_matrix) <- planets

print("Solar System Matrix:")
print(solar_matrix)
```

**Example 2: Subsetting a matrix (from `lab5.R`)**

*   Subsetting allows you to select specific rows, columns, or individual elements.
*   Leaving a dimension blank selects all elements along that dimension.

```r
# Using the solar_matrix created above

# Extract and display the values for the outer planets (Jupiter to Neptune)
# Jupiter is the 5th row, Neptune is the 8th row
outer_planets_matrix <- solar_matrix[5:8, ]
print("\nOuter Planets Matrix (rows 5 to 8, all columns):")
print(outer_planets_matrix)

# Get the diameter of Earth
earth_diameter <- solar_matrix["Earth", "Diameter_km"]
print(paste("\nEarth's Diameter (km):", earth_diameter))

# Get all distances from the Sun
all_distances <- solar_matrix[, "Distance_MillionKm"]
print(paste("\nDistances from Sun (million km):", paste(all_distances, collapse = ", ")))
```

---

### 7. Array operations

Arrays in R are N-dimensional homogeneous data structures. They are generalizations of matrices (which are 2-dimensional arrays).

**Explanation:**
Arrays are created using the `array()` function, specifying the data and the `dim` argument for dimensions. Similar to matrices, elements are accessed using `[...]` indexing, where each dimension has its own index.

**Demo Snippets:**

**Example 1: Creating a 2D array (similar to a matrix) (from `lab5.R`)**

```r
# Data for planets and their orbital periods in days
planets_1005 <- c("Mercury", "Venus", "Earth", "Mars", "Jupiter", "Saturn", "Uranus", "Neptune")
orbital_periods_days_1005 <- c(88, 225, 365, 687, 4333, 10759, 30687, 60190)

# Combine into a 2D array
# The data is given first, then dimensions (8 rows, 2 columns)
solar_array <- array(c(planets_1005, orbital_periods_days_1005), dim = c(8, 2))

# Assign dimnames for clarity (list of row names, list of column names)
dimnames(solar_array) <- list(NULL, c("Planet", "Orbital_Period_Days"))

print("Solar System Array (2D):")
print(solar_array)
```

**Example 2: Subsetting an array (from `lab5.R`)**

```r
# Using the solar_array created above

# Display the orbital period of Earth using array indexing
# Find the row index for "Earth"
earth_index <- which(solar_array[, "Planet"] == "Earth")
earth_orbital_period <- solar_array[earth_index, "Orbital_Period_Days"]
print(paste("\nOrbital period of Earth:", earth_orbital_period, "days"))

# Get all orbital periods
all_orbital_periods <- solar_array[, "Orbital_Period_Days"]
print(paste("\nAll Orbital Periods (days):", paste(all_orbital_periods, collapse = ", ")))

# Create a 3D array example (e.g., Temperature readings for cities over months for different years)
temp_data <- c(runif(3*4*2, 10, 30)) # 3 cities, 4 months, 2 years
temp_array <- array(temp_data, dim = c(3, 4, 2),
                    dimnames = list(
                      c("NY", "LA", "CHI"),
                      c("Jan", "Feb", "Mar", "Apr"),
                      c("2023", "2024")
                    ))
print("\nExample 3D Array:")
print(temp_array)

# Access February temperatures for all cities in 2024
feb_2024_temps <- temp_array[, "Feb", "2024"]
print(paste("\nFebruary Temperatures in 2024 (NY, LA, CHI):", paste(round(feb_2024_temps, 2), collapse = ", ")))
```

---

### 8. List operations

Lists in R are highly flexible data structures that can hold elements of different types, including other lists, vectors, matrices, and data frames.

**Explanation:**
Lists are created using the `list()` function. Elements can be named, which allows for intuitive access using `$` or `[[name]]`. Unnamed elements can be accessed by their numerical position using `[[position]]`.

**Demo Snippets:**

**Example 1: Creating a list with mixed data types (from `lab4.R` and `lab5.R`)**

```r
# From lab4.R (similar structure)
zone_name <- paste("Zone", 1:3)
rainfall <- sample(100:300, 3)
population <- sample(5000:15000, 3)

city_data_list <- list(
  zones = zone_name,
  rainfall = rainfall,
  population = population,
  date_recorded = as.Date("2025-10-26")
)

print("City Data List:")
print(city_data_list)

# From lab5.R
earth_list_1005 <- list(
  Name = "Earth",
  Diameter_km = 12742,
  Distance_MillionKm = 149.6,
  Number_of_Moons = 1
)

print("\nEarth Properties List:")
print(earth_list_1005)
```

**Example 2: Accessing and modifying list elements (from `lab4.R` and `lab5.R`)**

```r
# Using earth_list_1005 from above

# Access elements using $ for named elements
print(paste("\nEarth's Name:", earth_list_1005$Name))
print(paste("Earth's Diameter (km):", earth_list_1005$Diameter_km))

# Access elements using [[ ]] for named or indexed elements
print(paste("Earth's Distance (million km):", earth_list_1005[["Distance_MillionKm"]]))
print(paste("Earth's Number of Moons (by index):", earth_list_1005[[4]]))

# Modify an element
earth_list_1005$Number_of_Moons <- 2 # Let's imagine a new moon is discovered!
print(paste("Updated Number of Moons:", earth_list_1005$Number_of_Moons))

# Add a new element to the list
earth_list_1005$Atmosphere_Composition <- c("Nitrogen", "Oxygen", "Argon")
print("\nEarth List after adding Atmosphere_Composition:")
print(earth_list_1005)
```

**Example 3: Applying functions to list elements (`lapply`, `sapply`)**

```r
list_of_numbers <- list(vec1 = c(1, 2, 3), vec2 = c(4, 5), vec3 = c(6, 7, 8, 9))

# Calculate the sum of each vector in the list using lapply
sums_lapply <- lapply(list_of_numbers, sum)
print("\nSums of vectors in list (lapply - returns a list):")
print(sums_lapply)

# Calculate the sum of each vector in the list using sapply (simplifies to a vector if possible)
sums_sapply <- sapply(list_of_numbers, sum)
print("\nSums of vectors in list (sapply - returns a vector):")
print(sums_sapply)
```

Okay, let's move on to the next three topics:

9.  Data frame operations
10. Data wrangling
11. Plot creation

---

### 9. Data frame operations

Data frames are the most commonly used data structure in R for storing tabular data. They are essentially lists of vectors of equal length, where each vector represents a column.

**Explanation:**
Data frames are ideal for representing datasets where each row is an observation and each column is a variable, potentially of different data types. R provides extensive capabilities for creating, accessing, subsetting, and modifying data frames.

**Demo Snippets:**

**Example 1: Creating a data frame (from `lab5.R`)**

```r
planets <- c("Mercury", "Venus", "Earth", "Mars", "Jupiter", "Saturn", "Uranus", "Neptune")
diameters_km <- c(4879, 12104, 12742, 6779, 139820, 116460, 50724, 49244)
distances_million_km <- c(57.9, 108.2, 149.6, 227.9, 778.5, 1432, 2867, 4515)
orbital_periods_days <- c(88, 225, 365, 687, 4333, 10759, 30687, 60190)
no_of_moons <- c(0, 0, 1, 2, 95, 146, 28, 16)

solar_df <- data.frame(
  Planet = planets,
  Diameter_km = diameters_km,
  Distance_MillionKm = distances_million_km,
  Orbital_Period_days = orbital_periods_days,
  No_of_Moons = no_of_moons
)
print("Solar System Data Frame:")
print(solar_df)
```

**Example 2: Accessing and subsetting data frame elements (from `lab5.R`)**

*   Accessing columns using `$` or `[[ ]]`.
*   Subsetting rows and columns using `[row_indices, column_indices]`.

```r
# Using solar_df from above

# Access the 'Planet' column
print("\nPlanet names (using $):")
print(solar_df$Planet)

# Access 'Diameter_km' and 'Distance_MillionKm' columns
print("\nDiameter and Distance (using [[ ]]):")
print(solar_df[, c("Diameter_km", "Distance_MillionKm")])

# Display all terrestrial planets (Mercury, Venus, Earth, Mars)
terrestrial_planets <- solar_df[solar_df$Planet %in% c("Mercury", "Venus", "Earth", "Mars"), ]
print("\nTerrestrial Planets (filtered by name):")
print(terrestrial_planets)

# Find and display the planet with the maximum number of moons
max_moons_planet <- solar_df[which.max(solar_df$No_of_Moons), ]
print("\nPlanet with maximum number of moons:")
print(max_moons_planet)
```

**Example 3: Modifying and adding columns (from `lab5.R`)**

```r
# Using solar_df from above

# Add a new column: Orbital Period in Earth years (365 days = 1 year)
solar_df$Orbital_Period_years <- solar_df$Orbital_Period_days / 365
print("\nData Frame with Orbital Period in Years:")
print(solar_df)

# Modify an existing column (e.g., convert Diameter to meters)
solar_df$Diameter_m <- solar_df$Diameter_km * 1000
print("\nData Frame with Diameter in meters:")
print(solar_df[, c("Planet", "Diameter_km", "Diameter_m")])
```

**Example 4: Sorting a data frame (from `lab5.R`)**

```r
# Using solar_df from above

# Sort planets in ascending order of their distance from the Sun
sorted_by_distance <- solar_df[order(solar_df$Distance_MillionKm), ]
print("\nPlanets sorted by distance from Sun:")
print(sorted_by_distance)

# Sort by number of moons in descending order, then by diameter in ascending
sorted_complex <- solar_df[order(-solar_df$No_of_Moons, solar_df$Diameter_km), ]
print("\nPlanets sorted by moons (desc) then diameter (asc):")
print(sorted_complex)
```

---

### 10. Data wrangling

Data wrangling involves cleaning, transforming, and organizing raw data into a usable format for analysis. This includes tasks like feature engineering, aggregation, and handling missing values.

**Explanation:**
R's base functions provide powerful tools for data wrangling. When dealing with more complex tasks, packages like `dplyr` and `tidyr` offer a more intuitive and efficient "grammar of data manipulation."

**Demo Snippets (Base R examples for now, `dplyr` and `tidyr` will be covered later):**

**Example 1: Feature Engineering (creating new variables) (from `lab7.R`)**

```r
# Sample data
city_data_sample <- data.frame(
  city = c("New York", "London", "Tokyo", "Cairo", "Sydney"),
  population_millions = c(18.8, 9.6, 37.4, 21.3, 5.4)
)

# Create a new categorical variable 'size_category' based on population
city_data_sample$size_category <- factor(
  ifelse(city_data_sample$population_millions < 10, "Small_Medium", "Large"),
  levels = c("Small_Medium", "Large")
)
print("City Data with Size Category:")
print(city_data_sample)
```

**Example 2: Aggregation (summarizing data) (from `lab6.R`)**

*   `tapply()` is a powerful base R function for applying a function to subsets of a vector, defined by a factor or list of factors.
*   `table()` for frequency counts.

```r
# Sample data
df_transactions <- data.frame(
  Category = c("Electronics", "Clothing", "Electronics", "Grocery", "Clothing", "Electronics"),
  Price = c(150, 250, 200, 500, 300, 180),
  Quantity = c(1, 2, 1, 1, 1, 2),
  PaymentMethod = c("Card", "Cash", "Card", "UPI", "Cash", "Card")
)

# Total sales per product category
sales_category <- tapply(df_transactions$Price * df_transactions$Quantity,
                         df_transactions$Category, sum, na.rm=TRUE)
print("\nTotal Sales by Category:")
print(sales_category)

# Payment mode preference
payment_pref <- table(df_transactions$PaymentMethod)
print("\nPayment Mode Preference:")
print(payment_pref)
```

**Example 3: Handling Missing Values (Creation and Imputation) (from `lab8.R` and `lab6.R`)**

*   **Creation:** Intentionally introduce `NA`s.
*   **Imputation (Median for numeric):** Replace `NA`s with the median.

```r
set.seed(123)
data_with_na <- data.frame(
  ID = 1:10,
  Value1 = rnorm(10, 50, 10),
  Value2 = c(10, 12, NA, 15, 18, NA, 20, 22, 25, 28)
)
data_with_na$Value1[sample(1:10, 2)] <- NA # Introduce more NAs in Value1

print("Data before imputation:")
print(data_with_na)
print("Missing values count:")
print(colSums(is.na(data_with_na)))

# Impute missing 'Value1' with its median
median_value1 <- median(data_with_na$Value1, na.rm = TRUE)
data_with_na$Value1[is.na(data_with_na$Value1)] <- median_value1

# Impute missing 'Value2' with its median
median_value2 <- median(data_with_na$Value2, na.rm = TRUE)
data_with_na$Value2[is.na(data_with_na$Value2)] <- median_value2

print("\nData after median imputation:")
print(data_with_na)
print("Missing values count after imputation:")
print(colSums(is.na(data_with_na)))
```

---

### 11. Plot creation

Visualization is key to understanding data. R's base `graphics` package offers a wide range of plot types for exploratory data analysis.

**Explanation:**
Base R plotting functions (`plot()`, `hist()`, `boxplot()`, `barplot()`, `pie()`, `pairs()`) allow for quick and effective creation of static plots. Parameters like `main`, `xlab`, `ylab`, `col`, `pch`, `type`, `lwd`, `lty` are used to customize the appearance. `par(mfrow=...)` is used to arrange multiple plots.

**Demo Snippets:**

**Example 1: Histogram (Distribution of a single numeric variable) (from `lab10.R`)**

```r
# Using mtcars dataset
data(mtcars)

hist(mtcars$mpg, main="MPG Distribution", xlab="Miles Per Gallon",
     col="lightblue", breaks=10, freq = FALSE)
# Add a vertical line for the mean
abline(v=mean(mtcars$mpg), col="red", lwd=2, lty=2)
# Add density line
lines(density(mtcars$mpg), col="blue", lwd=2)
```

**Example 2: Boxplot (Distribution and comparison across categories) (from `lab10.R`)**

```r
# Using iris dataset
data(iris)

boxplot(Sepal.Width ~ Species, data=iris, main="Sepal Width by Species",
        xlab="Species", ylab="Sepal Width (cm)",
        col=c("red", "green", "blue"))
```

**Example 3: Scatter Plot (Relationship between two numeric variables) (from `lab10.R`)**

```r
# Using mtcars dataset

plot(mtcars$wt, mtcars$mpg, main="MPG vs Weight",
     xlab="Weight (1000 lbs)", ylab="MPG", pch=19, col="darkblue")
# Add a linear regression line
abline(lm(mpg ~ wt, data=mtcars), col="red", lwd=2)
# Add correlation coefficient as text
text(4, 30, paste("r =", round(cor(mtcars$wt, mtcars$mpg), 3)), col="red")
```

**Example 4: Bar Plot (Categorical frequencies or aggregated values) (from `lab6.R`)**

```r
# Sample data for categories and sales
sales_category <- c(Electronics = 12000, Clothing = 8500, Grocery = 15000, Furniture = 6000)

barplot(sales_category, main="Total Sales by Category", ylab="Sales Amount", col="skyblue")
```

**Example 5: Arranging Multiple Plots (`par(mfrow)`) (from `lab10.R`)**

```r
# Arrange plots in a 2x2 grid
oldpar <- par(mfrow = c(2, 2))

# Plot 1: Histogram of hp
hist(mtcars$hp, main="Horsepower Distribution", xlab="HP", col="lightgreen")

# Plot 2: Boxplot of qsec
boxplot(mtcars$qsec, main="1/4 Mile Time Boxplot", ylab="Qsec", col="lightcoral")

# Plot 3: Scatter plot disp vs drat
plot(mtcars$disp, mtcars$drat, main="Displacement vs Rear Axle Ratio",
     xlab="Displacement", ylab="Drat", pch=16, col="purple")

# Plot 4: Bar plot of cylinder counts
cyl_counts <- table(mtcars$cyl)
barplot(cyl_counts, main="Cylinder Counts", xlab="Number of Cylinders", ylab="Frequency", col="orange")

# Reset plotting layout to default after plotting
par(oldpar)
```

Alright, let's continue with the next three topics:

12. creation(secondary) & handling of missing values (primary) \[note: na values also we have to create before anything]
13. train test split resample.
14. linear regression (base or multivariate) prediction, measure skewness and skewness transformation. RMSE, MAE, R-squared

---

### 12. Creation & Handling of Missing Values

Missing values (NA - Not Available) are a common occurrence in real-world datasets. It's important to understand how to create them (for simulation) and, more importantly, how to handle them effectively.

**Explanation:**
Missing values can be introduced intentionally for testing imputation methods or can arise naturally in data collection. Handling strategies include removal, imputation (replacing NAs with estimated values), or using models that can inherently deal with NAs. The choice of method depends on the nature of the missingness and the specific analysis.

**Demo Snippets:**

**Example 1: Creation of Missing Values (from `lab8.R`, `lab9.R`, `lab11.R`, `lab6.R`)**

*   Missing values are often introduced by randomly assigning `NA` to selected positions in a vector or data frame.

```r
set.seed(1005)
n_records <- 100
sample_data <- data.frame(
  ID = 1:n_records,
  Value1 = rnorm(n_records, 100, 10),
  Category = sample(c("A", "B", "C"), n_records, replace = TRUE)
)

# Introduce 5% missing values in 'Value1'
num_missing_value1 <- round(0.05 * n_records)
missing_indices_value1 <- sample(1:n_records, num_missing_value1)
sample_data$Value1[missing_indices_value1] <- NA

# Introduce 3% missing values in 'Category'
num_missing_category <- round(0.03 * n_records)
missing_indices_category <- sample(1:n_records, num_missing_category)
sample_data$Category[missing_indices_category] <- NA

print("Data with Introduced Missing Values:")
print(head(sample_data))
print("\nMissing values count per variable:")
print(colSums(is.na(sample_data)))
```

**Example 2: Handling Missing Values - Removal (`na.omit()`) (from `lab6.R`)**

*   `na.omit()` removes any row that contains at least one `NA` value. This can lead to significant data loss if missingness is widespread.

```r
# Using sample_data with NAs from Example 1

df_complete_cases <- na.omit(sample_data)
print("\nData after removing rows with any NA (`na.omit`):")
print(head(df_complete_cases))
print("Original rows:", nrow(sample_data), " | Remaining rows:", nrow(df_complete_cases))
```

**Example 3: Handling Missing Values - Median Imputation (for numeric) (from `lab7.R`, `lab8.R`, `lab9.R`, `lab11.R`, `lab6.R`)**

*   Replacing `NA`s in a numeric column with the column's median. This preserves the central tendency.

```r
# Using sample_data with NAs from Example 1

# Impute 'Value1' with its median
median_value1 <- median(sample_data$Value1, na.rm = TRUE)
sample_data$Value1[is.na(sample_data$Value1)] <- median_value1

print("\nData after median imputation for 'Value1':")
print(head(sample_data))
print("Missing values count after median imputation:")
print(colSums(is.na(sample_data)))
```

**Example 4: Handling Missing Values - Mode Imputation (for categorical) (from `lab8.R`, `lab11.R`)**

*   Replacing `NA`s in a categorical column with the most frequent category (mode).

```r
# Using sample_data with NAs from Example 1

# Impute 'Category' with its mode
mode_category <- names(which.max(table(sample_data$Category)))
sample_data$Category[is.na(sample_data$Category)] <- mode_category

print("\nData after mode imputation for 'Category':")
print(head(sample_data))
print("Missing values count after mode imputation:")
print(colSums(is.na(sample_data)))
```

**Example 5: Handling Missing Values - Predictive Imputation (Linear Regression) (from `lab6.R`)**

*   Predicting missing values using a regression model trained on available data.

```r
set.seed(123)
df_reg_imp <- data.frame(
  Feature1 = rnorm(20, 50, 5),
  Feature2 = rnorm(20, 10, 2),
  Target = rnorm(20, 150, 20)
)
# Introduce NAs in Target
df_reg_imp$Target[sample(1:20, 5)] <- NA

print("\nData for predictive imputation:")
print(head(df_reg_imp))
print("Missing values in Target before imputation:", sum(is.na(df_reg_imp$Target)))

# Fit a linear model to predict 'Target' based on 'Feature1' and 'Feature2'
# Use na.action=na.exclude to handle NAs during model fitting
fit_model <- lm(Target ~ Feature1 + Feature2, data = df_reg_imp, na.action = na.exclude)

# Predict missing 'Target' values
predicted_target_values <- predict(fit_model, newdata = df_reg_imp)

# Impute NAs in 'Target' with the predicted values
df_reg_imp$Target[is.na(df_reg_imp$Target)] <- predicted_target_values[is.na(df_reg_imp$Target)]

print("\nData after predictive imputation for 'Target':")
print(head(df_reg_imp))
print("Missing values in Target after imputation:", sum(is.na(df_reg_imp$Target)))
```

---

### 13. Train Test Split Resample

Splitting a dataset into training and testing sets is a crucial step in machine learning to evaluate model performance on unseen data and prevent overfitting. Resampling techniques (like cross-validation, though not explicitly shown in simple scripts) generalize this concept.

**Explanation:**
The training set is used to build the model, and the test set is used to evaluate how well the model generalizes to new, unseen data. A common split is 70-80% for training and the remainder for testing. Random sampling ensures that both sets are representative of the original data.

**Demo Snippets:**

**Example 1: Basic Train-Test Split by Random Sampling (from `lab8.R`)**

```r
set.seed(42) # For reproducibility

# Create a sample data frame
data_for_split <- data.frame(
  Feature1 = rnorm(100, 10, 2),
  Feature2 = runif(100, 0, 1),
  Target = 5 + 2 * rnorm(100) + 3 * runif(100)
)

# Determine the size of the training set (e.g., 80%)
train_size <- floor(0.8 * nrow(data_for_split))

# Randomly select row indices for the training set
train_indices <- sample(seq_len(nrow(data_for_split)), size = train_size)

# Create the training and testing data frames
train_data <- data_for_split[train_indices, ]
test_data <- data_for_split[-train_indices, ]

print("Dimensions of original data:", dim(data_for_split))
print("Dimensions of training data:", dim(train_data))
print("Dimensions of testing data:", dim(test_data))

print("\nHead of Training Data:")
print(head(train_data))
print("\nHead of Testing Data:")
print(head(test_data))
```

**Example 2: Train-Test Split based on a time variable (from `lab9.R`)**

*   For time- series data, it's common to split based on time, using earlier data for training and later data for testing.

```r
# Sample time-series data
df_time_series <- data.frame(
  Year = 1990:2020,
  Value = 100 + (1990:2020 - 1990) * 2 + rnorm(length(1990:2020), 0, 5)
)

# Define the split point (e.g., up to year 2010 for training)
split_year <- 2010

# Create training and future (test) sets
train_ts <- df_time_series[df_time_series$Year <= split_year, ]
future_ts <- df_time_series[df_time_series$Year > split_year, ]

print("Years in Training Data:", range(train_ts$Year))
print("Years in Future Data:", range(future_ts$Year))

print("\nHead of Training Time Series Data:")
print(head(train_ts))
print("\nHead of Future Time Series Data:")
print(head(future_ts))
```

---

### 14. Linear regression (base or multivariate) prediction, measure skewness and skewness transformation. RMSE, MAE, R-squared

This topic covers a core set of statistical modeling and data preprocessing techniques used in many analytical tasks.

**Explanation:**
Linear regression models the linear relationship between a dependent variable and one or more independent variables. Skewness describes the asymmetry of a distribution, and transformations can be applied to make distributions more symmetric, which often improves the performance of linear models. RMSE, MAE, and R-squared are common metrics to evaluate the accuracy and fit of regression models.

**Demo Snippets:**

**Example 1: Multivariate Linear Regression and Prediction (from `lab8.R`, `lab9.R`, `lab6.R`)**

```r
set.seed(123)
# Create a sample data frame
df_model <- data.frame(
  X1 = rnorm(100, 50, 10),
  X2 = runif(100, 10, 20),
  Category = sample(c("A", "B"), 100, replace = TRUE),
  Y = 5 + 0.5 * rnorm(100) + 2 * runif(100) + 10 * (sample(0:1, 100, replace = TRUE)) + rnorm(100, 0, 5)
)

# One-hot encode the categorical variable for regression
df_model$CategoryB <- ifelse(df_model$Category == "B", 1, 0)
df_model$Category <- NULL # Remove original categorical column

# Split into train and test sets
train_indices <- sample(1:nrow(df_model), 0.8 * nrow(df_model))
train_set <- df_model[train_indices, ]
test_set <- df_model[-train_indices, ]

# Build a multivariate linear regression model
# Y ~ . means 'Y' explained by all other variables in the data frame
model <- lm(Y ~ ., data = train_set)
print("Linear Regression Model Summary:")
print(summary(model))

# Make predictions on the test set
predictions <- predict(model, newdata = test_set)
print("\nFirst 5 Actual vs Predicted values on test set:")
print(data.frame(Actual = head(test_set$Y, 5), Predicted = head(predictions, 5)))
```

**Example 2: Measure Skewness and Skewness Transformation (from `lab8.R`)**

*   A custom function to calculate skewness.
*   Applying a log transformation to reduce right-skewness.

```r
# Custom skewness function (from lab8.R)
sk <- function(x) {
  x <- x[!is.na(x)]
  s <- sd(x)
  n <- length(x)
  if(s == 0 | n < 3) NA else sum((x - mean(x))^3) / ((n - 1) * s^3)
}

# Create a right-skewed variable
right_skewed_data <- rexp(100, rate = 0.5) # Exponential distribution is right-skewed
print(paste("Skewness of original right-skewed data:", round(sk(right_skewed_data), 3)))

# Visualize original data
hist(right_skewed_data, main="Original Right-Skewed Data", col="salmon")

# Apply log transformation (log1p is log(1+x), safer for values near 0)
transformed_data <- log1p(right_skewed_data)
print(paste("Skewness after log transformation:", round(sk(transformed_data), 3)))

# Visualize transformed data
hist(transformed_data, main="Log-Transformed Data", col="lightgreen")
```

**Example 3: RMSE, MAE, R-squared (Model Evaluation) (from `lab8.R`, `lab9.R`)**

*   Custom functions to calculate these common regression metrics.

```r
# Assuming 'test_set$Y' and 'predictions' are available from Example 1

# Custom evaluation functions
rmse <- function(actual, pred) {
  sqrt(mean((actual - pred)^2))
}
mae <- function(actual, pred) {
  mean(abs(actual - pred))
}
rsq <- function(actual, pred) {
  1 - sum((actual - pred)^2) / sum((actual - mean(actual))^2)
}

actual_values <- test_set$Y
predicted_values <- predictions

rmse_val <- rmse(actual_values, predicted_values)
mae_val <- mae(actual_values, predicted_values)
rsq_val <- rsq(actual_values, predicted_values)

print(paste("\nModel Evaluation Metrics:"))
print(paste("RMSE:", round(rmse_val, 3)))
print(paste("MAE:", round(mae_val, 3)))
print(paste("R-squared:", round(rsq_val, 3)))
```


Okay, let's elaborate further on linear regression models and then on skewness and normalization techniques.

---

### More on Linear Regression Models

Linear regression is a fundamental statistical method used to model the linear relationship between a dependent variable (target) and one or more independent variables (predictors).

**Explanation:**
The goal of linear regression is to find the best-fitting straight line (or hyperplane in multivariate cases) that describes how the dependent variable changes as the independent variables change.

*   **Simple Linear Regression**: Involves one dependent variable and one independent variable.
*   **Multivariate Linear Regression**: Involves one dependent variable and two or more independent variables.

The model assumes a linear relationship, independence of observations, homoscedasticity (constant variance of residuals), and normality of residuals.

**Demo Snippets:**

**Example 1: Simple Linear Regression and Interpretation (`lab10.R` conceptual, `lab9.R` for `lm`)**

Let's use a simple example to show the `lm` function and its `summary` output.

```r
data(mtcars)

# Simple linear regression: Predict MPG based on Weight
model_simple <- lm(mpg ~ wt, data = mtcars)

print("Summary of Simple Linear Regression Model (MPG vs Weight):")
print(summary(model_simple))

# Interpretation of summary output:
# - Coefficients: 'Estimate' gives the change in MPG for a one-unit increase in Weight.
# - Std. Error: Standard error of the coefficient estimate.
# - t value: Test statistic for the hypothesis that the coefficient is zero.
# - Pr(>|t|): p-value, indicates significance of the coefficient.
# - R-squared: Proportion of variance in MPG explained by Weight (0 to 1).
# - F-statistic, p-value: Overall significance of the model.
```

**Example 2: Multivariate Linear Regression and Prediction (`lab9.R`)**

`lab9.R` provides a good example of a multivariate linear model for population forecasting.

```r
set.seed(1005) # For reproducibility
# Create a dummy data frame similar to df_all in lab9.R
years_all <- 1950:2025
n <- length(years_all)
train_data_lm <- data.frame(
  Year = years_all,
  Population_clean = round(100 + 5*(years_all-1950) + rnorm(n,0,10), 2),
  GDP_per_capita = round(1000 + 50*(years_all-1950) + rnorm(n,0,200), 2),
  Fertility_Rate = round(6 - 0.05*(years_all-1950) + rnorm(n,0,0.5), 2),
  Urbanization_pct = round(10 + 0.8*(years_all-1950) + rnorm(n,0,3), 2),
  Literacy_Rate = round(50 + 1*(years_all-1950) + rnorm(n,0,2), 2)
)

# Simulate a future dataset for prediction
future_data_lm <- data.frame(
  Year = 2026:2050,
  GDP_per_capita = round(1000 + 50*(2026:2050-1950) + rnorm(length(2026:2050),0,200), 2),
  Fertility_Rate = round(6 - 0.05*(2026:2050-1950) + rnorm(length(2026:2050),0,0.5), 2),
  Urbanization_pct = round(10 + 0.8*(2026:2050-1950) + rnorm(length(2026:2050),0,3), 2),
  Literacy_Rate = round(50 + 1*(2026:2050-1950) + rnorm(length(2026:2050),0,2), 2)
)


# Model as in lab9.R
model_multi <- lm(Population_clean ~ Year + GDP_per_capita + Fertility_Rate +
                   Urbanization_pct + Literacy_Rate, data=train_data_lm)

print("\nSummary of Multivariate Linear Regression Model (Population Forecast):")
print(summary(model_multi))

# Predict on new data
forecast_population <- predict(model_multi, newdata=future_data_lm)
print("\nFirst 5 Predicted Population Values for Future Years:")
print(data.frame(Year = head(future_data_lm$Year, 5), Forecast = head(forecast_population, 5)))
```

**Example 3: Assessing Model Assumptions with Diagnostic Plots**

R's `plot()` function for an `lm` object generates four standard diagnostic plots to check model assumptions.

```r
data(mtcars)
model_simple <- lm(mpg ~ wt, data = mtcars)

# Generate diagnostic plots
# par(mfrow = c(2, 2)) # Uncomment to see all 4 plots at once
plot(model_simple)
# par(mfrow = c(1, 1)) # Reset plotting layout
```

*   **Residuals vs Fitted**: Checks for linearity and homoscedasticity. A random scatter around 0 is ideal.
*   **Normal Q-Q**: Checks if residuals are normally distributed. Points should lie close to the diagonal line.
*   **Scale-Location (or Spread-Location)**: Another check for homoscedasticity. A horizontal line with randomly spread points is desired.
*   **Residuals vs Leverage**: Identifies influential points (outliers with high leverage).

---

### More on Skewness and Normalization

**Skewness**:
Skewness measures the asymmetry of the probability distribution of a real-valued random variable about its mean.

*   **Positive Skew (Right-skewed)**: The tail on the right side of the distribution is longer or fatter. Mean > Median. Example: Income distribution, reaction times.
*   **Negative Skew (Left-skewed)**: The tail on the left side of the distribution is longer or fatter. Mean < Median. Example: Exam scores (if most students do well).
*   **Zero Skew**: The distribution is symmetric. Mean ≈ Median. Example: Normal distribution.

**Why address skewness?**
Many statistical models, especially linear regression, assume that the residuals (and sometimes the dependent variable) are normally distributed. Skewed data can violate this assumption, leading to:
*   Biased parameter estimates.
*   Incorrect standard errors and p-values.
*   Reduced model accuracy and interpretability.
Transforming skewed data can help achieve a more symmetric distribution, often making the data more suitable for these models.

**Normalization (Scaling)**:
Normalization (or scaling) refers to transforming data to a common scale, usually between 0 and 1 or with a mean of 0 and a standard deviation of 1. This is different from skewness reduction, though both are data transformations.

*   **Min-Max Scaling**: Scales data to a fixed range, usually \[0, 1]. `(x - min(x)) / (max(x) - min(x))`
*   **Standardization (Z-score normalization)**: Scales data to have a mean of 0 and a standard deviation of 1. `(x - mean(x)) / sd(x)`

**When to use which?**
*   **Skewness Reduction**: Applied to make the *shape* of the distribution more symmetric. Done *before* modeling if model assumptions require it.
*   **Normalization/Scaling**: Applied to ensure that all features contribute equally to the model, especially for algorithms sensitive to feature magnitudes (e.g., k-NN, SVMs, neural networks, PCA). Done *after* skewness reduction if both are needed.

**Demo Snippets:**

**Example 1: Measuring Skewness (custom function from `lab8.R`)**

```r
# Custom skewness function (from lab8.R)
sk <- function(x) {
  x <- x[!is.na(x)]
  s <- sd(x)
  n <- length(x)
  if(s == 0 | n < 3) NA else sum((x - mean(x))^3) / ((n - 1) * s^3)
}

# Generate different types of distributions
set.seed(123)
normal_data <- rnorm(1000, 0, 1)        # Approximately symmetric
right_skewed_data <- rchisq(1000, df = 3) # Chi-squared is right-skewed
left_skewed_data <- -rchisq(1000, df = 3) # Negative chi-squared is left-skewed

print(paste("Skewness - Normal Data:", round(sk(normal_data), 3)))
print(paste("Skewness - Right-Skewed Data:", round(sk(right_skewed_data), 3)))
print(paste("Skewness - Left-Skewed Data:", round(sk(left_skewed_data), 3)))

# Visualize to confirm
par(mfrow = c(1, 3))
hist(normal_data, main="Normal Data", col="lightblue")
hist(right_skewed_data, main="Right-Skewed Data", col="salmon")
hist(left_skewed_data, main="Left-Skewed Data", col="lightgreen")
par(mfrow = c(1, 1))
```

**Example 2: Skewness Transformations (from `lab8.R`)**

`lab8.R` provides a suite of transformation functions. Let's demonstrate some of them.

```r
# Transformations from lab8.R
log1 <- function(x) log1p(x) # log(1+x), good for positive values including 0
sqrt1 <- function(x) sqrt(x)
bc <- function(x) (x^.5 - 1) / .5 # Simplified Box-Cox (lambda=0.5 for sqrt-like)
yj <- function(x) { # Yeo-Johnson, handles positive and negative values
  pos = x >= 0
  res = rep(0, length(x))
  res[pos] = log1p(x[pos])
  res[!pos] = -log1p(-x[!pos])
  res
}
rinv <- function(x) { # Rank-based Inverse Normal Transformation
  ranks <- rank(x, ties.method = "average")
  qnorm((ranks - 0.5) / length(x))
}

set.seed(456)
original_skewed_data <- rexp(500, rate = 0.1) + 1 # Add 1 to avoid log(0) issues

print(paste("Original Skewness:", round(sk(original_skewed_data), 3)))

# Log Transformation
log_transformed_data <- log1(original_skewed_data)
print(paste("Log Transformed Skewness:", round(sk(log_transformed_data), 3)))

# Square Root Transformation
sqrt_transformed_data <- sqrt1(original_skewed_data)
print(paste("Sqrt Transformed Skewness:", round(sk(sqrt_transformed_data), 3)))

# Visualize the effects
par(mfrow = c(1, 3))
hist(original_skewed_data, main=paste("Original (Skew:", round(sk(original_skewed_data), 2), ")"), col="salmon")
hist(log_transformed_data, main=paste("Log Transformed (Skew:", round(sk(log_transformed_data), 2), ")"), col="lightgreen")
hist(sqrt_transformed_data, main=paste("Sqrt Transformed (Skew:", round(sk(sqrt_transformed_data), 2), ")"), col="lightblue")
par(mfrow = c(1, 1))
```

**Example 3: Normalization (Scaling)**

```r
set.seed(789)
feature_data <- data.frame(
  Age = sample(18:70, 50, replace = TRUE),
  Income = round(rlnorm(50, meanlog = 10, sdlog = 0.8)), # Log-normal for skewed income
  Experience = sample(0:40, 50, replace = TRUE)
)

print("Original Feature Data (first 5 rows):")
print(head(feature_data))

# Min-Max Scaling (to range [0, 1])
min_max_scale <- function(x) {
  (x - min(x)) / (max(x) - min(x))
}
feature_data_minmax <- as.data.frame(lapply(feature_data, min_max_scale))
print("\nMin-Max Scaled Data (first 5 rows):")
print(head(feature_data_minmax))

# Standardization (Z-score normalization, mean=0, sd=1)
z_score_scale <- function(x) {
  (x - mean(x)) / sd(x)
}
feature_data_zscore <- as.data.frame(lapply(feature_data, z_score_scale))
print("\nZ-score Standardized Data (first 5 rows):")
print(head(feature_data_zscore))
```

These examples should give you a deeper understanding of linear regression, its assumptions, how to measure and transform skewness, and the difference between skewness reduction and general data normalization.