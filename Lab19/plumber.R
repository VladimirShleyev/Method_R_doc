#renv::install("plumber") # установка библиотеки из CRAN
#renv::snapshot() # делаем снимок версий библиотек в нашем виртуальном окружении
# фиксируем этот список в .lock-файле для возможности восстановления

# ------------------- 
# Лабораторная работа №19:
# Клиент-серверное REST-API приложение на R. Библиотека Plumber.
# -------------------




library(plumber)

#* Echo введенного сообщения
#* @param msg The message to echo
#* @get /echo
function(msg="") {
  list(msg = paste0("The message is: '", msg, "'"))
}

#* Строим гистограмму
#* @png
#* @get /plot
function() {
  rand <- rnorm(100)
  hist(rand)
}

#* Возвращает сумму двух чисел
#* @param a The first number to add
#* @param b The second number to add
#* @post /sum
function(a, b) {
  as.numeric(a) + as.numeric(b)
}

# ------------------
# These comments allow plumber to make your R functions available as API endpoints. 
# You can use either #* as the prefix or #', but we recommend the former since #' will collide with Roxygen.
# 
# Введите эти две строки ниже в консоли, чтобы запустить API-приложение----------------
pr <- plumber::plumb(file.path("./Lab19", "plumber.R"))
pr$run(port=8000)
# ------------------

# Кнопка Stop в Консоли (справа) остановит приложение

# You can visit this URL using a browser or a terminal to run your R function and get the results. 
# For instance http://localhost:8000/plot will show you a histogram, 
# and http://localhost:8000/echo?msg=hello will echo back the ‘hello’ message you provided.
# 
# Here we’re using curl via a Mac/Linux terminal.
# 
# $ curl "http://localhost:8000/echo"
# {"msg":["The message is: ''"]}
# $ curl "http://localhost:8000/echo?msg=hello"
# {"msg":["The message is: 'hello'"]}
# As you might have guessed, the request’s query string parameters 
# are forwarded to the R function as arguments (as character strings).
# 
# $ curl --data "a=4&b=3" "http://localhost:8000/sum"
# [7]
# You can also send your data as JSON:
#   
#   $ curl --data '{"a":4, "b":5}' http://localhost:8000/sum
# [9]

