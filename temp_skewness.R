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

# Visualize original data and save to file
png("C:/Users/vaibh/Downloads/dsc_fat/original_skew_hist.png")
hist(right_skewed_data, main="Original Right-Skewed Data", col="salmon")
dev.off()
print("Saved C:/Users/vaibh/Downloads/dsc_fat/original_skew_hist.png")

# Apply log transformation (log1p is log(1+x), safer for values near 0)
transformed_data <- log1p(right_skewed_data)
print(paste("Skewness after log transformation:", round(sk(transformed_data), 3)))

# Visualize transformed data and save to file
png("C:/Users/vaibh/Downloads/dsc_fat/transformed_skew_hist.png")
hist(transformed_data, main="Log-Transformed Data", col="lightgreen")
dev.off()
print("Saved C:/Users/vaibh/Downloads/dsc_fat/transformed_skew_hist.png")
