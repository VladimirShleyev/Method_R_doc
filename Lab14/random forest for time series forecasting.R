# load the packages
suppressPackageStartupMessages(require(tidyverse))
suppressPackageStartupMessages(require(tsibble))
suppressPackageStartupMessages(require(randomForest))
suppressPackageStartupMessages(require(forecast))

# specify the csv file (your path here)
file <- ".../tax.csv"

# read in the csv file
tax_tbl <- readr::read_delim(
  file = file,
  delim = ";",
  col_names = c("Year", "Type", month.abb),
  skip = 1,
  col_types = "iciiiiiiiiiiii",
  na = c("...")
) %>% 
  select(-Type) %>% 
  gather(Date, Value, -Year) %>% 
  unite("Date", c(Date, Year), sep = " ") %>% 
  mutate(
    Date = Date %>% 
      lubridate::parse_date_time("my") %>% 
      yearmonth()
  ) %>% 
  drop_na() %>% 
  as_tsibble(index = "Date") %>% 
  filter(Date <= "2018-12-01")

# convert to ts format
tax_ts <- as.ts(tax_tbl)

# Before we dive into the analysis, let's quickly check for implicit and explicit missings in the data. 
# The tsibble package has some handy functions to do just that:

# implicit missings
has_gaps(tax_tbl)

# explicit missings
colSums(is.na(tax_tbl[, "Value"]))
# Nope, looks good! So what kind of time series are we dealing with?
  # visualize
  plot_org <- tax_tbl %>% 
  ggplot(aes(Date, Value / 1000)) + # to get the axis on a more manageable scale
  geom_line() +
  theme_minimal() +
  labs(title = "German Wage and Income Taxes 1999 - 2018", x = "Year", y = "Euros")

# When lambda is zero, the Box-Cox transformation amounts to taking logs. 
# We choose this value to make the back-transformation of our forecasts straightforward. 
# But don't hesitate to experiment with different values of lambda or estimate the '
# best' value with the help of the forecast package.

# pretend we're in December 2017 and have to forecast the next twelve months
tax_ts_org <- window(tax_ts, end = c(2017, 12))

# estimate the required order of differencing
n_diffs <- nsdiffs(tax_ts_org)

# log transform and difference the data
tax_ts_trf <- tax_ts_org %>% 
  log() %>% 
  diff(n_diffs)

# check out the difference! (pun)
plot_trf <- tax_ts_trf %>% 
  autoplot() +
  xlab("Year") +
  ylab("Euros") +
  ggtitle("German Wage and Income Taxes 1999 - 2018") +
  theme_minimal()

gridExtra::grid.arrange(plot_org, plot_trf)

# To feed our random forest the transformed data, we need to turn what is essentially a vector into a matrix, i.e.,
# a structure that an ML algorithm can work with. 
# For this, we make use of a concept called time delay embedding.

# Time delay embedding represents a time series in a Euclidean space with the embedding dimension . 
# To do this in R, use the base function embed(). 
# All you have to do is plug in the time series object and set the embedding dimension 
# as one greater than the desired number of lags.

lag_order <- 6 # the desired number of lags (six months)
horizon <- 12 # the forecast horizon (twelve months)

tax_ts_mbd <- embed(tax_ts_trf, lag_order + 1) # embedding magic!

y_train <- tax_ts_mbd[, 1] # the target
X_train <- tax_ts_mbd[, -1] # everything but the target

y_test <- window(tax_ts, start = c(2018, 1), end = c(2018, 12)) # the year 2018
X_test <- tax_ts_mbd[nrow(tax_ts_mbd), c(1:lag_order)] # the test set consisting
# of the six most recent values (we have six lags) of the training set. It's the
# same for all models.

# The random forest forecast

forecasts_rf <- numeric(horizon)

for (i in 1:horizon){
  # set seed
  set.seed(2019)
  
  # fit the model
  fit_rf <- randomForest(X_train, y_train)
  
  # predict using the test set
  forecasts_rf[i] <- predict(fit_rf, X_test)
  
  # here is where we repeatedly reshape the training data to reflect the time distance
  # corresponding to the current forecast horizon.
  y_train <- y_train[-1] 
  
  X_train <- X_train[-nrow(X_train), ] 
}

# Back to the former or how we get forecasts on the original scale

# As we took the log transform earlier, the back-transform is rather straightforward. 
# We roll back the process from the inside out, 
# i.e., we first reverse the differencing and then the log transform. 
# We do this by exponentiating the cumulative sum of our transformed forecasts 
# and multiplying the result with the last observation of our time series.

# calculate the exp term
exp_term <- exp(cumsum(forecasts_rf))

# extract the last observation from the time series (y_t)
last_observation <- as.vector(tail(tax_ts_org, 1))

# calculate the final predictions
backtransformed_forecasts <- last_observation * exp_term

# convert to ts format
y_pred <- ts(
  backtransformed_forecasts,
  start = c(2018, 1),
  frequency = 12
)

# add the forecasts to the original tibble
tax_tbl <- tax_tbl %>% 
  mutate(Forecast = c(rep(NA, length(tax_ts_org)), y_pred))

# visualize the forecasts
plot_fc <- tax_tbl %>% 
  ggplot(aes(x = Date)) +
  geom_line(aes(y = Value / 1000)) +
  geom_line(aes(y = Forecast / 1000), color = "blue") +
  theme_minimal() +
  labs(
    title = "Forecast of the German Wage and Income Tax for the Year 2018",
    x = "Year",
    y = "Euros"
  )

accuracy(y_pred, y_test)

benchmark <- forecast(snaive(tax_ts_org), h = horizon)

tax_ts %>% 
  autoplot() +
  autolayer(benchmark, PI = FALSE)

accuracy(benchmark, y_test)