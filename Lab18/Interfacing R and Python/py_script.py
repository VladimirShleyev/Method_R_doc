import re
import sys


# скрипт находит номер телефона по заданному
# Regex-шаблону

# поисковый паттерн мы примем из R-кода, как управляющую команду
# считаем из STDIN/STDOUT потоков памяти паттерн
# pattern = sys.argv[0]



pattern = r'\.*(телефон).*?([\d-]+)'

# применим паттерн к данным, которые находятся внутри python-кода
data = "Это пример текстовой строки, содержащей номер телефона: 79001234567"

def find_phone(data):
    match = re.search(pattern, data)
    print(match.group(1,2))

find_phone(data)
