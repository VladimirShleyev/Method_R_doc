renv::init() # инициализация виртуального окружения
renv::install("devtools") # установка библиотеки из CRAN
renv::snapshot() # делаем снимок версий библиотек в нашем виртуальном окружении
# фиксируем этот список в .lock-файле для возможности восстановления
# renv::restore() # команда отктиться к предыдушему удачному обновления библиотек

# ------------------- 
# Лабораторная работа №14:
# Деревья решений.


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

# 6. модель классификации - деревья решений



set.seed(1)
tree.credit_card_data = tree(credit_card_data$Class ~ .  - credit_card_data$Class, credit_card_data)
summary(tree.credit_card_data)

plot(tree.credit_card_data)
text(tree.credit_card_data, pretty = 0)

tree.credit_card_data


set.seed(2)
train = sample(1:nrow(credit_card_data), 150000)
credit_card_data.test = credit_card_data[ -train, ]


length(credit_card_data[train, ])
length(credit_card_data[-train, ])


Class.test = credit_card_data$Class[-train]
tree.credit_card_data = tree(credit_card_data$Class ~ . - credit_card_data$Class,  credit_card_data, subset = train)
tree.pred = predict(tree.credit_card_data, credit_card_data.test)
table(tree.pred, Class.test)

length(Class.test)
length(tree.credit_card_data)
length(tree.pred)

set.seed(3)
cv.credit_card_data = cv.tree(tree.credit_card_data, FUN = prune.tree)
names(cv.credit_card_data)
cv.credit_card_data

par(mfrow = c(1, 2))
plot(cv.credit_card_data$size, cv.credit_card_data$dev, type = "b")
plot(cv.credit_card_data$k, cv.credit_card_data$dev, type = "b")


prune.credit_card_data = prune.tree(tree.credit_card_data, best = 8)
plot(prune.credit_card_data) 
text(prune.credit_card_data, pretty = 0)

tree.pred = predict(prune.credit_card_data, credit_card_data.test)
report_tree_table <- table(tree.pred, Class.test)

report_tree_table

print("Ошибка классификации и точность прогноза")

1 - sum(diag(report_tree_table))/sum(report_tree_table)
sum(diag(report_tree_table))/sum(report_tree_table)


