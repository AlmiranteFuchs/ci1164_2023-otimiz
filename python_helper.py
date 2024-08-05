import re
import sys

read = (" ".join(sys.stdin))

n = sys.argv[1]
# print(n)
# what = re.findall(r'\d+', read)

# print(n + "," + what[1] + "." + what[2] + "," + what[4] + "." + what[5])


# replace all "|    L2 miss ratio    |" with empty string
read = re.sub(r'\|    L2 miss ratio    \|', '', read)
# replace all "|    L3 bandwidth [MBytes/s]    |" with empty string
read = re.sub(r'\|    L3 bandwidth \[MBytes/s\]    \|', '', read)

# trim whitespace from beginning and end of string and newlines
read = read.strip()
read = read.replace("\n", "")
# split string into arrays on "|"
read = read.split("|")
# remove empty strings from array
read = list(filter(None, read))

print(n +","+ read[0].strip()+","+ read[1].strip())