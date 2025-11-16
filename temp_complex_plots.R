library(ggplot2)
library(dplyr)
library(lubridate)

# Sample Flight Data (conceptual, similar to data in Flight/Airline EDA section)
flight_data_gg <- data.frame(
  Airline = sample(c("AirlineA", "AirlineB"), 200, replace = TRUE),
  OriginAirport = sample(c("JFK", "LAX", "ORD"), 200, replace = TRUE),
  DepartureDelay_minutes = round(rnorm(200, 15, 30)),
  FlightDuration_hours = round(runif(200, 1.0, 6.0), 1)
)
flight_data_gg$DepartureDelay_minutes <- pmax(-30, flight_data_gg$DepartureDelay_minutes)


# 1. Multi-Faceted Plot (Delay Distribution by Airline and Origin Airport)
png("C:/Users/vaibh/Downloads/dsc_fat/plot_multi_faceted_delay.png", width = 800, height = 600)
p_facet <- ggplot(flight_data_gg, aes(x = DepartureDelay_minutes, fill = Airline)) +
  geom_histogram(binwidth = 10, position = "identity", alpha = 0.7) +
  facet_wrap(~ OriginAirport, scales = "free_y") + # Separate plots for each origin airport
  labs(title = "Departure Delay Distribution by Airline & Origin Airport",
       x = "Departure Delay (minutes)", y = "Frequency") +
  theme_light() +
  theme(legend.position = "bottom")
print(p_facet)
dev.off()
cat("Generated plot: plot_multi_faceted_delay.png\n")

# 2. Line Chart with `stat_summary` (Average Flight Duration Trend for different Airlines)
# To create a trend, let's add a dummy 'Day' variable for this demo
flight_data_gg_trend <- flight_data_gg %>%
  mutate(Day = sample(1:30, nrow(.), replace = TRUE)) %>%
  group_by(Airline, Day) %>%
  summarise(AvgDuration = mean(FlightDuration_hours), .groups = 'drop')

png("C:/Users/vaibh/Downloads/dsc_fat/plot_flight_duration_trend.png", width = 800, height = 500)
p_line_trend <- ggplot(flight_data_gg_trend, aes(x = Day, y = AvgDuration, color = Airline)) +
  geom_line(linewidth = 1.2) + # Thicker lines
  geom_point(size = 3) +       # Larger points
  labs(title = "Average Flight Duration Trend by Airline (Conceptual)",
       x = "Day of Month", y = "Average Flight Duration (hours)") +
  scale_color_brewer(palette = "Set1") + # Use a color palette
  theme_minimal() +
  theme(plot.title = element_text(face = "bold", size = 14)) # Custom title style
print(p_line_trend)
dev.off()
cat("Generated plot: plot_flight_duration_trend.png\n")
