""" Step1:- Reading our solidity file"""
with open("./SimpleStorage.sol","r") as file:
    simple_storage_file=file.read()
    print(simple_storage_file)

""" Step2:- We need a compiler to compile the solidity read into the .py file"""
""" pip install py-solc-x"""


"""--------------Import Statements-------------------------"""
from solcx import compile_standard,install_solc
import os
import json 
from web3 import Web3
from dotenv import load_dotenv
load_dotenv()
"""--------------Import Statements-------------------------"""




# print("Installing...")
install_solc("0.8.0")#installing the compiler of required version

""" Compiling our code """
compiled_sol = compile_standard(
    {
        "language":"Solidity",
        "sources":{"SimpleStorage.sol":{"content":simple_storage_file}},
        "settings": {
            "outputSelection":{   
            "*":{"*":["abi","metadata","evm.bytecode","evm.sourceMap"]}
            }
        },
    },
    solc_version="0.8.0", 
)
# print(compiled_sol)

with open("compiled_code.json","w")as file:
    json.dump(compiled_sol,file)


""" Deploying the solidity code """
#get the bytecode
bytecode=compiled_sol["contracts"]["SimpleStorage.sol"]["SimpleStorage"]["evm"]["bytecode"]["object"]

#get the abi
abi=compiled_sol["contracts"]["SimpleStorage.sol"]["SimpleStorage"]["abi"]
# print(abi)

""" Now,like we used to deploy our contracts on a testNet in remix,we will be using 'Ganache' which is a blockchain simulation application """

#Establishing connection with ganache
#1.RPC Server
w3= Web3(Web3.HTTPProvider("http://127.0.0.1:7545"))

#2. Chain ID/Network ID
chain_ID=1337

#3 An Address to deploy from
my_address="0x3aC69a53f59715245E5cc4e5c15995e09FEB41C8"#Make sure this is in Hexadecimals

#4. Private key to sign the transactions
#private_key=os.getenv("Private_Key")
private_key=os.getenv("private_key")    #Make sure this is in Hexadecimals


"""-----------------Deploying the contract in ganache using python----------------"""
#Creating the contract
SimpleStorage=w3.eth.contract(abi=abi,bytecode=bytecode)
# print(SimpleStorage)

#Get the Nonce(number of transactions)
nonce=w3.eth.getTransactionCount(my_address)
# print(nonce)

""" Creating a Transaction """
#1. Build a Transaction
#2. Sign the transaction
#3. Send the Transaction

#Budilding the transaction
txn= SimpleStorage.constructor().buildTransaction({"chainId":chain_ID,"from":my_address,"nonce":nonce})
# print(txn)
signed_txn=w3.eth.account.sign_transaction(txn,private_key=private_key)
# print(private_key)
print(signed_txn)
#Sending the signed Transaction
txn_hash=w3.eth.send_raw_transaction(signed_txn.rawTransaction)