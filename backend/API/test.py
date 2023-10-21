import requests

API_URL = "https://k1iu7ilfceps6loc.us-east-1.aws.endpoints.huggingface.cloud"
headers = {
	"Authorization": "Bearer fhASmeHCrjQohdEgJDWAoWuvfaoiRNwbeXKbzTrWtbLcyELEyUBQGDjhhwSPkOaGqOFAutjxgJYePoNfnzJLklKUUWpOUEKDgOaYwJDJTJQyzPRXXTvAyMsEquCgccku",
	"Content-Type": "application/json"
}

def query(payload):
	response = requests.post(API_URL, headers=headers, json=payload)
	return response.json()
	
output = query({
	"inputs": """
Question:\n Does my spending look like its normal ?\n\nBank Statement:\n\nIncome:\n  Total: 2000.0\n  Count: 2\n  Average: 1000.0\n\nLoans:\n  Total: -300.0\n  Count: 1\n  Average: -300.0\n\nDining Out:\n  Total: -150.0\n  Count: 4\n  Average: -37.5\n\nEntertainment:\n  Total: -100.0\n  Count: 2\n  Average: -50.0\n\nGroceries:\n  Total: -250.0\n  Count: 3\n  Average: -83.33\n\n\n


"###Response:""",
})

print(output[0]['generated_text'])