renv::init() # инициализация виртуального окружения
renv::install("devtools") # установка библиотеки из CRAN
renv::snapshot() # делаем снимок версий библиотек в нашем виртуальном окружении
# фиксируем этот список в .lock-файле для возможности восстановления
# renv::restore() # команда отктиться к предыдушему удачному обновления библиотек

# ------------------- 
# Лабораторная работа №13:
# Однослойные нейронные сети. Nnet, Neuralnet.


#  –аспознавание сорта оливкового масла

rm(list = ls())


olive<-read.table("olive.txt", header=T, sep=",")
#  удал€ем переменные area и name
olive<-olive[,-c(1, 3)]

#  ƒл€ стандартизации значений в каждом столбце 
#  находим минимальное значение и размах
a <- sapply(olive[ , -1], min)
b <- sapply(olive[ , -1], max) - a

#  —обственно стандартизаци€ входных переменных
olive.x <- scale(olive[, -1], center=a, scale=b)

#  ѕреобразование выходной переменной в три столбца, в три индикаторные переменные.
#  ѕо€сним преобразование на примере
#  ¬ектор (3, 1, 2) преобразуетс€ в матрицу
#  0	0	1
#  1	0	0
#  0	1	0
y1 <- rep(0, nrow(olive))
y1[olive[ , 1]==1] <-1

y2 <- rep(0, nrow(olive))
y2[olive[ , 1]==2] <-1

y3 <- rep(0, nrow(olive))
y3[olive[ , 1]==3] <-1

#   ƒругой способ получить тот же результат
#    ѕроцедура  class.ind из пакета nnet
#    wine.class <- class.ind(factor(wine[, 14]))

z.1 <- as.data.frame(cbind(olive.x, y1, y2, y3))

# раздел€ем на тестовую и обучающую выборки
set.seed(1234567)
index<-sample(1:nrow(z.1),round(nrow(z.1)*2/3),replace=F)
z.train<-z.1[index,]
z.test<-z.1[-index,]

#  n <- names(z.1)
#  n


#  ѕодключаем библиотеку neuralnet.
library(neuralnet)


# хотим хранить лучшую сеть и значит датчик зерна
# зерно датчика случайных чисел
# дл€ лушей сети надо охранить значение критериz качества, еcли процент ошибок, то не только лучшую сеть, но и процент ошибок у этой лучшей сети
# вначале проент ошибок на обучающем множестве
# почти наверн€ка это не здорово, нас волнует на тестовом множестве
# у нас тут сумма трЄх у

#задаю число сетей
num.nets<-10

# переменна€ котора€ хранит лучшую сеть
#nnet.nest

# зерно датчика случ чисел, которое соответсвует наилучшей сети
# seed.best

# процент ошибок у наилучшей ЌC 
error.best<-1

hidden.n <- 3


# начальный датчик cлуч чисел
seed.start<-12345

error.vector      <- rep(-9999,num.nets)
error.vector.test <- rep(-9999,num.nets)

seed.current<-seed.start


for (i in 1:num.nets){ # строю текущую сеть
  seed.current<-seed.current+1
  set.seed(seed.current)
  nn.temp <- neuralnet( y1+y2+y3 ~ palmitic + palmitoleic + stearic + oleic + linoleic + linolenic + 
                          arachidic + eicosenoic,
                        data=z.train ,hidden = hidden.n, linear.output=F)
  # считаем процент ошибок у текущей Ќ— на обучающей выборке
  res.z <- compute(nn.temp, z.train[, 1:8] )  # вычисл€етс€ матрица "веро€тностей" на обучающей выборке
  res.z2<-apply(res.z$net.result, 1, which.max )  # находитс€, какой сорт масла имеет максимальную "веро€тность" 
  error.temp <- sum(res.z2 != olive[index,1] )/nrow(z.train) # дол€ ошибок при распознавании сорта масла
  error.vector[i]<-error.temp
  
  #  если текуща€ сеть лучше предыдущих, сохран€ем ее
  if (error.temp<error.best)  {
    nn.best <- nn.temp
    error.best <- error.temp
    seed.best<-seed.current
  }
  
  # считаем процент ошибок у текущей Ќ— на тестовой выборке
  res.z <- compute(nn.temp, z.test[, 1:8] )  # вычисл€етс€ матрица "веро€тностей" на тестовой выборке
  res.z2<-apply(res.z$net.result, 1, which.max )  # находитс€, какой сорт масла имеет максимальную "веро€тность" 
  error.vector.test[i] <- sum(res.z2 != olive[-index,1] )/nrow(z.test) # дол€ ошибок при распознавании сорта масла
}



plot(error.vector, error.vector.test)

error.vector.test




error.vector
error.best
seed.best
#> error.vector
#[1] 0 0 0 0 0 0 0 0 0 0
#> error.best
#[1] 0
#> seed.best 
#[1] 12346 - лучше оказалась втора€

################################################################################################################################
#смотрим, когда одна Ќ— и 1 хидден
# for (i in 1:num.nets)
# { # строю текущую сеть
num.nets<-10
seed.start<-12345
error.best<-1
error.vector<-rep(-9999,num.nets)
seed.current<-seed.start

i=1
seed.current<-seed.current+1
set.seed(seed.current)
nn.temp <- neuralnet( y1+y2+y3 ~ palmitic + palmitoleic + stearic + oleic + linoleic + linolenic + 
                        arachidic + eicosenoic,
                      data=z.train ,hidden = 1, linear.output=F)
