#renv::init() # инициализация виртуального окружения
renv::install("RCurl", "jsonlite", "purrr", "stringr", "rvest", "dplyr") # установка библиотеки из CRAN
#renv::snapshot() # делаем снимок версий библиотек в нашем виртуальном окружении
# фиксируем этот список в .lock-файле для возможности восстановления
# renv::restore() # команда отктиться к предыдушему удачному обновления библиотек

# ------------------- 
# Лабораторная работа №2:
# Парсинг данных в Интернет

library(RCurl)
library(jsonlite)
library(purrr)
library(stringr)
library(rvest)
library(dplyr)

data <- fromJSON("https://api.hh.ru/vacancies?text=\"machine+learning") 
View (data)

# Здесь pageNum - номер страницы. На странице отображается 20 вакансий.

# Scrap vacancies
vacanciesdf <- data.frame(
  Name = character(),  # Название компании
  Currency = character(), # Валюта
  From = character(), # Минимальная оплата
  Area = character(), # Город
  Requerement = character(), stringsAsFactors = T) # Требуемые навыки

for (pageNum in 0:20) { # Всего страниц
  data <- fromJSON ("https://api.hh.ru/vacancies?text=\"machine+learning")
  
  vacanciesdf <- rbind(vacanciesdf, data.frame(
    data$items$area$name, # Город
    data$items$salary$currency, # Валюта
    data$items$salary$from, # Минимальная оплата
    data$items$employer$name, # Название компании
    data$items$snippet$requirement)) # Требуемые навыки
  print(paste0("Upload pages:", pageNum + 1))
  Sys.sleep(3)
}


# Сделаем приличные названия столбцов
names(vacanciesdf) <- c("Area", "Currency", "Salary", "Name", "Skills") 

# Вместо зарплаты NA будет нулевая
vacanciesdf[is.na(vacanciesdf$Salary),]$Salary <- 0 

# Переведем зарплаты в рубли
vacanciesdf[!is.na(vacanciesdf$Currency) & vacanciesdf$Currency == 'USD',]$Salary <- vacanciesdf[!is.na(vacanciesdf$Currency) & vacanciesdf$Currency == 'USD',]$Salary * 74
vacanciesdf[!is.na(vacanciesdf$Currency) & vacanciesdf$Currency == 'UAH',]$Salary <- vacanciesdf[!is.na(vacanciesdf$Currency) & vacanciesdf$Currency == 'UAH',]$Salary * 2.67
vacanciesdf <- vacanciesdf[, -2] # Currency нам больше не нужна
vacanciesdf$Area <- as.character(vacanciesdf$Area)


vacanciesdf %>% group_by(Area) %>% filter(Salary != 0) %>%
  summarise(Count = n(), Median = median(Salary), Mean = mean(Salary)) %>% 
  arrange(desc(Count))

