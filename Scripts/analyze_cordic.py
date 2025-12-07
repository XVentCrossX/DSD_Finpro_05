import math

PHASE_ACC_BITS = 32
FRACTIONAL_BITS = 15
INPUT_FILE = "output.txt"

def parse_line(line):
    # parse the angle, sin, and cosine from the file
    parts = line.strip().split()
    angle = int(float(parts[0].split('=')[1]))
    sin_val = int(parts[1].split("=")[1])
    cos_val = int(parts[2].split("=")[1])
    return angle, sin_val, cos_val

def fixed_to_float(value):
    # convert the 16-bit signed integer to float
    return value / (2 ** 15)

angles_deg = []
sin_fixed = []
cos_fixed = []
sin_true = []
cos_true = []
sin_err = []
cos_err = []

with open(INPUT_FILE, "r") as f:
    for line in f:
        if line.strip() == "":
            continue
        angle_raw, sin_i, cos_i = parse_line(line)

        # Convert phase accumulator to degrees
        deg = (angle_raw * 360.0) / (2 ** PHASE_ACC_BITS)
        
        # Convert fixed-point
        sin_f = sin_i / (2 ** FRACTIONAL_BITS)
        cos_f = cos_i / (2 ** FRACTIONAL_BITS)

        # Compute true values
        sin_t = math.sin(math.radians(deg))
        cos_t = math.cos(math.radians(deg))

        # Error
        sin_e = sin_f - sin_t
        cos_e = cos_f - cos_t

        angles_deg.append(deg)
        sin_fixed.append(sin_f)
        cos_fixed.append(cos_f)
        sin_true.append(sin_t)
        cos_true.append(cos_t)
        sin_err.append(sin_e)
        cos_err.append(cos_e)

no_of_samples = len(angles_deg)

print(f"Samples: {no_of_samples}")
rms_sin = math.sqrt(sum(x * x for x in sin_err) / len(sin_err))
rms_cos = math.sqrt(sum(x * x for x in cos_err) / len(cos_err))

print(f"RMS SIN error: {rms_sin:.6f}")
print(f"RMS COS error: {rms_cos:.6f}")