# считаем процент ошибок дл€ текущей Ќ—
res.z <- compute(nn.temp, z.train[, 1:8] )  # это матрица веро€тностей предсказани€ по Ќ— те знач, которые получаютс€ после Ќ—
res.z2<-apply(res.z$net.result,1,which.max )
error.temp <- sum(res.z2 != olive[index,1] )/length(index) # без lenght(index) было бы просто это количесвто ошибок, а нам нужен процент ошибок по всем видам, кол-во раз когда не попало
error.vector[i]<-error.temp
if (error.temp<error.best)
{
  nn.best <- nn.temp
  error.best <- error.temp
  seed.best<-seed.current
}
error.best
seed.best
#> error.best
#[1] 0.4540682415
#> seed.best
#[1] 12346
################################################################################################################################################

# цикл, но хидден понизили
# мен€ем hiddn
rm(list = ls())
olive<-read.table("olive.txt", header=T, sep=",")
#  удалили area и name
olive<-olive[,-3]
olive<-olive[,-1]

#  ƒл€ стандартизации переменных дл€ каждого столбца 
#  находим минимальное значение и размах
a <- sapply(olive[ , -1], min)
b <- sapply(olive[ , -1], max) - a

#  —обственно стандартизаци€ входных переменных
olive.x <- scale(olive[, 2:9], center=a, scale=b)

#  ѕреобразование выходной переменной в три столбца, в три индикаторные переменные.
y1 <- rep(0, nrow(olive))
y1[olive[ , 1]==1] <-1

y2 <- rep(0, nrow(olive))
y2[olive[ , 1]==2] <-1

y3 <- rep(0, nrow(olive))
y3[olive[ , 1]==3] <-1

z.1 <- as.data.frame(cbind(olive.x, y1, y2, y3))

# создание тестовой и обучающей выборки
set.seed(1234567)
index<-sample(1:nrow(z.1),round(nrow(z.1)*2/3),replace=F)
z.train<-z.1[index,]
z.test<-z.1[-index,]


#  ѕодключаем библиотеку neuralnet.
library(neuralnet)

n <- names(z.1)
n


# хотим хранить лучшую сеть и значит датчик зерна
# зерно датчика случайных чисел
# дл€ лушей сети надо охранить значение критериz качества, еcли процент ошибок, то не только лучшую сеть, но и процент ошибок у этой лучшей сети
# вначале проент ошибок на обучающем множестве
# почти наверн€ка это не здорово, нас волнует на тестовом множестве
# у нас тут сумма трЄх у
#задаю число сетей
num.nets<-10

# начальный датчик cлуч чисел
seed.start<-12345

# переменна€ котора€ хранит лучшую сеть
#nnet.nest

# нам нужно лучшее зерно датчика случ чисел, которое соответсвует наилучшей сети
# seed.best

# мне нужна одна переменна€ , хран€ща€ процент ошибок по наилучшей ЌC (нулева€ Ќ— ошибаетс€ всегда, так как единица)
error.best<-1

# но лучше накопить статистику по всем ошибкам по всем Ќ—
error.vector<-rep(-9999,num.nets)
seed.current<-seed.start


# когда строим одну сеть, то будут ошибки при одном нейроне
for (i in 1:num.nets)
{ # строю текущую сеть
  seed.current<-seed.current+1
  set.seed(seed.current)
  nn.temp <- neuralnet( y1+y2+y3 ~ palmitic + palmitoleic + stearic + oleic + linoleic + linolenic + 
                          arachidic + eicosenoic,
                        data=z.train ,hidden = 1, linear.output=F)
  # считаем процент ошибок дл€ текущей Ќ—
  res.z <- compute(nn.temp, z.train[, 1:8] )  # это матрица веро€тностей предсказани€ по Ќ— те знач, которые получаютс€ после Ќ—
  res.z2<-apply(res.z$net.result,1,which.max )
  error.temp <- sum(res.z2 != olive[index,1] )/length(index) # без lenght(index) было бы просто это количесвто ошибок, а нам нужен процент ошибок по всем видам, кол-во раз когда не попало
  error.vector[i]<-error.temp
  if (error.temp<error.best)
  {
    nn.best <- nn.temp
    error.best <- error.temp
    seed.best<-seed.current
  }
}

error.vector
#  [1] 0.454068241470 0.000000000000 0.005249343832 0.000000000000 0.000000000000
#  [6] 0.000000000000 0.000000000000 0.000000000000 0.000000000000 0.000000000000
error.best
# [1] 0
seed.best
# [1] 12347  - 3 Ќ—
# таблица сопр€женнсоти дл€ лучшей Ќ—
res.3 <- compute(nn.best, z.train[, 1:8] )
res.z3<-apply(res.3$net.result,1,which.max )
table(res.z3, olive[index,1])
#  res.z3   1   2   3
#  1 208   0   0
#  2   0  68   0
#  3   0   0 105
res.4 <- compute(nn.best, z.test[, 1:8] )
res.z4<-apply(res.4$net.result,1,which.max )
table(res.z4, olive[-index,1])
#  res.z4   1   2   3
#  1 114   0   0
#  2   1  26   0
#  3   0   4  46
sum(diag(table(olive[-index,1], res.z4)))/length(olive[-index,1])*100
#  [1] 97.38219895
100-(sum(diag(table(olive[-index,1], res.z4)))/length(olive[-index,1])*100)
#  [1] 2.617801047