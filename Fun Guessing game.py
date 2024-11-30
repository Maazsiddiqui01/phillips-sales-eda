# -*- coding: utf-8 -*-
"""
Created on Sat Mar  5 07:19:29 2022

@author: Maaz Siddiqui
"""
from random import randint
num_guess=0
output=randint(0,100)
guess=0
while guess!=output and num_guess<=4:
    guess=eval(input('Please enter your guess:'))
    num_guess=num_guess+1
    if guess>output:
        print('LOWER,',5-num_guess,' turns left')
    elif guess<output:
        print('HIGHER,',5-num_guess,'turns left')
    else:
        print('You got it')
print('Computer guess was',output)