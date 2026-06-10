import csv
import random
import os
import sys

NUM_ROWS = 80
COLUMNS = ["ID фильма", "Рейтинг", "Длительность в мин", "Жанр"]

def generate_row():
    return {
        "ID фильма": random.randint(1000, 9999),
        "Рейтинг": round(random.uniform(1.0, 10.0), 2),
        "Длительность в мин": random.randint(60, 240),
        "Жанр": random.choice(["Комедия", "Драма", "Боевик", "Ужасы"]),
    }

OUTPUT_DIR = sys.argv[1] if len(sys.argv) > 1 else "/data"
OUTPUT_FILE = os.path.join(OUTPUT_DIR, "data.csv")

os.makedirs(OUTPUT_DIR, exist_ok=True)

rows = [generate_row() for _ in range(NUM_ROWS)]

with open(OUTPUT_FILE, "w", newline="", encoding="utf-8") as f:
    writer = csv.DictWriter(f, fieldnames=COLUMNS)
    writer.writeheader()
    writer.writerows(rows)

