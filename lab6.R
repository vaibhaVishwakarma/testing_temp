set.seed(1005)
uid = c(1:1000)
age = sample(18:65,1000,TRUE)
gender = sample(c("Male","Female","Other"),1000,TRUE)
productCat =  sample(c("Electronics","Clothing","Grocery","Furniture"),1000,TRUE)
quantity = sample(1:10,1000,TRUE)

putPrice = function(catg){
  if(catg == "Electronics") return(sample(1:200,1))
  if(catg == "Clothing") return(sample(200:400,1 ))
  if(catg == "Grocery") return(sample(400:600,1 ))
  return(sample(600:800,1 ))
}
price = unlist(lapply(as.list(productCat),putPrice))

start_date <- as.Date("2023-09-04")
end_date <- as.Date("2025-09-04")

all_dates <- seq.Date(start_date, end_date, by = "day")
purchaseDate <- sample(all_dates, 1000, replace = TRUE)

payMode = sample(c("Cash","Credit","Card","UPI","NetBanking"),1000,TRUE)

missing_N = 0.05*1000

idx_uid = sample(1:1000, missing_N)
idx_age = sample(1:1000, missing_N)
idx_gender = sample(1:1000, missing_N)
idx_productCat = sample(1:1000, missing_N)
idx_price = sample(1:1000, missing_N)
idx_day = sample(1:1000, missing_N)
idx_mode = sample(1:1000, missing_N)

uid[idx_uid] = NA
age[idx_age] = NA
gender[idx_gender] = NA
productCat[idx_productCat] = NA
price[idx_price] = NA
purchaseDate[idx_day] = NA
payMode[idx_mode] = NA

data = data.frame(
  UID = uid,
  Age = age,
  Gender = gender,
  Category = productCat,
  Price = price,
  PurchaseDate = purchaseDate,
  PaymentMethod = payMode,
  Quantity = quantity
)
write.csv(data, "customData.csv", row.names = FALSE)

# (2) Reading and Exploring Data
df <- read.csv("customData.csv")

cat("\n--- First 6 rows ---\n")
print(head(df))

cat("\n--- Summary ---\n")
print(summary(df))

cat("\n--- Missing values count ---\n")
print(colSums(is.na(df)))

# (3) Handling Missing Values
# (a) Removal (complete cases)
df_complete <- na.omit(df)

# (b) Median Imputation
df_medianImp <- df
df_medianImp$Age[is.na(df_medianImp$Age)] <- median(df_medianImp$Age, na.rm = TRUE)
df_medianImp$Price[is.na(df_medianImp$Price)] <- median(df_medianImp$Price, na.rm = TRUE)

# LOCF for categorical columns
locf <- function(x) {
  for (i in 2:length(x)) {
    if (is.na(x[i])) x[i] <- x[i-1]
  }
  return(x)
}
df_medianImp$Gender <- locf(df_medianImp$Gender)
df_medianImp$Category <- locf(df_medianImp$Category)
df_medianImp$PaymentMethod <- locf(df_medianImp$PaymentMethod)

# (c) Predictive Imputation using Linear Regression for Price
df_predImp <- df
fit <- lm(Price ~ Age + Quantity, data=df_predImp, na.action=na.exclude)
pred_vals <- predict(fit, newdata=df_predImp)
df_predImp$Price[is.na(df_predImp$Price)] <- pred_vals[is.na(df_predImp$Price)]

cat("\n--- Missing value handling done: Median + LOCF + Regression ---\n")

# (4) Data Analysis
# Total sales per product category
cat("\n--- Total Sales by Category ---\n")
sales_category <- tapply(df_medianImp$Price * df_medianImp$Quantity, df_medianImp$Category, sum, na.rm=TRUE)
print(sales_category)

# Average spending per customer
cat("\n--- Average Spending per Customer ---\n")
spend_per_customer <- tapply(df_medianImp$Price * df_medianImp$Quantity, df_medianImp$UID, sum, na.rm=TRUE)
print(mean(spend_per_customer, na.rm=TRUE))

# Monthly sales trend
cat("\n--- Monthly Sales Trend ---\n")
df_medianImp$Month <- format(as.Date(df_medianImp$PurchaseDate), "%Y-%m")
monthly_sales <- tapply(df_medianImp$Price * df_medianImp$Quantity, df_medianImp$Month, sum, na.rm=TRUE)
print(head(monthly_sales))

# Payment mode preference
cat("\n--- Payment Mode Preference ---\n")
payment_pref <- table(df_medianImp$PaymentMethod)
print(payment_pref)

# (5) Visualization
barplot(sales_category, main="Total Sales by Category", ylab="Sales Amount", col="skyblue")

plot(monthly_sales, type="l", col="blue", lwd=2,
     main="Monthly Sales Trend", xlab="Month", ylab="Sales Amount")

pie(payment_pref, main="Payment Mode Distribution", col=rainbow(length(payment_pref)))

boxplot(Price ~ Category, data=df_medianImp,
        main="Price Distribution by Category",
        xlab="Product Category", ylab="Price",
        col="lightgreen", border="darkgreen")
