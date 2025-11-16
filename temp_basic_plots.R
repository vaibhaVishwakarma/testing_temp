library(ggplot2)
library(dplyr)

# Sample Medical Data (conceptual, similar to data in Medical/BMI EDA section)
medical_data_gg <- data.frame(
  Age = round(rnorm(100, 45, 10)),
  BMI = round(rnorm(100, 27, 3), 1),
  Cholesterol = round(rnorm(100, 200, 40)),
  DiseaseStatus = sample(c("Healthy", "Diabetic"), 100, replace = TRUE, prob = c(0.7, 0.3))
)
medical_data_gg$Age <- pmax(18, medical_data_gg$Age)
medical_data_gg$BMI <- pmax(15, medical_data_gg$BMI)
medical_data_gg$Cholesterol <- pmax(100, medical_data_gg$Cholesterol)


# 1. Scatter Plot (Age vs. BMI)
png("C:/Users/vaibh/Downloads/dsc_fat/plot_age_vs_bmi.png")
p_scatter <- ggplot(medical_data_gg, aes(x = Age, y = BMI)) +
  geom_point(color = "darkblue", alpha = 0.6) +
  labs(title = "Age vs. BMI Distribution", x = "Age (Years)", y = "BMI") +
  theme_minimal()
print(p_scatter)
dev.off()
cat("Generated plot: plot_age_vs_bmi.png\n")

# 2. Boxplot (BMI by Disease Status)
png("C:/Users/vaibh/Downloads/dsc_fat/plot_bmi_by_disease.png")
p_boxplot <- ggplot(medical_data_gg, aes(x = DiseaseStatus, y = BMI, fill = DiseaseStatus)) +
  geom_boxplot() +
  labs(title = "BMI Distribution by Disease Status", x = "Disease Status", y = "BMI") +
  theme_bw()
print(p_boxplot)
dev.off()
cat("Generated plot: plot_bmi_by_disease.png\n")

# 3. Histogram (Cholesterol)
png("C:/Users/vaibh/Downloads/dsc_fat/plot_cholesterol_hist.png")
p_hist <- ggplot(medical_data_gg, aes(x = Cholesterol)) +
  geom_histogram(binwidth = 10, fill = "lightcoral", color = "black") +
  labs(title = "Distribution of Cholesterol Levels", x = "Cholesterol Level", y = "Frequency") +
  theme_classic()
print(p_hist)
dev.off()
cat("Generated plot: plot_cholesterol_hist.png\n")
