#renv::init() # инициализация виртуального окружения
#renv::install("MASS") # установка библиотеки из CRAN
#renv::snapshot() # делаем снимок версий библиотек в нашем виртуальном окружении
# фиксируем этот список в .lock-файле для возможности восстановления
# renv::restore() # команда отктиться к предыдушему удачному обновления библиотек

# ------------------- 
# Лабораторная работа №9:
# Задачи на регрессию. Дисперсионный анализ.

# Простая линейная регрессия
# Библиотека MASS содержит набор данных Boston, который включает переменную medv - медианная стоимость дома
# для 506 окрестностей Бостона. Наша задача - предсказать medv на основе 13 предикторов, таких как:
# rm (среднее число комнат в доме), age(средний возраст дома), lstat(процент домохозяйств с низким эк статусом)

library(MASS)
library(tidyverse)
fix(Boston)
names(Boston)

?Boston

lm.fit = lm(medv~lstat, data = Boston)
attach(Boston)

lm.fit # основная информация по моедели
summary(lm.fit) # p-значения, стандартные ошибки коэффициентов, а также коэф-т детерминации R^2, F-критерий для модели

lm.fit$coefficients
lm.fit$residuals
names(lm.fit)

coef(lm.fit)

#для вычисления доверительных интервалов оценок коэф-ов:
confint(lm.fit)

# ф-иб predict() можно использовать для расчета доверительных интервалов и интервалов предсказаний при прогнозировании medv по переменной lstat
predict(lm.fit, data.frame(lstat=(c(5,10,15))),
        interval = "confidence")

predict(lm.fit, data.frame(lstat=(c(5,10,15))),
        interval = "prediction")
# 95% -й доверительный интервал, связанный со значением lstat = 10, составляет (24.47, 25.63)
# а 95%-й интервал предсказания (12.82, 37.27) - оба этих интервала центрированны относительно одинковой точки - (предсказанное значение 25.63 при lstat = 10)
# однако интервал предсказания более широкий

# отобразим результаты на простой диаграмме с линейной формулой
plot(lstat, medv)
abline(lm.fit)


# применим наши навыки разведочного анализа и подключим ggplot2
ggplot(data = lm.fit)+
  geom_point(alpha = 1/3, mapping = aes(x = lm.fit$fitted.values, y=lm.fit$residuals, fill = lm.fit$effects))


# на графике уже полиномиальное сглаживание
# точки окрашены согласно возрасту домов
ggplot(data = Boston) +
  geom_point(mapping = aes(x = lstat, y = medv, color = age))+
  geom_smooth(mapping = aes(x= lstat, y = medv))

ggplot(data = Boston) +
  geom_point(mapping = aes(x = lstat, y = medv, color = black)) # в дорогих домах Бостона, похоже, чернокожие люди не живут..


# Множественная линейная регрессия
# синтаксис lm(y~x1 + x2 + x3) для трех предикторов

lm.fit <- lm(medv~lstat+age, data = Boston)
summary(lm.fit)

lm.fit <- lm(medv~ ., data = Boston)

#сравните диаграмму остатков-предсказанных значений для одинарной и множественной линейной регрессии
# видите ли вы на графике, что ядро предсказанных значений и разброс остатков у множественной регрессии выше? как вы считаете - лучше ли множественная регрессия прогнозирует цену?
ggplot(data = lm.fit)+
  geom_point(alpha = 1/3, mapping = aes(x = lm.fit$fitted.values, y=lm.fit$residuals, fill = lm.fit$effects))


# включение эффектов взаимодействия
# синтаксис - lstat:black - добавляем взаимодействие между lstat и black
# синтаксис lstat*age одновременно включает в качестве предикторов lstat, age и взаимодействие lstat x age (это сокращенная форма для lstat + age + lstat:age)
lm.fit <- lm(medv~lstat*age, data = Boston)

summary(lm.fit)

ggplot(data = lm.fit)+
  geom_point(alpha = 1/3, mapping = aes(x = lm.fit$fitted.values, y=lm.fit$residuals, fill = lm.fit$effects))

# Нелинейные преобразования предикторов
# включение полиномов (здесь - третьей степени) в формулу регрессии производится по такому синтаксису
lm.fit5 <- lm(medv~poly(black, 3), data = Boston) # посмотрите на сегрегацию между белыми и чернокожими и на то, как четко она позволяет прогнозировать цену дома
summary(lm.fit5)

ggplot(data = lm.fit5)+
  geom_point(alpha = 1/3, mapping = aes(x = lm.fit5$fitted.values, y=lm.fit5$residuals, fill = lm.fit5$effects))

# попробуем логарифмирование предикторов (здесь - численность чернокожих) - видим, что этот подход еще более четко обозначил тенденцию и поддержал другие методы
lm.fit.log <- lm(medv~log(black*lstat), data = Boston) # посмотрите на сегрегацию между белыми и чернокожими и на то, как четко она позволяет прогнозировать цену дома
summary(lm.fit.log)

ggplot(data = lm.fit.log)+
  geom_point(alpha = 1/3, mapping = aes(x = lm.fit.log$fitted.values, y=lm.fit.log$residuals, fill = lm.fit.log$effects))

