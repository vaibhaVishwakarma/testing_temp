# 1. MacroTrends Population Data (1950–2025, in millions)
years_hist <- 1950:2025
pop_hist <- c(
  376.33,386.00,395.71,405.45,415.25,425.10,435.02,444.99,455.04,465.14,
  475.30,485.51,495.77,506.06,516.40,526.77,537.18,547.63,558.11,568.63,
  579.19,589.79,600.43,611.11,621.83,632.59,643.37,654.19,665.04,675.93,
  686.84,697.80,708.79,719.81,730.87,741.97,753.10,764.26,775.45,786.67,
  797.93,809.21,820.53,831.87,843.25,854.66,866.10,877.56,889.06,900.59,
  912.15,923.75,935.37,947.02,958.71,970.43,982.18,993.96,1005.77,1017.63,
  1029.51,1041.43,1053.37,1065.35,1077.35,1089.39,1101.46,1113.56,1125.69,1137.85,
  1150.05,1162.27,1174.53,1186.82,1199.14,1211.50
)

df_hist <- data.frame(Year = years_hist, Population = pop_hist)


# 2. Extend to 2050 & Add Features
years_all <- 1950:2050
n <- length(years_all)

# Interpolate / extrapolate base population
pop_interp <- approx(df_hist$Year, df_hist$Population, xout = years_all, rule = 2)$y
df_all <- data.frame(
  Year = years_all,
  Population = round(pop_interp,2),
  Birth_Rate = round(45 - 0.15*(years_all-1950) + rnorm(n,0,1.2),2),
  Death_Rate = round(30 - 0.12*(years_all-1950) + rnorm(n,0,1),2),
  Literacy_Rate = round(pmin(100,10+0.85*(years_all-1950)+rnorm(n,0,2)),2),
  GDP_per_capita = round(100 + 35*(years_all-1950) + rnorm(n,0,400),2),
  Urbanization_pct = round(10 + 0.6*(years_all-1950)+rnorm(n,0,2),2),
  Fertility_Rate = round(6 - 0.03*(years_all-1950) + rnorm(n,0,0.25),2),
  Life_Expectancy = round(35 + 0.2*(years_all-1950) + rnorm(n,0,1.5),2)
)

# 3. Introduce 6% Missing in Population & Impute

df_all$Population_raw <- df_all$Population
num_missing <- ceiling(0.06 * nrow(df_all))

set.seed(1005)  # reproducible
missing_idx <- sample(1:nrow(df_all), num_missing)
df_all$Population_raw[missing_idx] <- NA
cat("Introduced", num_missing, "missing values in Population\n")
write.csv(df_all, "india_population_full.csv", row.names = FALSE)

# Impute missing (linear interpolation + median for edges)
pop_imp <- df_all$Population_raw
for (i in which(is.na(pop_imp))) {
  left <- max(which(!is.na(pop_imp[1:i])))
  right <- min(which(!is.na(pop_imp[i:length(pop_imp)]))) + i - 1
  if (!is.na(left) && !is.na(right) && left < right) {
    pop_imp[i] <- pop_imp[left] +
      (pop_imp[right] - pop_imp[left]) * (i - left) / (right - left)
  }
}

if (any(is.na(pop_imp))) {
  pop_imp[is.na(pop_imp)] <- median(pop_imp, na.rm=TRUE)
}
df_all$Population_clean <- round(pop_imp,2)

cat("Imputation complete. Population_clean ready.\n")
summary(df_all[,c("Population_raw","Population_clean")])


# 4. Train Model (1950–2025) & Forecast (2026–2050)

train <- df_all[df_all$Year <= 2025,]
future <- df_all[df_all$Year > 2025,]

model <- lm(Population_clean ~ Year + GDP_per_capita + Fertility_Rate +
              Urbanization_pct + Literacy_Rate, data=train)

future$Forecast <- predict(model,newdata=future)
df_all$Forecast <- c(train$Population_clean, future$Forecast)

pop2050 <- future$Forecast[future$Year==2050]
cat("Projected Population in 2050:", round(pop2050,2),"million\n")


# 5. Model Evaluation

pred_train <- predict(model,newdata=train)
actual <- train$Population_clean
MAE <- mean(abs(actual-pred_train))
RMSE <- sqrt(mean((actual-pred_train)^2))
R2 <- summary(model)$r.squared
cat("MAE:",round(MAE,2)," RMSE:",round(RMSE,2)," R²:",round(R2,4),"\n")


# 6. Visualizations

par(mfrow=c(2,2))

# (a) Population Actual + Forecast
plot(df_all$Year, df_all$Forecast, type="l", col="blue", lwd=2,
     main="India Population (1950–2050)", xlab="Year", ylab="Population (millions)")
lines(train$Year, train$Population_clean, col="black", lwd=2)
legend("topleft",c("Historical (imputed)","Forecast"),
       col=c("black","blue"), lty=1, lwd=2, bty="n")

# (b) Annual Growth Rate (with forecast)
growth <- c(NA, diff(df_all$Forecast)/head(df_all$Forecast,-1)*100)
plot(df_all$Year,growth,type="l",col="darkgreen",lwd=2,
     main="Annual Growth Rate (%)",xlab="Year",ylab="Growth %")

# (c) Fertility vs Life Expectancy
plot(df_all$Fertility_Rate,df_all$Life_Expectancy,pch=19,col="purple",
     main="Fertility vs Life Expectancy",
     xlab="Fertility Rate",ylab="Life Expectancy")
abline(lm(Life_Expectancy~Fertility_Rate,data=df_all),col="red",lwd=2)

# (d) Urbanization vs Population
plot(df_all$Urbanization_pct,df_all$Forecast,pch=19,col="brown",
     main="Population vs Urbanization",
     xlab="Urbanization (%)",ylab="Population (millions)")

par(mfrow=c(1,1))


# 7. Extra Plots
# (a) Bar chart of Population (Historical only)
hist_years <- df_all$Year[df_all$Year <= 2025]
hist_pop   <- df_all$Population_clean[df_all$Year <= 2025]
barplot(hist_pop, names.arg=hist_years,
        main="Population (1950–2025, Historical)", col="lightblue",
        xlab="Year", ylab="Population (millions)", las=2, cex.names=0.6)

# (b) Bar chart with Forecast (1950–2050)
barplot(df_all$Forecast, names.arg=df_all$Year,
        main="Population (1950–2050, Historical+Forecast)",
        col=c(rep("lightblue", length(hist_years)),
              rep("orange", length(df_all$Year)-length(hist_years))),
        xlab="Year", ylab="Population (millions)", las=2, cex.names=0.6)
legend("topleft", legend=c("Historical","Forecast"),
       fill=c("lightblue","orange"), bty="n")

# (c) Boxplot by Decade
df_all$Decade <- (df_all$Year %/% 10) * 10
boxplot(Forecast ~ Decade, data=df_all,
        main="Population Distribution by Decade",
        xlab="Decade", ylab="Population (millions)", col="lightgreen")
