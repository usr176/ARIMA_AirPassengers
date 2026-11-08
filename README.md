<div align="center">

<h1>SARIMA Time Series Forecasting using R</h1>

<p>
A time series forecasting project implementing a Seasonal ARIMA model using R.
</p>

<br>

<img src="https://img.shields.io/badge/R-276DC3?style=for-the-badge&logo=r&logoColor=white">
<img src="https://img.shields.io/badge/Time%20Series-Forecasting-blue?style=for-the-badge">
<img src="https://img.shields.io/badge/Model-SARIMA-orange?style=for-the-badge">
<img src="https://img.shields.io/badge/Report-R%20Markdown-blueviolet?style=for-the-badge">

</div>

## Overview

This project explores the development of a SARIMA forecasting model using the AirPassengers dataset.
The analysis follows the Box-Jenkins methodology:

- Time series exploration
- Variance stabilization using logarithmic transformation
- Differencing to achieve stationary series
- ADF and KPSS stationarity tests
- ACF/PACF analysis
- SARIMA model selection
- Residual diagnostics
- Future forecasting

## Final Model

After applying transformations, differencing, stationarity testing, and model selection, the final SARIMA model was:

$$
\text{SARIMA}(0,1,1)\times(0,1,1)_{12}
$$

## Forecast Results

The fitted SARIMA model was used to generate a 24-month forecast with 95% confidence intervals.

![SARIMA Forecast](images/SARIMA_forecast.png)

## Tools

- R
- forecast package
- tseries package
- R Markdown

## Files

- `SARIMA_model.R` Complete R script
- `SARIMA_Practice_AirPassengers.Rmd`  Reproducible analysis document
- `SARIMA_Practice_AirPassengers.html`  Rendered report
