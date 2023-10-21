```python
Invesment_Prompt_Example = [
    {
        
        "inputs": {
            "instruction": "###Instruction: Given user profile, answer the following question providing a tailored answer to their situation and profile",
            "question": "how can I start investing with my free cash safely",
            "userprofile": {
                "debt": "3000",
                "income": "4000/month",
                "expenses": "2000/month",
                "stock_market_knowledge": "begginer",
                "investment_risk": "low",
                "interest_sectors": ["tech", "health", "automotive"]
            }
        }
    

        "response: "###Response Looking at your profile it would be recommended to pay off your debt before loading your cash into investments, as they can be risky. How ever there are still safe options you can look ETFS, Since you have interests in tech, health, and automotive sectors, consider investing in mutual funds or ETFs focused on these sectors. Look for funds with a history of stability and a good track record, but also keep in mind to choose funds with low expense ratios. Given your beginner status, mutual funds or ETFs can ```provide a diversified exposure to these sectors with professional management of the fund."
        }


    ]
Statement_Analysis_Example = [
    {
        
        "inputs": {
            "instruction": "<s>### Instruction:\nGiven the user statment summary, answer the following question providing a tailored answer to their situation and profile </s>",
            "question": "how can I start investing with my free cash safely",
            "userprofile": {
                "debt": "3000",
                "income": "4000/month",
                "expenses": "2000/month",
                "stock_market_knowledge": "begginer",
                "investment_risk": "low",
                "interest_sectors": ["tech", "health", "automotive"]
            },
            "bankstatement": {
                    "Income": {
                        "Total": 650.0,
                        "Count": 2,
                        "Average": 325.0
                    },
                    "Education": {
                        "Total": -100.23,
                        "Count": 3,
                        "Average": -33.41
                    },
                    "Food & Beverage": {
                        "Total": -78.5,
                        "Count": 6,
                        "Average": -13.08
                    },
                    "Entertainment": {
                        "Total": -70.98,
                        "Count": 4,
                        "Average": -17.745
                    },
                    "Groceries": {
                        "Total": -93.67,
                        "Count": 2,
                        "Average": -46.835
                    },
                    "Transportation": {
                        "Total": -25.0,
                        "Count": 1,
                        "Average": -25.0
                    },
                    "Utilities": {
                        "Total": -45.0,
                        "Count": 2,
                        "Average": -22.5
                    },
                    "Apparel": {
                        "Total": -18.0,
                        "Count": 1,
                        "Average": -18.0
                    },
                    "Health & Fitness": {
                        "Total": -25.0,
                        "Count": 1,
                        "Average": -25.0
                    },
                    "Shopping": {
                        "Total": -50.0,
                        "Count": 1,
                        "Average": -50.0
                    },
                    "Gifts & Donations": {
                        "Total": -40.0,
                        "Count": 1,
                        "Average": -40.0
                    }
                }
        }
    

        "response: "###Response:\nGiven your low income you can consider spending less money on entertainment & food & beverages, this will free up more money for you to save or pay towards your debt "
        }


    ]



```