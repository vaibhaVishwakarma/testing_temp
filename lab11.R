# Load Required Libraries
library(tidyverse)
library(lubridate)
library(ggplot2)
library(scales)
 
set.seed(1005)
 
# 1. DATA PREPARATION
 
# Step 1: Generate Synthetic Dataset (>=1000 records)
locations <- c("Guindy Circle","T Nagar Signal","Anna Nagar Jn","Saidapet Jn",
            "Adyar Flyover","Velachery Jn","Porur Jn","Nungambakkam Jn")
weathers <- c("Sunny","Rainy","Cloudy")
road_types <- c("Highway","City Road")
 
n <- 1200   # at least 1000 records
start_time <- as.POSIXct("2025-10-01 06:00:00")
date_seq <- start_time + hours(0:(n-1))
 
generate_record <- function(dt) {
  loc <- sample(locations, 1)
  base <- 400 + 50*(which(locations==loc)-1)
  hr <- hour(dt)
  hour_factor <- ifelse(hr %in% c(8,9,17,18), 1.6,
                      ifelse(hr %in% c(7,19), 1.3, 1.0))
  weather <- sample(weathers, 1, prob=c(0.6,0.2,0.2))
  weather_factor <- ifelse(weather=="Rainy", 0.9, 1.0)
  vc <- rnorm(1, base*hour_factor*weather_factor, 60)
  avg_speed <- max(5, rnorm(1, 45 - (vc-400)/50 - ifelse(weather=="Rainy",10,0), 6))
  road <- ifelse(str_detect(loc,"Circle|Jn|Junction|Flyover"), "Highway", "City Road")
  tibble(Location=loc, DateTime=dt, Vehicle_Count=round(vc),
      Average_Speed_kmph=round(avg_speed,1), Weather=weather, Road_Type=road)
}
 
df <- map_dfr(date_seq, generate_record)
 
# Introduce 2% random missing values
for(i in 1:round(0.02*nrow(df)*4)) {
  col <- sample(c("Vehicle_Count","Average_Speed_kmph","Weather","Road_Type"), 1)
  row <- sample(1:nrow(df), 1)
  df[row, col] <- NA
}
 
# Save dataset
write_csv(df, "Chennai_Traffic_2025.csv")
 
# ---- Step 2: Load and Inspect ----
data <- read_csv("Chennai_Traffic_2025.csv")
cat("\nStructure of Dataset:\n"); str(data)
cat("\nMissing Values Count:\n"); print(colSums(is.na(data)))
cat("\nSummary Statistics:\n"); print(summary(data))
 
# Step 3: Add Date and Hour Columns
data <- data %>%
  mutate(Date = as.Date(DateTime),
      Hour = hour(DateTime))
 
# Step 4: Handle Missing Values
data <- data %>%
  group_by(Location) %>%
  mutate(Vehicle_Count = ifelse(is.na(Vehicle_Count), median(Vehicle_Count, na.rm=TRUE), Vehicle_Count),
      Average_Speed_kmph = ifelse(is.na(Average_Speed_kmph), median(Average_Speed_kmph, na.rm=TRUE), Average_Speed_kmph),
      Weather = ifelse(is.na(Weather), names(sort(table(Weather), decreasing=TRUE))[1], Weather),
      Road_Type = ifelse(is.na(Road_Type), names(sort(table(Road_Type), decreasing=TRUE))[1], Road_Type)) %>%
  ungroup()
 
write_csv(data, "Chennai_Traffic_2025_Cleaned.csv")
 
# 2. DATA RESHAPING with tidyr
 
# Gather to Long Format
df_long <- data %>%
  pivot_longer(cols=c(Vehicle_Count, Average_Speed_kmph),
            names_to="Measure", values_to="Value")
 
# Aggregate by Hour and Location
agg <- data %>%
  group_by(Location, Hour) %>%
  summarise(Avg_Vehicle_Count = mean(Vehicle_Count, na.rm=TRUE),
          Avg_Speed = mean(Average_Speed_kmph, na.rm=TRUE), .groups='drop')
 
# Spread Back to Wide Format
agg_wide <- agg %>%
  pivot_wider(names_from=Location, values_from=Avg_Vehicle_Count, values_fill=0)
 
# 3. VISUALIZATION with ggplot2
 
# Save plots in a folder
dir.create("Traffic_Plots", showWarnings = FALSE)
 
