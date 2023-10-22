

#    ____         __  ___   ___  ____  ____    __          
#   / __/__ ____ / /_/ _ | / _ \/  _/ / __/__ / /___ _____ 
#  / _// _ `(_-</ __/ __ |/ ___// /  _\ \/ -_) __/ // / _ \
# /_/  \_,_/___/\__/_/ |_/_/  /___/ /___/\__/\__/\_,_/ .__/
#                                                   /_/    


from fastapi import FastAPI, HTTPException, UploadFile, File
from pydantic import BaseModel
from pathlib import Path
import requests

app = FastAPI()

API_URL = "https://k1iu7ilfceps6loc.us-east-1.aws.endpoints.huggingface.cloud"
headers = {
    "Authorization": "Bearer fhASmeHCrjQohdEgJDWAoWuvfaoiRNwbeXKbzTrWtbLcyELEyUBQGDjhhwSPkOaGqOFAutjxgJYePoNfnzJLklKUUWpOUEKDgOaYwJDJTJQyzPRXXTvAyMsEquCgccku",
    "Content-Type": "application/json"
}

class QueryModel(BaseModel):
    inputs: str
class ProfileModel(BaseModel):
    question: str
    debt: str                       # "3000",
    income: str                     # "4000/month",
    expenses: str                   # "2000/month",
    stock_market_knowledge: str     # "begginer",
    investment_risk: str            # "low",
    interest_sectors: str           # ["tech", "health", "automotive"]


@app.post('/query-bot')
def query_bot(item: QueryModel):
    response = requests.post(API_URL, headers=headers, json={"inputs": item.inputs})

    if response.status_code != 200:
        raise HTTPException(status_code=response.status_code, detail=response.text)

    output = response.json()
    return {"response": output[0]['generated_text']}

# TODO: FINISH THIS
@app.post('/profile-question')
def profile_question(item: ProfileModel):

    f"""
    ### QUESTON:
    {ProfileModel.question} Given the following information: debt: {ProfileModel.debt} , income: {ProfileModel.income} , expenses: {ProfileModel.expenses} , stock_market_knowledge: {ProfileModel.stock_market_knowledge} , investment_risk: {ProfileModel.investment_risk}, interest_sectors: {ProfileModel.interest_sectors} 


    ### Response:

    
    """


    response = requests.post(API_URL, headers=headers, json={
        #TODO: Fillout prompt
    })

    if response.status_code != 200:
        raise HTTPException(status_code=response.status_code, detail=response.text)

    output = response.json()
    return {"response": output[0]['generated_text']}


# TODO: FINISH THIS
@app.post('/statement-question')
def profile_question(item: QueryModel):
    response = requests.post(API_URL, headers=headers, json={"inputs": item.inputs})

    if response.status_code != 200:
        raise HTTPException(status_code=response.status_code, detail=response.text)

    output = response.json()
    return {"response": output[0]['generated_text']}



@app.post("/upload-csv")
async def upload_file(file: UploadFile):
    file_location = f"files/{file.filename}"
    with open(file_location, "wb+") as file_object:
        file_object.write(file.file.read())
    print({"info": f"file '{file.filename}' uploaded at {file_location}"})
    return {"info": f"file '{file.filename}' uploaded at {file_location}"}
