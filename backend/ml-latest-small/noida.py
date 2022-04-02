s1='co1untry m0y i2s this3'
final=dict()

s1=s1.split(' ')

for i in s1:
	for j in i:
		if j.isdigit():
			final[j]=i

sorted_keys = sorted(final.keys())
sort_list = {key:final[key] for key in sorted_keys}
print(final)
print(sort_list)


