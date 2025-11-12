# Part A - Basic Statistics using mtcars and iris datasets
library(graphics)
library(stats)
# 1. DATA EXPLORATION
data(mtcars)
data(iris)

print("=== DATASET OVERVIEW ===")
print("MTCARS - Structure and Summary:")
str(mtcars)
summary(mtcars[, c("mpg", "hp", "wt")])

print("\nIRIS - Structure and Summary:")
str(iris)
summary(iris[, c("Sepal.Length", "Sepal.Width", "Petal.Length")])


# 2. BASIC STATISTICS CALCULATION 


print("\n=== BASIC STATISTICS ===")
mtcars_vars <- mtcars[, c("mpg", "hp", "wt")]

print("MTCARS Dataset Statistics:")
print("Means:"); print(round(apply(mtcars_vars, 2, mean), 2))
print("Medians:"); print(round(apply(mtcars_vars, 2, median), 2))
print("Standard Deviations:"); print(round(apply(mtcars_vars, 2, sd), 2))
print("Variances:"); print(round(apply(mtcars_vars, 2, var), 2))
print("Correlation Matrix:"); print(round(cor(mtcars_vars), 3))
print("Covariance Matrix:"); print(round(cov(mtcars_vars), 2))

# IRIS Dataset - Select variables: Sepal.Length, Sepal.Width, Petal.Length
iris_vars <- iris[, c("Sepal.Length", "Sepal.Width", "Petal.Length")]

print("\nIRIS Dataset Statistics:")
print("Means:"); print(round(apply(iris_vars, 2, mean), 2))
print("Medians:"); print(round(apply(iris_vars, 2, median), 2))
print("Standard Deviations:"); print(round(apply(iris_vars, 2, sd), 2))
print("Variances:"); print(round(apply(iris_vars, 2, var), 2))
print("Correlation Matrix:"); print(round(cor(iris_vars), 3))
print("Covariance Matrix:"); print(round(cov(iris_vars), 2))


# 3. OUTLIER DETECTION AND HANDLING 


print("\n=== OUTLIER ANALYSIS FOR MPG VARIABLE ===")

# Analyze mpg variable from mtcars
mpg_data <- mtcars$mpg

# Method 1: Boxplot method
outliers_box <- boxplot.stats(mpg_data)$out
print(paste("Boxplot method outliers:", paste(outliers_box, collapse=", ")))

# Method 2: IQR method
Q1 <- quantile(mpg_data, 0.25)
Q3 <- quantile(mpg_data, 0.75)
IQR_val <- IQR(mpg_data)
lower_bound <- Q1 - 1.5 * IQR_val
upper_bound <- Q3 + 1.5 * IQR_val

print(paste("IQR Method - Q1:", round(Q1,2), "Q3:", round(Q3,2), "IQR:", round(IQR_val,2)))
print(paste("Bounds: Lower =", round(lower_bound,2), "Upper =", round(upper_bound,2)))

outliers_iqr <- mpg_data[mpg_data < lower_bound | mpg_data > upper_bound]
print(paste("IQR method outliers:", paste(outliers_iqr, collapse=", ")))

# Handle outliers using winsorization
mpg_handled <- mpg_data
mpg_handled[mpg_handled < lower_bound] <- lower_bound
mpg_handled[mpg_handled > upper_bound] <- upper_bound

print("Before vs After handling:")
print(paste("Original: Mean =", round(mean(mpg_data),2), "SD =", round(sd(mpg_data),2)))
print(paste("Handled: Mean =", round(mean(mpg_handled),2), "SD =", round(sd(mpg_handled),2)))


# 4. VISUALIZATIONS 
print("\n=== CREATING VISUALIZATIONS ===")
par(mfrow=c(2,3))

# Plot 1: Histogram of mpg
hist(mtcars$mpg, main="MPG Distribution", xlab="Miles Per Gallon", 
     col="lightblue", breaks=10)
abline(v=mean(mtcars$mpg), col="red", lwd=2, lty=2)

# Plot 2: Boxplot of hp
boxplot(mtcars$hp, main="Horsepower Boxplot", ylab="HP", col="lightgreen")

# Plot 3: Scatter plot mpg vs wt with correlation
plot(mtcars$wt, mtcars$mpg, main="MPG vs Weight", 
     xlab="Weight (1000 lbs)", ylab="MPG", pch=19, col="blue")
abline(lm(mpg ~ wt, data=mtcars), col="red", lwd=2)
text(4, 30, paste("r =", round(cor(mtcars$wt, mtcars$mpg), 3)), col="red")

# Plot 4: Pairs plot for mtcars
pairs(mtcars_vars, main="Mtcars Relationships", pch=19, col="darkblue")

# Plot 5: Histogram of Sepal.Length
hist(iris$Sepal.Length, main="Sepal Length Distribution", 
     xlab="Sepal Length (cm)", col="pink", breaks=12)
abline(v=mean(iris$Sepal.Length), col="red", lwd=2, lty=2)

# Plot 6: Boxplot by species
boxplot(Sepal.Width ~ Species, data=iris, main="Sepal Width by Species",
        xlab="Species", ylab="Sepal Width (cm)", 
        col=c("red", "green", "blue"))
par(mfrow=c(1,1))


# 5. INTERPRETATION AND SUMMARY 

print("\n=== FINDINGS AND INTERPRETATION ===")

print("\nMTCARS ANALYSIS:")
print("1. Descriptive Statistics:")
print("   - MPG: Mean=20.09, Median=19.20, SD=6.03 (moderate variability)")
print("   - HP: Mean=146.69, Median=123.00, SD=68.56 (high variability)")
print("   - WT: Mean=3.22, Median=3.33, SD=0.98 (low variability)")

print("\n2. Correlation Insights:")
print(paste("   - MPG vs HP:", round(cor(mtcars$mpg, mtcars$hp), 3), "(strong negative)"))
print(paste("   - MPG vs WT:", round(cor(mtcars$mpg, mtcars$wt), 3), "(strong negative)"))
print(paste("   - HP vs WT:", round(cor(mtcars$hp, mtcars$wt), 3), "(moderate positive)"))
print("   → Heavier cars with more HP have lower fuel efficiency")

print("\n3. Outlier Analysis:")
print(paste("   - Outliers found:", length(outliers_iqr), "using IQR method"))
print("   - Handled using winsorization (capping at boundaries)")

print("\nIRIS ANALYSIS:")
print("4. Key Correlations:")
print(paste("   - Sepal.Length vs Petal.Length:", round(cor(iris$Sepal.Length, iris$Petal.Length), 3)))
print("   → Strong positive correlation indicates coordinated flower growth")
print(paste("   - Sepal.Length vs Sepal.Width:", round(cor(iris$Sepal.Length, iris$Sepal.Width), 3)))
print("   → Weak negative correlation suggests independent growth patterns")

print("\n5. Statistical Conclusions:")
print("   - Vehicle weight is primary predictor of fuel efficiency (r=-0.868)")
print("   - Flower morphology shows species-specific coordinated growth")
print("   - Outlier detection methods successfully identified extreme values")
print("   - Data distributions support use of parametric statistical methods")

print("\n=== ANALYSIS COMPLETE ===")
