import csv
from collections import defaultdict
import json

def process_csv_text_table(filename):
    # Initialize defaultdicts to store sums and counts
    sums = defaultdict(float)
    counts = defaultdict(int)

    # Open and read the CSV file
    with open(filename, 'r') as file:
        reader = csv.reader(file)
        header = next(reader)

        # Process each row in the CSV
        for row in reader:
            category = row[3]
            amount = float(row[2])
            sums[category] += amount
            counts[category] += 1

    # Calculate averages
    averages = {category: sums[category] / counts[category] for category in sums}

    # Display results
    print("Category-wise Summary:")
    print("Category".ljust(20), "Total".rjust(10), "Count".rjust(10), "Average".rjust(10))
    print("-" * 50)
    for category in sums:
        print(category.ljust(20), f"{sums[category]:>10.2f}", f"{counts[category]:>10}", f"{averages[category]:>10.2f}")

def parse_json_to_text(json_data):

    json_data = json.loads(json_data)
    text_data = ""
    for category, stats in json_data.items():
        total = stats['Total']
        count = stats['Count']
        average = stats['Average']
        text_data += f"Category: {category}\nTotal: {total}\nCount: {count}\nAverage: {average}\n\n"
    return text_data

def process_csv(filename):
    # Initialize defaultdicts to store sums and counts
    sums = defaultdict(float)
    counts = defaultdict(int)

    # Open and read the CSV file
    with open(filename, 'r') as file:
        reader = csv.reader(file)
        header = next(reader)

        # Process each row in the CSV
        for row in reader:
            category = row[3]
            amount = float(row[2])
            sums[category] += amount
            counts[category] += 1

    # Calculate averages
    averages = {category: sums[category] / counts[category] for category in sums}

    # Prepare the results in a dictionary
    results = {}
    for category in sums:
        results[category] = {
            "Total": sums[category],
            "Count": counts[category],
            "Average": averages[category]
        }

    # Convert the results to JSON and print
    json_output = json.dumps(results, indent=4)
    print(json_output)
    return json_output

def process_csv_to_json(filename):
    # Initialize defaultdicts to store sums and counts
    sums = defaultdict(float)
    counts = defaultdict(int)

    # Open and read the CSV file
    with open(filename, 'r') as file:
        reader = csv.reader(file)
        header = next(reader)

        # Process each row in the CSV
        for row in reader:
            category = row[3]
            amount = float(row[2])
            sums[category] += amount
            counts[category] += 1

    # Calculate averages
    averages = {category: sums[category] / counts[category] for category in sums}

    # Prepare the results in a dictionary
    results = {}
    for category in sums:
        results[category] = {
            "Total": sums[category],
            "Count": counts[category],
            "Average": averages[category]
        }


    return results




if __name__ == "__main__":
    process_csv('transactions.csv')
