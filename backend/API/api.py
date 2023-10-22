

#    ____         __  ___   ___  ____  ____    __          
#   / __/__ ____ / /_/ _ | / _ \/  _/ / __/__ / /___ _____ 
#  / _// _ `(_-</ __/ __ |/ ___// /  _\ \/ -_) __/ // / _ \
# /_/  \_,_/___/\__/_/ |_/_/  /___/ /___/\__/\__/\_,_/ .__/
#                                                   /_/    


from fastapi import FastAPI, HTTPException, UploadFile, File
from pydantic import BaseModel
from pathlib import Path
import httpx
import requests

app = FastAPI()

API_URL = "https://yxg3de61fixsgvsc.us-east-1.aws.endpoints.huggingface.cloud"
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


@app.post('/profile-question')
def profile_question(profile: ProfileModel):

### QUESTON:\n How can I access and review these SEC filings? Given the following information: debt: 800, income: 4000/month, expenses: 2000/month, stock_market_knowledge: intermediate, investment_risk: medium, interest_sectors: ['technology', 'communications']

    query = f"""
    ### QUESTON:
    {profile.question} Given the following information: debt: {profile.debt} , income: {profile.income} , expenses: {profile.expenses} , stock_market_knowledge: {profile.stock_market_knowledge} , investment_risk: {profile.investment_risk}, interest_sectors: {profile.interest_sectors} 


    ### Response:

    
    """


    response = requests.post(API_URL, headers=headers, json={
        "inputs": query
    })

    if response.status_code != 200:
        raise HTTPException(status_code=response.status_code, detail=response.text)

    output = response.json()
    return {"response": output[0]['generated_text']}


@app.post('/profile-question-2')
async def profile_question_2(profile: ProfileModel):

    query = f"""
    ### QUESTON:
    {profile.question} Given the following information: debt: {profile.debt}, income: {profile.income}, expenses: {profile.expenses}, stock_market_knowledge: {profile.stock_market_knowledge}, investment_risk: {profile.investment_risk}, interest_sectors: {profile.interest_sectors}

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

    return {"response": complete_response}

async def make_post_request(query):
    async with httpx.AsyncClient() as client:
        response = await client.post(API_URL, headers=headers, json={"inputs": query})

    if response.status_code != 200:
        raise HTTPException(status_code=response.status_code, detail=response.text)
    return response


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
