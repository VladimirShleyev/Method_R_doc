renv::init() # инициализация виртуального окружения
renv::install("AppliedPredictiveModeling") # установка библиотеки из CRAN
renv::snapshot() # делаем снимок версий библиотек в нашем виртуальном окружении
# фиксируем этот список в .lock-файле для возможности восстановления
# renv::restore() # команда отктиться к предыдушему удачному обновления библиотек

# ------------------- 
# Лабораторная работа №11:
# Разделение данных на обучающую и тестовую выборки.

library(AppliedPredictiveModeling)

# Простое случайное разделение данных
data(twoClassData)

str(predictors)

str(classes)
View(classes)

# инициализация генератора случайных чисел для воспроизведения результатов
set.seed(1)
# по-умолчанию числа возвращаются в виде списка. С параметром list = FALSE генерируется
# матрица номеров строк
# эти данные выделяются в тренировочный набор

trainingRows <- caret::createDataPartition(classes,
                                    p = .80,
                                    list = F) # матрица
head(trainingRows)

# выделить подмножество данных в объекты для тренировки
trainPredictors <- predictors[trainingRows, ]
trainClasses <- classes[trainingRows]

# сделать то же самое для тестового набора с отрицательными числами
testPredictors <- predictors[-trainingRows, ]
testClasses <- classes[-trainingRows]

str(trainPredictors)
str(testPredictors)

# ------------------- 
# Повторная выборка
# caret  способен генерировать разделение тренировочного/тестового набора с дополнительным аргументом
# times (для создания множественных вариантов разделения)

set.seed(1)
# для примера сгенерируем инф-ию, нужную для 3х версий тренировочного набора, полученных при повторной выборке

repeatedSplits <- caret::createDataPartition(trainClasses, p = .80,
                                      times = 3)
str(repeatedSplits)

# кроме того, в пакете caret есть ф-ия createResamples() для выборки с возвратом
# createFolds() для К-кратной перекрестной проверки и createMultuFolds() для повторной перекрестной проверки

# Чтобы создать индикаторы для десятикратной перекрестной проверки выполните:
set.seed(1)
cvSplits <- caret::createFolds(trainClasses, k=10,
                        returnTrain = TRUE)

str(cvSplits)

# получение первого набора номеров строк из списка:
fold1 <- cvSplits[[1]]

# чтобы получить первые 90% данных (первая свертка) нужно:
cvPredictors1 <- trainPredictors[fold1,]
cvClasses1 <- trainClasses[fold1]
nrow(trainPredictors)
nrow(cvPredictors1)

