nreps <- 100000
xymat <- matrix(rnorm(2*nreps), ncol = 2)
maxs <- pmax(xymat[,], xymat[,2])
print(mean(maxs))