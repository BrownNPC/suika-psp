import math


nums = [i * 2 for i in range(1, 12)]
nums = nums[::-1]
arr = []
# magic_num = 60.392
magic_num = 51.376
for num in nums:
    radius = num * magic_num
    # radius = radius / 10000
    radius = round(radius,3) / 100
    
    # print(radius)
    arr.append(round(radius,3))

print(arr)