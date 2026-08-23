import sys

print("[script.py] Otrzymane parametry:")
for i, arg in enumerate(sys.argv[1:], start=1):
    print(f"Parametr {i}: {arg}")

# tu dodajesz swoją logikę
