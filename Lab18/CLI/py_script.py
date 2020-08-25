import sys

string = sys.argv[1]
pattern = sys.argv[2]

ans = string.split(pattern)

print('\n'.join(ans))
