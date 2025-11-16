load("C:/Users/vaibh/Downloads/dsc_fat/regression_results.RData")

# Custom evaluation functions
rmse <- function(actual, pred) {
  sqrt(mean((actual - pred)^2))
}
mae <- function(actual, pred) {
  mean(abs(actual - pred))
}
rsq <- function(actual, pred) {
  1 - sum((actual - pred)^2) / sum((actual - mean(actual))^2)
}

actual_values <- test_set$Y
predicted_values <- predictions

rmse_val <- rmse(actual_values, predicted_values)
mae_val <- mae(actual_values, predicted_values)
rsq_val <- rsq(actual_values, predicted_values)

cat("\nModel Evaluation Metrics:\n")
cat(paste("RMSE:", round(rmse_val, 3), "\n"))
cat(paste("MAE:", round(mae_val, 3), "\n"))
cat(paste("R-squared:", round(rsq_val, 3), "\n"))
