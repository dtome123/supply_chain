import os
import time



PATH = r"C:\Users\Vi\Desktop\Solidity\supply_chain\app\src\contracts"


for file in os.listdir(PATH):
    os.remove(os.path.join(PATH, file))

os.system("truffle compile")
os.system("truffle migrate")