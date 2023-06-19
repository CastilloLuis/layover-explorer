import openai
import os
from dotenv import load_dotenv
load_dotenv()

openai.api_key = os.environ.get('OPEAN_AI_API_KEY')
 
def requestOpeanAi(prompt):
    response = openai.ChatCompletion.create(
        model = "gpt-3.5-turbo",
        messages = [{
            "role": "user",
            "content": prompt
        }]
    )
    return response.choices[0].message.content
