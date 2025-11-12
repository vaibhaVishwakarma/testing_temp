# R Codebase Overview

This repository contains R scripts demonstrating various programming concepts and data manipulation techniques. This README provides a basic introduction to R syntax, illustrated with examples from the codebase.

## Basic R Syntax

### 1. Variables and Assignment

In R, variables are assigned values using the `<-` operator.

**Example from `lab3.R`:**
```r
10|num_bikes <- sample(800:2000, 1)
```

**Explanation:**
- `num_bikes` is a variable.
- `sample(800:2000, 1)` generates a random integer between 800 and 2000, which is then assigned to `num_bikes`.

### 2. Vectors

Vectors are sequences of data elements of the same basic type.

**Example from `lab3.R`:**
```r
6|bike_used <- rep(0, 5)
```

**Explanation:**
- `rep(0, 5)` creates a vector of 5 zeros, assigned to `bike_used`.

**Example from `lab4.R`:**
```r
1|zone_name_1005 = paste("Zone", 1:20)
```

**Explanation:**
- `1:20` creates a sequence of numbers from 1 to 20.
- `paste("Zone", 1:20)` creates a character vector like "Zone 1", "Zone 2", ..., "Zone 20".

### 3. Lists

Lists are generic vectors, where elements can be of different types.

**Example from `lab4.R`:**
```r
9|city_flood_data_1005 = list(
   10|  zone_name = zone_name_1005,
   11|  rainfall_mm = rainfall_mm_1005,
   12|  drainage_capacity = drainage_capacity_1005,
   13|  population = population_1005,
   14|  water_logging_cm = water_logging_cm_1005,
   15|  green_cover_percent = green_cover_percent_1005
   16|)
```

**Explanation:**
- `list(...)` creates a list named `city_flood_data_1005` containing several named elements, each potentially a different type (e.g., character vector, numeric vector).
- Elements of a list can be accessed using `$` (e.g., `city_flood_data_1005$zone_name`).

### 4. Functions

Functions are defined using the `function()` keyword.

**Example from `lab3.R`:**
```r
21|allocate_parking <- function(arrivals, capacity_vec, used_vec) {
   22|  for (i in 1:arrivals) {
   23|    remaining <- capacity_vec - used_vec
   24|    if (max(remaining) <= 0) {
   25|      cat("No more available space in this category.\\n")
   26|      break
   27|    }
   28|    slot <- which.max(remaining)
   29|    used_vec[slot] <- used_vec[slot] + 1
   30|  }
   31|  return(used_vec)
   32|}
```

**Explanation:**
- `allocate_parking` is a function that takes three arguments: `arrivals`, `capacity_vec`, and `used_vec`.
- `return(used_vec)` specifies the value the function will output.

**Calling a function:**
```r
65|bike_used <- allocate_parking(num_bikes, bike_capacity, bike_used)
```

### 5. Conditional Statements (`if-else`)

Conditional logic is handled using `if`, `else if`, and `else`.

**Example from `lab4.R`:**
```r
43|assess_flood_risk_1005 = function(rainfall, drainage) {
   44|  diff = rainfall - drainage
   45|  if (diff > 200) {
   46|    return("High")
   47|  } else if (diff > 50) {
   48|    return("Moderate")
   49|  } else {
   50|    return("Low")
   51|  }
   52|}
```

**Explanation:**
- The function `assess_flood_risk_1005` uses `if`, `else if`, and `else` to determine a flood risk level based on the `diff` variable.

### 6. Loops (`for`)

`for` loops are used for iterating over a sequence.

**Example from `lab3.R`:**
```r
21|allocate_parking <- function(arrivals, capacity_vec, used_vec) {
   22|  for (i in 1:arrivals) {
   23|    remaining <- capacity_vec - used_vec
// ... existing code ...
   30|  }
   31|  return(used_vec)
   32|}
```

**Explanation:**
- The `for` loop iterates from `1` to `arrivals`, executing the code block within the curly braces for each iteration.

### 7. Comments

Comments in R start with `#`. Anything after `#` on the same line is ignored by the interpreter.

**Example from `lab3.R`:**
```r
1|# Initialize
```

**Explanation:**
- This line is a comment, providing a description of the following code.

### 8. Data Frames (from `lab11.R`)

Data frames are tabular data structures where each column can contain different types of data, but all elements within a column must be of the same type.

**Example from `lab11.R`:**
```r
32|  tibble(Location=loc, DateTime=dt, Vehicle_Count=round(vc),
   33|      Average_Speed_kmph=round(avg_speed,1), Weather=weather, Road_Type=road)
```

**Explanation:**
- `tibble()` is a function from the `tidyverse` package used to create a data frame.

**Accessing data frame columns:**
```r
55|data <- data %>%
   56|  mutate(Date = as.Date(DateTime),
   57|      Hour = hour(DateTime))
```
- `data$DateTime` would access the `DateTime` column of the `data` data frame.

### 9. Pipes (`%>%`)

The pipe operator `%>%` (from the `magrittr` package, often loaded with `tidyverse`) is used to pass the result of one function call as the first argument to the next function call.

**Example from `lab11.R`:**
```r
55|data <- data %>%
   56|  mutate(Date = as.Date(DateTime),
   57|      Hour = hour(DateTime))
```

**Explanation:**
- The `data` object is piped into the `mutate()` function, which adds new columns `Date` and `Hour` to the `data` frame. This makes code more readable by chaining operations.