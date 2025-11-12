# Initialize 
bike_capacity <- sample(150:500, 5)
car_capacity <- sample(150:500, 4)
vip_capacity <- 10

bike_used <- rep(0, 5)
car_used <- rep(0, 4)
vip_used <- 0

num_bikes <- sample(800:2000, 1)
num_cars <- sample(400:1200, 1)
num_vips <- sample(5:15, 1)

#' Allocate parking to vehicles based on capacity and usage
#'
#' @param arrivals Integer. Number of arriving vehicles.
#' @param capacity_vec Integer vector. Maximum capacity of each parking slot.
#' @param used_vec Integer vector. Current used count in each slot.
#'
#' @return Integer vector. Updated used_vec after allocation.
allocate_parking <- function(arrivals, capacity_vec, used_vec) {
  for (i in 1:arrivals) {
    remaining <- capacity_vec - used_vec
    if (max(remaining) <= 0) {
      cat("No more available space in this category.\n")
      break
    }
    slot <- which.max(remaining)
    used_vec[slot] <- used_vec[slot] + 1
  }
  return(used_vec)
}

#' Display parking slot status
#'
#' @param capacity_vec Integer vector. Maximum capacity of each parking slot.
#' @param used_vec Integer vector. Current usage of each parking slot.
#' @param type Character. Type of vehicle (e.g., "Bike", "Car").
#'
#' @return None. Prints the status to the console.
display_parking_status <- function(capacity_vec, used_vec, type = "Bike") {
  full_slots <- c()
  for (i in 1:length(capacity_vec)) {
    status <- ifelse(used_vec[i] == capacity_vec[i], "[FULL]", "")
    if (status == "[FULL]") full_slots <- c(full_slots, i)
    cat(sprintf("Slot %d -> Used: %d / %d %s\n",
                i, used_vec[i], capacity_vec[i], status))
  }
  if (length(full_slots) > 0) {
    cat(sprintf("%s Parking FULL in slot(s): %s\n", type, paste(full_slots, collapse = ", ")))
  }
}

# Allocate VIPs directly to VIP parking
if (num_vips <= vip_capacity) {
  vip_used <- num_vips
  cat(sprintf("All %d VIPs accommodated in VIP parking.\n", num_vips))
} else {
  vip_used <- vip_capacity
  cat(sprintf("Only %d VIPs accommodated out of %d\n", vip_used, num_vips))
  cat("No more available space in this category.\n")
}

# Allocate Bikes
bike_used <- allocate_parking(num_bikes, bike_capacity, bike_used)

# Allocate Cars
car_used <- allocate_parking(num_cars, car_capacity, car_used)

# Final Summary
cat("=========== Final Parking Status ===========\n")
cat("BikeParking Status:\n")
display_parking_status(bike_capacity, bike_used, "Bike")

cat("\nCarParking Status:\n")
display_parking_status(car_capacity, car_used, "Car")

vip_status <- ifelse(vip_used == vip_capacity, "[FULL]", "")
cat(sprintf("\nVIP Parking Used: %d / %d %s\n", vip_used, vip_capacity, vip_status))

total_capacity <- sum(bike_capacity) + sum(car_capacity) + vip_capacity
used_capacity <- sum(bike_used) + sum(car_used) + vip_used
remaining_capacity <- total_capacity - used_capacity
utilization_percent <- round((used_capacity / total_capacity) * 100, 2)

cat("=========== Parking Utilization Report ===========\n")
cat(sprintf("Total Capacity: %d\n", total_capacity))
cat(sprintf("Used Capacity: %d\n", used_capacity))
cat(sprintf("Remaining Capacity: %d\n", remaining_capacity))
cat(sprintf("Utilization: %.2f %%\n", utilization_percent))
