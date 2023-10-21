

# FastAPI setup
#    ____         __  ___   ___  ____  ____    __          
#   / __/__ ____ / /_/ _ | / _ \/  _/ / __/__ / /___ _____ 
#  / _// _ `(_-</ __/ __ |/ ___// /  _\ \/ -_) __/ // / _ \
# /_/  \_,_/___/\__/_/ |_/_/  /___/ /___/\__/\__/\_,_/ .__/
#                                                   /_/    


from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
import requests

app = FastAPI()

API_URL = "https://k1iu7ilfceps6loc.us-east-1.aws.endpoints.huggingface.cloud"
headers = {
    "Authorization": "Bearer fhASmeHCrjQohdEgJDWAoWuvfaoiRNwbeXKbzTrWtbLcyELEyUBQGDjhhwSPkOaGqOFAutjxgJYePoNfnzJLklKUUWpOUEKDgOaYwJDJTJQyzPRXXTvAyMsEquCgccku",
    "Content-Type": "application/json"
}

class QueryModel(BaseModel):
    inputs: str

@app.post('/query-bot')
def api_endpoint(item: QueryModel):
    response = requests.post(API_URL, headers=headers, json={"inputs": item.inputs})

    if response.status_code != 200:
        raise HTTPException(status_code=response.status_code, detail=response.text)

    output = response.json()
    return {"response": output[0]['generated_text']}
