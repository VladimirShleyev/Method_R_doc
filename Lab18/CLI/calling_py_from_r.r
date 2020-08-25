# -*- coding: utf-8 -*-
command = 'python'

#обратите внимание - одиночные и двойные кавычки нужны, если в Пути есть пробелы
path2script = "py_script.py"

# строим вектор из аргументов
string = '"3423423----234234----2342342----234234----234i"'
pattern = "----"
args = c(string, pattern)

# добавляем Путь к скрипту как первый аргумент
allArgs = c(path2script, args)

output = system2(command, args = allArgs, stdout=TRUE)

print(paste("Часть строки:", output))
