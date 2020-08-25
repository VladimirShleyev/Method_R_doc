x <- matrix(data = commandArgs(trailingOnly = T), nrow = 1)

x <- as.integer(x)
x <- x * 2

par(mfrow = c(1, 2))
boxplot(x, xlab = 'Some random numbers')
plot(x, xlab = 'Some random numbers', ylab = 'value', pch = 3)

print(x)