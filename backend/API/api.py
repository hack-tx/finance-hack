

#    ____         __  ___   ___  ____  ____    __          
#   / __/__ ____ / /_/ _ | / _ \/  _/ / __/__ / /___ _____ 
#  / _// _ `(_-</ __/ __ |/ ___// /  _\ \/ -_) __/ // / _ \
# /_/  \_,_/___/\__/_/ |_/_/  /___/ /___/\__/\__/\_,_/ .__/
#                                                   /_/    


from fastapi import FastAPI, HTTPException, UploadFile, File,  status
from pydantic import BaseModel
from pathlib import Path
from fastapi.middleware.cors import CORSMiddleware
import httpx
from fastapi.responses import JSONResponse

import json
import os
import requests
import statementUtils

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Allows all origins
    allow_credentials=True,  # Allows cookies to be sent and received
    allow_methods=["*"],  # Allows all HTTP methods
    allow_headers=["*"],  # Allows all headers
)

API_URL = "https://yxg3de61fixsgvsc.us-east-1.aws.endpoints.huggingface.cloud"
headers = {
    "Authorization": "Bearer fhASmeHCrjQohdEgJDWAoWuvfaoiRNwbeXKbzTrWtbLcyELEyUBQGDjhhwSPkOaGqOFAutjxgJYePoNfnzJLklKUUWpOUEKDgOaYwJDJTJQyzPRXXTvAyMsEquCgccku",
    "Content-Type": "application/json"
}

class QueryModel(BaseModel):
    inputs: str

class StatementModel(BaseModel):
    question: str
class ProfileModel(BaseModel):
    debt: str                       # "3000",
    income: str                     # "4000/month",
    expenses: str                   # "2000/month",
    stock_market_knowledge: str     # "begginer",
    investment_risk: str            # "low",
    interest_sectors: str           # ["tech", "health", "automotive"]
class ProfileModelQ(BaseModel):
    question: str





@app.post("/profile")
async def create_profile(profile: ProfileModel):
    data = profile.dict()
    with open("profile.json", "w") as f:
        json.dump(data, f, indent=4)
    return {"message": "Profile data saved successfully"}

def read_profile_data():
    if os.path.exists("profile.json"):
        with open("profile.json", "r") as f:
            data = json.load(f)
        return data
    else:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="No profile data found")

@app.get("/get-profile")
async def get_profile():
    data = read_profile_data()
    return data


@app.post('/query-bot')
def query_bot(item: QueryModel):
    response = requests.post(API_URL, headers=headers, json={"inputs": item.inputs})

    if response.status_code != 200:
        raise HTTPException(status_code=response.status_code, detail=response.text)

    output = response.json()
    return {"response": output[0]['generated_text']}


@app.get('/check-message')
def check_message():
    if os.path.exists('files/transactions.csv'):
        return JSONResponse(status_code=200, content='okay')
    else:
        return JSONResponse(status_code=404, content='okay')



@app.post('/profile-question')
async def profile_question(query: ProfileModelQ):

    profile = read_profile_data()

    query = f"""
    ### QUESTON:
    {query.question} Given the following information: debt: {profile.debt}, income: {profile.income}, expenses: {profile.expenses}, stock_market_knowledge: {profile.stock_market_knowledge}, investment_risk: {profile.investment_risk}, interest_sectors: {profile.interest_sectors}

    ### Response:

    """

    complete_response = ''

    while True:
        response = await make_post_request(query)
        output = response.json()

        generated_text = output[0]['generated_text']
        complete_response += generated_text
        
        # Check for punctuation or newline at the end of the generated text
        if generated_text[-1] in {'.', '!', '?', '\n', '.\n\n'}:
            break
        
        query += generated_text  # append the generated text to the query for the next iteration

    return complete_response.replace('\n', '')

async def make_post_request(query):
    async with httpx.AsyncClient() as client:
        response = await client.post(API_URL, headers=headers, json={"inputs": query})

    if response.status_code != 200:
        raise HTTPException(status_code=response.status_code, detail=response.text)
    return response


@app.post('/statement-question')
async def statement_question(statementModel: StatementModel):

    jsonForm = statementUtils.process_csv('files/transactions.csv')
    textForm = statementUtils.parse_json_to_text(jsonForm)

    query = f"""
    ### QUESTON:
    {statementModel.question} Given the users bank statment: {textForm}

    ### Response:

    """

    complete_response = ''

    while True:
        response = await make_post_request(query)
        output = response.json()

        generated_text = output[0]['generated_text']
        complete_response += generated_text
        
        # Check for punctuation or newline at the end of the generated text
        if generated_text[-1] in {'.', '!', '?', '\n', '.\n\n'}:
            break
        
        query += generated_text  # append the generated text to the query for the next iteration

    return  complete_response.replace('\n', '')

@app.post("/upload-csv")
async def upload_file(file: UploadFile):
    file_location = f"files/{file.filename}"
    with open(file_location, "wb+") as file_object:
        file_object.write(file.file.read())
    print({"info": f"file '{file.filename}' uploaded at {file_location}"})
    return {"info": f"file '{file.filename}' uploaded at {file_location}"}
