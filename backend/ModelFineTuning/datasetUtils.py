import json
import random

def datasetMixer():
    # Open the files and load the JSON
    with open('GPT-Investment-dataset.json', 'r') as file1:
    # with open('GPT-Investment-dataset.json', 'r') as file1, open('GPT-Statement-dataset.json', 'r') as file2:
        data1 = json.load(file1)
        # data2 = json.load(file2)

    # Combine and shuffle the data
    # combined_data = data1 + data2
    combined_data = data1
    random.shuffle(combined_data)

    # Calculate the index for 30% separation
    train_index = int(len(combined_data) * 0.3)

    for i, entry in enumerate(combined_data):
        try:
            userProfile =f'debt: {entry["inputs"]["userprofile"]["debt"]}, income: {entry["inputs"]["userprofile"]["income"]}, expenses: {entry["inputs"]["userprofile"]["expenses"]}, stock_market_knowledge: {entry["inputs"]["userprofile"]["stock_market_knowledge"]}, investment_risk: {entry["inputs"]["userprofile"]["investment_risk"]}, interest_sectors: {entry["inputs"]["userprofile"]["interest_sectors"]}' 
            formatted_text = f"### Instruction:\n {entry['inputs']['question']} Given the following information: {userProfile} \n\n### Response:\n{entry['response']}\n\n### END."
        except:
            print('error')
        # Assign to "train" or "test" based on index
        key = "test" if i < train_index else "train"
        json_object = {key: formatted_text}

        with open('mixedDataset.json', 'a') as f:
            f.write(json.dumps(json_object) + '\n')

def dataSet_toHF_mixer():
    # Open the files and load the JSON
    with open('finance-bot-dataset.json', 'r') as file1, open('finance-bot-dataset-2.json', 'r') as file2:
        data1 = json.load(file1)
        data2 = json.load(file2)

    # Combine and shuffle the data
    combined_data = data1 + data2
    random.shuffle(combined_data)

    # Calculate the index for 30% separation
    test_index = int(len(combined_data) * 0.3)


    
    for i, entry in enumerate(combined_data):
        try:
            key = "test" if i < test_index else "train"
            userProfile =f'debt: {entry["inputs"]["userprofile"]["debt"]}, income: {entry["inputs"]["userprofile"]["income"]}, expenses: {entry["inputs"]["userprofile"]["expenses"]}, stock_market_knowledge: {entry["inputs"]["userprofile"]["stock_market_knowledge"]}, investment_risk: {entry["inputs"]["userprofile"]["investment_risk"]}, interest_sectors: {entry["inputs"]["userprofile"]["interest_sectors"]}' 
            json_object = {
                key : {
                    "question" : f"### QUESTON:\n {entry['inputs']['question']} Given the following information: {userProfile}",
                    "response" : f"### RESPONSE:\n{entry['response'].replace('###Response:', '')}"
                }
            }


            with open('finance-bot-dataset-200-hf.json', 'a') as f:
                f.write(json.dumps(json_object) + '\n')
        except:
            print('error')


def format_for_llm(data):
    formatted_data = "Bank Statement:\n"
    
    for category, details in data["bankstatement"].items():
        formatted_data += f"\n{category}:\n"
        for key, value in details.items():
            formatted_data += f"  {key}: {value}\n"
    
    return formatted_data

def process_data(filename):
    # Read the JSON file
    with open(filename, 'r') as file:
        data_list = json.load(file)
    
    processed_data = []
    
    for entry in data_list:
        formatted_data = format_for_llm(entry["inputs"])
        question_string = f"""<s>### Question:\n{entry["inputs"]["question"]}\n\n{formatted_data}\n\n####\n</s>"""
        processed_data.append({
            "question": question_string,
            "response": entry["response"]
        })
    
    # Dump the values into a new JSON file
    with open('processed_data.json', 'w') as file:
        json.dump(processed_data, file, indent=4)


def format_data(data, instruction_prompt):
    formatted_data = []
    
    for entry in data:
        formatted_string = f"{instruction_prompt} {entry['question']} {entry['response']}"
        formatted_data.append(formatted_string)
    
    return {"train": formatted_data}

def process_and_save_data(input_filename, instruction_prompt, output_filename):
    # Read the JSON file
    with open(input_filename, 'r') as file:
        data = json.load(file)
    
    formatted_data = format_data(data, instruction_prompt)
    
    # Dump the values into a new JSON file
    with open(output_filename, 'w') as file:
        json.dump(formatted_data, file, indent=4)

# Sample instruction prompt
instruction_prompt = "<s>### Instruction:\nGiven the user bank statement summary, answer the following question providing a tailored answer to their situation and profile </s>"

# Process and save the data



if __name__ == '__main__':
    # print(format_for_llm(data))
    # datasetMixer()
    # dataSet_toHF_mixer()

    # Assuming the filename is 'data.json'
    process_data('GPT-Statement-dataset.json')
    # process_and_save_data('processed_data.json', instruction_prompt, 'formatted_data.json')



