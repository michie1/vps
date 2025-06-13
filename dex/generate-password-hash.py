#!/usr/bin/env python3
import bcrypt
import sys

def generate_hash(password):
    """Generate bcrypt hash for Dex password"""
    salt = bcrypt.gensalt()
    hash_bytes = bcrypt.hashpw(password.encode('utf-8'), salt)
    return hash_bytes.decode('utf-8')

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python3 generate-password-hash.py <password>")
        sys.exit(1)
    
    password = sys.argv[1]
    hash_value = generate_hash(password)
    print(f"Password: {password}")
    print(f"Hash: {hash_value}")