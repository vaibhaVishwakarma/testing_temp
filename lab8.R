n <- 2000


# Generate synthetic e-commerce dataset with demographic, behavioral, and product features
data <- data.frame(
  customer_age = round(rnorm(n, 35, 12)),
  customer_income = exp(rnorm(n, 10.5, 0.5)),
  days_since_last_purchase = rexp(n, 0.1),
  website_sessions = rpois(n, 3) + 1,
  cart_abandonment_rate = rbeta(n, 2, 8),
  avg_product_price = exp(rnorm(n, 3.2, 0.8)),
  num_items_viewed = rpois(n, 15) + 1,
  discount_used = rbinom(n, 1, 0.3),
  region = sample(c("North", "South", "East", "West"), n, 1),
  customer_segment = sample(c("Premium", "Standard", "Basic"), n, 1, prob = c(0.2, 0.5, 0.3)),
  marketing_emails_opened = rpois(n, 2)
)


# Compute target variable (order value) with skewness via exponential transformation
bv = 20 + .5*data$customer_age + .001*data$customer_income + 2*data$avg_product_price + 3*data$num_items_viewed +
  ifelse(data$discount_used, -10, 0) +
  ifelse(data$customer_segment == "Premium", 50,
         ifelse(data$customer_segment == "Standard", 20, 0)) +
  rnorm(n, 0, 15)
data$order_value = exp(log(pmax(bv, 1)) + rnorm(n, 0, 0.3))


# --- Missingness plan: Inject missing values in specified variables with different proportions ---
miss_v = c("customer_income", "days_since_last_purchase", "avg_product_price", "marketing_emails_opened", "region")
miss_p = c(.05, .04, .03, .06, .03)
for(i in 1:5) data[[miss_v[i]]][sample(n, n*miss_p[i])] <- NA


# Display missing value counts before imputation
cat("\nMissing values BEFORE imputation per variable:\n")
print(sapply(data, function(x) sum(is.na(x))))


# --- Handle missing values using median for numeric and mode for categorical ---
for(v in miss_v[1:4]) data[[v]][is.na(data[[v]])] <- median(data[[v]], na.rm = TRUE)
modeR = names(which.max(table(data$region)))
data$region[is.na(data$region)] <- modeR


# Display missing value counts after imputation
cat("Missing values AFTER imputation per variable:\n")
print(sapply(data, function(x) sum(is.na(x))))


# --- Define skewness function and calculate skewness for numeric variables pre-transformation ---
sk <- function(x) {
  x <- x[!is.na(x)]
  s <- sd(x)
  n <- length(x)
  if(s == 0 | n < 3) NA else sum((x - mean(x))^3) / ((n - 1) * s^3)
}
numv = sapply(data, is.numeric)
sk_pre = sapply(data[numv], sk)
sk_pre_tab = data.frame(Variable = names(sk_pre), Skewness = round(sk_pre, 3))
cat("\nSkewness before transformation:\n")
print(sk_pre_tab)


# --- Define transformation functions for skewness reduction ---
log1 = function(x) log1p(x)
sqrt1 = function(x) sqrt(x)
bc = function(x) (x^.5 - 1) / .5
yj = function(x) {
  pos = x >= 0
  res = rep(0, length(x))
  res[pos] = log1p(x[pos])
  res[!pos] = -log1p(-x[!pos])
  res
}
rinv <- function(x) {
  ranks <- rank(x, ties.method = "average")
  qnorm((ranks - 0.5) / length(x))
}


# Apply best skewness-reducing transformation to highly skewed numeric variables
data_tr = data
for(nm in names(data)[numv][abs(sk_pre) > 0.5]) {
  x = data[[nm]]
  if(all(x > 0, na.rm = TRUE)) {
    vals = c(log = sk(log1(x)), sqrt = sk(sqrt1(x)), bx = sk(bc(x)))
    best = names(vals)[which.min(abs(vals))]
    data_tr[[nm]] = switch(best, log = log1(x), sqrt = sqrt1(x), bx = bc(x))
  } else {
    if(abs(sk(yj(x))) < abs(sk(rinv(x)))) data_tr[[nm]] = yj(x) else data_tr[[nm]] = rinv(x)
  }
}


# --- Calculate skewness after transformations ---
sk_post = sapply(data_tr[numv], sk)
sk_post_tab = data.frame(Variable = names(sk_post), Skewness = round(sk_post, 3))
cat("\nSkewness after transformation:\n")
print(sk_post_tab)


# --- Visualize before and after transformations side-by-side (histograms and boxplots) ---
oldpar <- par(mfrow = c(2, 2))
for(nm in names(data)[numv]) {
  v1 = data[[nm]]
  v2 = data_tr[[nm]]
  skv1 = sk(v1)
  skv2 = sk(v2)
  typ1 = ifelse(skv1 > 0.5, "Right-skewed", ifelse(skv1 < -0.5, "Left-skewed", "Symmetric"))
  typ2 = ifelse(skv2 > 0.5, "Right-skewed", ifelse(skv2 < -0.5, "Left-skewed", "Symmetric"))
  hist(v1, main = paste(nm, "BEFORE\n", typ1, "Sk:", round(skv1, 2)), col = "skyblue", breaks = 30)
  hist(v2, main = paste(nm, "AFTER\n", typ2, "Sk:", round(skv2, 2)), col = "lightgreen", breaks = 30)
  boxplot(v1, main = paste(nm, "BEFORE Box"), col = "skyblue")
  boxplot(v2, main = paste(nm, "AFTER Box"), col = "lightgreen")
}
par(oldpar)


# --- One-hot encode categorical variables for modeling ---
enc = function(df) {
  d = df
  for(catv in c('region','customer_segment')) {
    for(lv in unique(df[[catv]])) {
      d[[paste0(catv, "_", lv)]] <- as.numeric(df[[catv]] == lv)
    }
  }
  d$region <- d$customer_segment <- NULL
  d
}


# Prepare datasets and split into train/test
dat0 = enc(data)
dat1 = enc(data_tr)
split = function(d) {
  i = sample(nrow(d), 0.8 * nrow(d))
  list(tr = d[i,], te = d[-i,])
}
s0 = split(dat0)
s1 = split(dat1)


# Train linear regression models
m0 = lm(order_value ~ ., s0$tr)
m1 = lm(order_value ~ ., s1$tr)


# Predict on test sets
p0 = predict(m0, s0$te)
p1 = predict(m1, s1$te)


# Define evaluation metrics
rmse = function(actual, pred) sqrt(mean((actual - pred)^2))
mae = function(actual, pred) mean(abs(actual - pred))
rsq = function(actual, pred) 1 - sum((actual - pred)^2) / sum((actual - mean(actual))^2)


# Evaluate on test sets
metrics = data.frame(
  Model = c("Original", "Transformed"),
  RMSE = c(rmse(s0$te$order_value, p0), rmse(s1$te$order_value, p1)),
  MAE = c(mae(s0$te$order_value, p0), mae(s1$te$order_value, p1)),
  Rsq = c(rsq(s0$te$order_value, p0), rsq(s1$te$order_value, p1))
)
cat("\nTest-set metrics (original vs transformed):\n")
print(metrics)


# Residual skewness on test set
cat("\nResidual test skewness: Original =", round(sk(s0$te$order_value - p0), 2),
    "| Transformed =", round(sk(s1$te$order_value - p1), 2), "\n")