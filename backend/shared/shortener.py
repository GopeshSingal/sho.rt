import string
import random

ALPHABET = string.ascii_letters + string.digits

def generate_short_id(length: int = 7) -> str:
    return ''.join(random.choice(ALPHABET) for _ in range(length))