library(tseries)
library(forecast)


# ARIMA model practicing
# finding model parameters

# ARIMA(p, d, q)

# find difference (d) first, make series stationary before finding the AR and MA orders.

data = AirPassengers
class(data)

acf(data, lag.max=36, main="Corellogram (ACF) for AirPassengers")
plot(data, main="Plot for data AirPassengers")

# the plot has an upward trend as well as a seasonal growth.
# We want to remove the both and make the data stationary before working for ARIMA models.
# We can stablize the seasonal growth by log transformations.

log_data = log(data)
plot(log_data, main="Log data AirPassengers")

head(data)
head(log_data)

# After removing the growth, we still have the upwards trend.
# We can stabilize the trend by taking the differences of log transformed data

data_log_diff1 = diff(log_data)
plot(data_log_diff1, main="Difference 1 of Log transformed AirPassengers Data")

# In the original dataset, we could observe some seasonal differences.
# Peaks in summers, troughs in winters. We also need to deal with these fluctuations
# The ADF test expect long-term stochastic trends, they cannot correctly deal with periodic fluctuations.

# We can statistically detect seasonality with the ACF plot.
# We first find out the frequency of our time series data.
# The frequency is often the lag in our dataset that represents 1 seasonal cycle

frequency(data_log_diff1) # 12

acf(data_log_diff1, main="ACF of Log Difference 1 AirPassengers")

# From the ACF plot, we can observe their are repeating and decaying seasonal cycle.
# From plots we also observe peaks at each season(year) start, so our lag diff is 12
# To remove the repeated cycles, we difference our data on the seasonal lag, 12 in this case.

data_sdiff_log = diff(data_log_diff1, lag=12)

plot(data_sdiff_log)

# By obtaining this new dataset and observing the plot, 
# we might conclude it is stationary.
# We move towards statistical tests to get evidence of data being stationary

# Augumented Dickey Fuller Test(ADF)
# The ADF test has the following hypothesis:
# H0: Series has unit-root (non-stationary)
# H1: Series is stationary

# Interpret: ADF p-value < 0.05, Reject unit root, evidence of stationary
#           ADF p-value > 0.05, Fail to reject, unit root present(non-stationary)

adf.test(data_sdiff_log)

# data has p-value < 0.01, which is also less than critical(0.05)
# We reject the H0, there is evidence of stationary data now.

# Another test to use is the KPSS test (Kwiatkowski-Phillips-Schmidt-Shin)
# This tests if a time series is stationary around a mean. It is the opposite of ADF in hypothesis.
# Use alongside ADF to cross-examine and catch hidden trends/biases.
#
# HYPOTHESES:
#   Null Hypothesis (H0):      The data is stationary (No unit root / stable).
#   Alternative Hypothesis (H1): The data IS NOT stationary (Has a unit root).
#
# DECISION RULE:
#   p-value < 0.05  --> Reject H0 --> Data is NON-STATIONARY (Needs differencing)
#   p-value >= 0.05 --> Fail to reject H0 --> Data IS STATIONARY (Ready for model)


# Run the test (By default, null = type="mu" for stationary around a mean)
kpss_result = kpss.test(data_sdiff_log)

kpss_result

# our kpss_result$p.value >= 0.05 (0.1), so we fail to reject H0 
# There is insufficient evidence of data being non-stationary. 

# Both ADF and KPSS test point to data being stationary

#==================
# Since we have applied two differences to this dataset, we are now working with a
# SARIMA model(Seasonal Autoregressive Integrated Moving Average)
# The order for which is ARIMA(p, d, q) X (P, D, Q)s,
# Where the later set denotes the seasonal parameters, with s being seasonal period(12 in this case)

#  Since the upwards trend was removed after differencing model 1 times
# We have d and D(seasonal differencing order, used to remove annual cylce) parameters = 1, with s = 12

# We draw the ACF(for MA) and PACF(for AR) plots
acf(data_sdiff_log, main="ACF for Seasonal Difference Log AirPassengers")
pacf(data_sdiff_log, main="PACF for Seasonal Difference Log AirPassengers")

# We can manually use the ACF and PACF plots,
# or alternatively use the auto.arima() function.
# This function can by itself handle the trend and seasonal difference fixing,
# However, it cannot fix the changing variance in data so we pass in the log transformed data.

best_arima_model = auto.arima(log(data), stepwise = FALSE, approximation = FALSE)

summary(best_arima_model)

# Now we check the residuals to check how correct the model is

arima_model_residuals = residuals(best_arima_model)

# We plot residuals, they should appear as completely random values
plot(arima_model_residuals, main="Residuals Time Plot")

checkresiduals(best_arima_model)

# The Ljung box test p-value is > 0.05 (0.233), hence we  fail to reject the null hypothesis.
# The residuals are independently distributed white noise.

# We can now use the model for future predictions
# Generate a 24-month (2 years) future forecast
# Lambda = 0 tells R to automatically handle the exp() un-logging of the data and bias correction.
future_prediction = forecast(best_arima_model, h = 24, lambda = 0)

# Print the predicted table (Point Forecast, Lo 80, Hi 80, Lo 95, Hi 95)
print(future_prediction)

# We now plot the final predicted values on top of the normal AirPassenger data
# We plot as an overlay graph
plot(AirPassengers, 
     xlim = c(1949, 1963),  # Extend the X-axis out to 1963 to make room for the forecast
     ylim = c(100, 700),    # Set the Y-axis range to fit the future growth peaks
     main = "2 Year SARIMA model prediction AirPassengers",
     xlab = "Year", 
     ylab = "Raw Passenger Count", 
     lwd = 2)

# Layer the future predictions directly on top of the active plot window
lines(future_prediction$mean, col = "blue", lwd = 2, lty = 1)

# Add the upper and lower 95% confidence bands as dashed boundary lines
lines(future_prediction$upper[,2], col = "darkgray", lty = 2)
lines(future_prediction$lower[,2], col = "darkgray", lty = 2)

# Add a legend
legend("topleft", 
       legend = c("Original Historical Data", "SARIMA Future Mean", "95% Confidence Band"),
       col = c("black", "blue", "darkgray"), 
       lty = c(1, 1, 2), 
       lwd = c(2, 2, 1))