# Line Chart (Hourly Variation for a Selected Location)
sel_loc <- "T Nagar Signal"
p1 <- ggplot(filter(agg, Location==sel_loc), aes(x=Hour, y=Avg_Vehicle_Count)) +
  geom_line(color="blue") + geom_point() +
  labs(title=paste("Hourly Variation of Vehicle Count -", sel_loc),
    x="Hour of Day", y="Average Vehicle Count") +
  theme_minimal()
print(p1)  # <--- show in console
ggsave("Traffic_Plots/LineChart_SelectedLocation.png", p1, width=7, height=4)
 
# Multi-Faceted Plot (Across Locations & Weather)
p2 <- ggplot(data, aes(x=Hour, y=Vehicle_Count, color=Weather)) +
  stat_summary(fun=mean, geom="line", linewidth=1) +
  facet_wrap(~Location, scales="free_y") +
  labs(title="Hourly Vehicle Count Across Locations & Weather Conditions",
    x="Hour", y="Mean Vehicle Count") +
  theme_bw() +
  theme(legend.position="bottom")
print(p2)
ggsave("Traffic_Plots/MultiFacet_VehicleCount.png", p2, width=10, height=6)
 
# 4. BUILDING MAPS with ggplot2
 
# Location Coordinates
coords <- tribble(
  ~Location, ~Latitude, ~Longitude,
  "Guindy Circle", 13.0066, 80.2206,
  "T Nagar Signal", 13.0414, 80.2339,
  "Anna Nagar Jn", 13.0878, 80.2170,
  "Saidapet Jn", 13.0219, 80.2230,
  "Adyar Flyover", 13.0158, 80.2440,
  "Velachery Jn", 12.9887, 80.2219,
  "Porur Jn", 13.0210, 80.1385,
  "Nungambakkam Jn", 13.0606, 80.2316
)
 
map_data <- agg %>%
  group_by(Location) %>%
  summarise(Avg_Vehicle_Count = mean(Avg_Vehicle_Count),
          Avg_Speed = mean(Avg_Speed)) %>%
  left_join(coords, by="Location")
 
# Base Bubble Map
p3 <- ggplot(map_data, aes(x=Longitude, y=Latitude)) +
  geom_point(aes(size=Avg_Vehicle_Count, color=Avg_Speed), alpha=0.7) +
  geom_text(aes(label=Location), hjust=0, nudge_x=0.002, size=3) +
  scale_color_viridis_c(option="C", name="Avg Speed (km/h)") +
  scale_size(range=c(2,12)) +
  labs(title="Chennai Traffic Junctions - Vehicle Count & Speed",
    subtitle="Bubble size = Vehicle Count, Color = Avg Speed") +
  theme_minimal()
print(p3)
ggsave("Traffic_Plots/Chennai_Traffic_Map.png", p3, width=7, height=6)
 
# Highlight Hotspots (Speed < 20 km/h)
hotspots <- map_data %>% filter(Avg_Speed < 20)
p4 <- ggplot(map_data, aes(x=Longitude, y=Latitude)) +
  geom_point(aes(size=Avg_Vehicle_Count), color="gray", alpha=0.5) +
  geom_point(data=hotspots, aes(size=Avg_Vehicle_Count), shape=21, fill="red", color="black") +
  geom_text(data=hotspots, aes(label=Location), color="red", vjust=-1) +
  labs(title="Congestion Hotspots (Avg Speed < 20 km/h)") +
  theme_minimal()
print(p4)
ggsave("Traffic_Plots/Hotspot_Map.png", p4, width=7, height=6)
 
# 5. INSIGHT DEVELOPMENT
 
data <- data %>%
  mutate(Congestion_Index = (Vehicle_Count / max(Vehicle_Count)) +
        (1 - Average_Speed_kmph / max(Average_Speed_kmph)))
 
hourly_cong <- data %>%
  group_by(Hour) %>%
  summarise(Avg_Congestion = mean(Congestion_Index)) %>%
  arrange(desc(Avg_Congestion))
cat("\nTop Congested Hours:\n"); print(head(hourly_cong))
 
weather_cong <- data %>%
  group_by(Weather) %>%
  summarise(Avg_Congestion = mean(Congestion_Index)) %>%
  arrange(desc(Avg_Congestion))
cat("\nCongestion by Weather:\n"); print(weather_cong)
 
cat("\nHotspots (Speed < 20 km/h):\n")
print(hotspots)
 
cat("\n---- Recommendations ----\n")
cat("1. Adaptive signal control at hotspot junctions.\n")
cat("2. Diversion routes during 8–9 AM and 5–7 PM peaks.\n")
cat("3. Weather-based dynamic routing during rainy hours.\n")
cat("4. Deploy VMS boards and real-time alerts for commuters.\n")