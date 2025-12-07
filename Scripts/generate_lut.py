import math

# calculate theta: theta(i) = arctan(2^-i) in radians
# convert the angle into degrees: theta(i) = theta(i) * 180/pi
# convert the angle into phase accumulator units (2^N / 360) -> 1 turn = 2^N units
# final equation: theta(i) = arctan(2^-i) * 2^N/2pi

LUT_DEPTH = 32
lut = []

for i in range(LUT_DEPTH):
    theta = math.degrees(math.atan(2**(-i)))
    scale = (2**32) / 360.0
    converted_angle = int(round(theta * scale))
    lut.append(converted_angle)

for val in lut:
    print(f"X\"{val:08x}\",")
