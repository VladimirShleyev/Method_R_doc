sum <- 0
nreps <- 100000
for(i in 1:nreps){
  xy <- rnorm(2) # генерируем 2 N(0,1)
  sum <- sum + max(xy)
}
print(sum/nreps)