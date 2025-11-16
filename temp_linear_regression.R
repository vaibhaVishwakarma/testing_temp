set.seed(123)
# Create a sample data frame
df_model <- data.frame(
  X1 = rnorm(100, 50, 10),
  X2 = runif(100, 10, 20),
  Category = sample(c("A", "B"), 100, replace = TRUE),
  Y = 5 + 0.5 * rnorm(100) + 2 * runif(100) + 10 * (sample(0:1, 100, replace = TRUE)) + rnorm(100, 0, 5)
)

# One-hot encode the categorical variable for regression
df_model$CategoryB <- ifelse(df_model$Category == "B", 1, 0)
df_model$Category <- NULL # Remove original categorical column

# Split into train and test sets
train_indices <- sample(1:nrow(df_model), 0.8 * nrow(df_model))
train_set <- df_model[train_indices, ]
test_set <- df_model[-train_indices, ]

# Build a multivariate linear regression model
# Y ~ . means 'Y' explained by all other variables in the data frame
model <- lm(Y ~ ., data = train_set)
print("Linear Regression Model Summary:")
print(summary(model))

# Make predictions on the test set
predictions <- predict(model, newdata = test_set)
print("\nFirst 5 Actual vs Predicted values on test set:")
print(data.frame(Actual = head(test_set$Y, 5), Predicted = head(predictions, 5)))
