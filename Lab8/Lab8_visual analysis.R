renv::init() # инициализация виртуального окружения
renv::install("ggplot2", "maps") # установка библиотеки из CRAN
renv::snapshot() # делаем снимок версий библиотек в нашем виртуальном окружении
# фиксируем этот список в .lock-файле для возможности восстановления
# renv::restore() # команда отктиться к предыдушему удачному обновления библиотек

# ------------------- 
# Лабораторная работа №8:
# Разведочный анализ.

library(ggplot2)
library(tidyverse)

# Начнем с классического набора данных - mpg - расход топлива в зависимости от модели машины

mpg <- ggplot2::mpg
mpg

head(mpg) # первые, displ (объем двигателя), hwy(расход топлива)
tail(mpg) # и последние строки набора данных

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, color = class))

# попробуйте изменить атрибуты alpha, shape

# Панели
# для получения среза графика по одной переменной используется ф-я facet_wrap()
# обратите внимание - передаваемая переменная должна быть дискретной

ggplot(data = mpg)+
  geom_point(mapping = aes(x= displ, y = hwy))+
  facet_wrap(~class, nrow = 2) # здесь за символом тильды (~) стоит имя переменной по которой делается срез

# можно получить срез по комбинации 2-х переменных:
ggplot(data = mpg)+
  geom_point(mapping = aes(x= displ, y = hwy))+
  facet_grid(drv~cyl)

# Геометрические объекты
ggplot(data = mpg)+
  geom_smooth(mapping = aes(x= displ, y = hwy, linetype = drv)) # график зависимости расхода от объема двигателя для машин с разным приводом

# можно отобразить на одной диаграмме графики с разными геометриями, используя слои
ggplot(data = mpg)+
  geom_point(mapping = aes(x = displ, y = hwy, color = class))+
  geom_smooth(mapping = aes(x= displ, y = hwy))

# или так - построим многослойную диаграмму и выведем зависимость для а/м субкомпакт - класса:
ggplot(data = mpg, mapping = aes(x = displ, y = hwy))+
  geom_point(mapping = aes(color = class))+
  geom_smooth(
    data = filter(mpg, class=="subcompact"), se = F
  )


ggplot(data = mpg,
       mapping = aes(x = class, y = hwy))+
  geom_boxplot()+
  coord_flip() # меняем оси местами

# обратимся к другому классическому набору данных - статистике цен на алмазы разной огранки и чистоты
ggplot(data = diamonds)+
  geom_bar(mapping = aes(x = cut)) # число алмазов по переменной огранка


ggplot(data = diamonds)+
  stat_summary(
    mapping = aes(x = cut, y = depth),
    fun.min = min, # здесь мы видим диаграмму размахов по категориям
    fun.max = max,
    fun = median)

# Позиционные настройки
ggplot(data = diamonds)+
  geom_bar(mapping = aes(x = cut, fill = clarity)) # столбцы автоматически преобразовались в стеки
# где каждый цветной прямоугольник представляет комбинацию значений cut и clarity

ggplot(data = diamonds)+
  geom_bar(mapping = aes(x = cut, fill = clarity),
           position = "fill") # здесь аргумент position создает стековые столбцы одинаковой высоты, что облегчает сравнение пропорций по группам

ggplot(data = diamonds)+
  geom_bar(mapping = aes(x = cut, fill = clarity),
           position = "dodge")

nz <- map_data("nz") # работа с картографией
ggplot(nz, aes(long, lat, group = group))+
  geom_polygon(fill = "white", color = "black")+
  coord_quickmap() # ф-ия дает возможность отобрадать верные пропорции


bar <- ggplot(data = diamonds)+
  geom_bar(
    mapping = aes(x = cut, fill = cut),
    show.legend = F,
    width = 1
  ) +
  theme(aspect.ratio = 1) +
  labs(x = NULL, y = NULL)

bar + coord_flip()
bar + coord_polar()


# Помимо библиотеки ggplot2, существуют реализации для R библиотек Plotly, Bokeh,
# которые позволяют генерировать html и создавать веб-дашборды
