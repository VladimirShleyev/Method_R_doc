# вызываем R из Python
import subprocess
import os

# определяем команды и аргументы
command = 'Rscript'
script_dir = os.path.dirname(__file__)
rel_path = "calling_r_from_py.r"
path2script =  os.path.join(script_dir, rel_path)

args = ['10', '20', '30', '50', '60','70', '80', '90']

# строим команду субпроцесса
cmd = [command, path2script] + args
print(cmd)

# проверка результата приведет к выполнению R-скрипта и сохранению результата
x = subprocess.check_output(cmd, universal_newlines=True)
print('Результат: ', x)


