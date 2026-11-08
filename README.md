# SARIMA Forecasting Model using Box-Jenkins Methodology

A time series forecasting project implementing a Seasonal ARIMA model using R.

## Overview

This project explores the development of a SARIMA forecasting model using the AirPassengers dataset.

The analysis follows the Box-Jenkins methodology:

- Time series exploration
- Variance stabilization using logarithmic transformation
- Differencing to achieve stationarity
- ADF and KPSS stationarity tests
- ACF/PACF analysis
- SARIMA model selection
- Residual diagnostics
- Future forecasting

## Final Model

SARIMA(0,1,1)(0,1,1)[12]

## Forecast Results

The fitted SARIMA model was used to generate a 24-month forecast with 95% confidence intervals.

![SARIMA Forecast](images/SARIMA_forecast.png)

## Tools

- R
- forecast package
- tseries package
- R Markdown

## Files

- `SARIMA_model.R` → Complete R script
- `SARIMA_Practice_AirPassengers.Rmd` → Reproducible analysis document
- `SARIMA_Practice_AirPassengers.html` → Rendered report
