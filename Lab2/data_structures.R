# вектора
x <- c("A", "B", "C", "D", "E")
x2 <- 1:5
x3 <- 6:10

z <- c(0, 0 , 3:10)
z[z>0]
print(z[z>0])


#матрицы
my.matrix <- matrix(1:10, nrow = 2, byrow = T)
my.matrix[2, 5]


#дата-фреймы
df <- data.frame(name = x, last_name= z[1:5], salary= z[6:10])
df2 <- data.frame(x, x2, x3)
df3 <- data.frame(
  rbind(x, x2, x3)
  )

df
df[5, 3]
df$last_name[5]

#факторы
x <- c("Man", "Man", "Man", "Lady", "Lady", "Baby")
xf <- factor(x, levels = c("Man", "Lady", "Baby"),
             labels = c("Мужчины", "Женщины", "Дети"))


sum(
  str_count(xf, pattern = "Женщины")
)

#многомерные массивы
my.array <- array(1:24, dim=c(3,4,2)) # nтаблица размером 3х4 повторится 2мя слоями
my.array

#списки
my.list <- list(first = c(1:3), second = c("A", "B", "C"))
my.list
my.list$first[2]
my.list[[2]][2]




