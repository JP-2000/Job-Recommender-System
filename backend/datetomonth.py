start='2000-07-14'
end = '2000-10-03'
start = start.split('-')
end = end.split('-')

start = list(map(int,start))
end = list(map(int,end))

values=[]
for i,j in zip(start,end):
	val = j-i
	values.append(val)
print(values)
values = values[::-1]
noyear=values[2]
if noyear>1:
	noyear = noyear*12
nomonth=values[1]

print(abs(noyear))
print(abs(nomonth))
print(abs(noyear)+abs(nomonth))
