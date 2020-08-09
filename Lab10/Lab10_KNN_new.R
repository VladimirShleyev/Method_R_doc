renv::init() # инициализация виртуального окружения
renv::install("class", "caret", "lattice", "e1071", "mailR") # установка библиотеки из CRAN
renv::snapshot() # делаем снимок версий библиотек в нашем виртуальном окружении
# фиксируем этот список в .lock-файле для возможности восстановления
# renv::restore() # команда отктиться к предыдушему удачному обновления библиотек

# ------------------- 
# Лабораторная работа №10:
# Классификация методом К-ближайших соседей.

library(class)
library(caret)
library(lattice)
library(e1071)
library(mailR)

# 1.устанавливаем рабочую директорию и парсим файлы данных
setwd("path/to/files")

left_up <- read.csv("left_up.csv")
right_up <- read.csv("right_up.csv")
left_bottom <- read.csv("left_bottom.csv")
right_bottom <- read.csv("right_bottom.csv")


# 2. объединяем таблицы - по горизонтали и вертикали
left_plus_right1 <- cbind(left_up, right_up)
left_plus_right2 <- cbind(left_bottom, right_bottom)
credit_card_data <- rbind(left_plus_right1, left_plus_right2)

rm(left_up, right_up, left_bottom, right_bottom, left_plus_right1, left_plus_right2)


# 3. изучаем структуру данных
str(credit_card_data)
head(credit_card_data)
tail(credit_card_data)
summary(credit_card_data) # сводная таблица с опистельными статистиками


# 4. пишем функцию для расчета процента мошенничества


fraud <- function(x){
  
  if (missing(x))
    print("Введите название таблицы..")  
  else
    print(paste(c("Мошеннических операций:"),
                round(sum(x[c("Class")] == 1)/sum(x[c("Class")] == 0)*100, digits = 2),
                c("%"), 
                c("из общего числа (или"),
                sum(x[c("Class")] == 1),
                c("штук из"),
                nrow(x),
                c("операций по картам)")
    )
    )      
}


fraud(credit_card_data)


# 5. проверяем на наличие пропущенных значений (NA)

na_check <- function(x){
  
  if (missing(x))
    print("Необходимо ввести название таблицы для проверки..")
  
  else
    if (sum(is.na(x)) > 0) 
      print(paste(c("Обнаружено"), round(sum(is.na(x)), digits = 2), c("пропущенных значений")
      )
      )
  else
    print("Пропущенных данных не обнаружено")
  
}

na_check(credit_card_data)


# метод KNN (к-ближайших соседей)

set.seed(4)

credit_card_data$Class <- factor(credit_card_data$Class) # преобразуем столбец с меткой класса в фактор

class_vector <- credit_card_data[, 31] #столбец в виде фактора с метками класса операции для обучающих данных
credit_card_data <- as.data.frame(scale(credit_card_data[, -31])) # провели масштабирование данных за искючением столбца с меткой класса операции
credit_card_data <- data.frame(credit_card_data, class_vector)

str(credit_card_data) # проверяем, что данные отмасштабированы

index <- sample(1:nrow(credit_card_data), round(0.6*nrow(credit_card_data))) # делим дата-сет на обучающую и тестовую выборки
train <- credit_card_data[index, ]
test <- credit_card_data[-index, ]

knn1 <- knn(train, test, train$class_vector, k = 5)
report_knn_table <- table(knn1, test$class_vector)

print("Ошибка классификации и точность прогноза")
1 - sum(diag(report_knn_table))/sum(report_knn_table)
sum(diag(report_knn_table))/sum(report_knn_table)

confusionMatrix(knn1, test$class_vector, positive = "1")


which(knn1 == 1) # смотрим - какие операции определены моделью как мошеннические
fraud <- as.data.frame(c(which(knn1 == 1)))
fraud_data_ps <- write.table(fraud, file = "fraud.txt", fileEncoding = "UTF-8")

# ------------------Теперь можно отправить результаты анализа себе на почту
# для этого укажите адреса почты от кого и кому, в консоли - IDE спросит ваш пароль от почтового ящика
library(mailR) # only sending function
send.mail(from = "name@yandex.ru",
          to = c("name@yandex.ru"),
          replyTo = c("Reply to someone else <name@yandex.ru>"),
          subject = "Test R integration",
          body = "all is working!",
          smtp = list(host.name = "smtp.yandex.ru", port = 465, user.name = "name@yandex.ru", passwd = rstudioapi::askForPassword(), ssl = TRUE),
          authenticate = TRUE,
          send = TRUE, 
          attach.files = c("./fraud.txt")) # file must be in working dir

