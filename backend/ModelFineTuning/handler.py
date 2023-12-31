from typing import Dict, List, Any
from transformers import AutoTokenizer, AutoModelForCausalLM
import transformers
import torch

dtype = torch.bfloat16 if torch.cuda.get_device_capability()[0] == 8 else torch.float16

class EndpointHandler:
    def __init__(self, path=""):

        tokenizer = AutoTokenizer.from_pretrained(path, trust_remote_code=True)
        model = AutoModelForCausalLM.from_pretrained(
            path,
            return_dict=True,
            device_map="auto",
            load_in_8bit=True,
            torch_dtype=dtype,
            trust_remote_code=True,
        )

        generation_config = model.generation_config
        generation_config.max_new_tokens = 60
        generation_config.temperature = 0
        generation_config.num_return_sequences = 1
        generation_config.pad_token_id = tokenizer.eos_token_id
        generation_config.eos_token_id = tokenizer.eos_token_id
        self.generation_config = generation_config

        self.pipeline = transformers.pipeline(
            "text-generation",
            model=model,
            tokenizer=tokenizer
        )

    def __call__(self, data: Dict[str, Any]) -> Dict[str, Any]:
        prompt = data.pop("inputs", data)
        result = self.pipeline(prompt, generation_config=self.generation_config)
        return result