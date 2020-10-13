j <- list(
  wheels = 4,
  driverseat = "Слева",
  passangerseats = 3
)

class(j) <- "Car"

print.Car <- function(cr){
  cat("Колес", j$wheels, "\n")
  cat("Вод. сидение", j$driverseat, "\n")
  cat("Пассажирских сидений", j$passangerseats, "\n")
  cat("Название", cr$name, "\n")
  cat("Топливо", cr$fuel)
}


k <- list(
  name = "Lada",
  fuel = "бензин"
)
class(k) <- c("NewCar1", "Car")

l <- list(
  name = "BMW",
  fuel = "дизель"
)
class(l) <- c("NewCar2", "Car")

m <- list(
  name = "Tesla",
  fuel = "Електричество"
)
class(m) <- c("NewCar3", "Car")


chelovek <- function(){
  v1 <- readline("Информацию о какой машине вы хотите узнать (Lada, BMW, Tesla)?: ")
  if(v1 == "Lada") print.Car(k)
  if(v1 == "BMW") print.Car(l)
  if(v1 == "Tesla") print.Car(m)
}
chelovek()
