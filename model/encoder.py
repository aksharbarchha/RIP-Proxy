from os import listdir
from os.path import isfile, join
import face_recognition
import cv2
import pandas as pd
import pickle

def get_names_dictionary():
    '''
    Returns dictionary of roll numbers and name of students
    '''
    df = pd.read_csv("Roll Call.csv",  dtype={0: 'object', 1: 'object'})
    roll_numbers = df['Roll No.']
    names = df['Name']
    
    dictionary = dict(zip(roll_numbers, names))
    # print(dictionary)
    return dictionary


def create_encodings(path):
        
    known_face_encodings = []
    known_face_rolls = []
    known_face_names = []
    
    # dictionary = get_names_dictionary()
    onlyfiles = [f for f in listdir(path) if isfile(join(path, f))]
    # print(onlyfiles)

    for file in onlyfiles:
        print("File:\n"+file)
        image = face_recognition.load_image_file(path + "/" + file)
        face_encoding = face_recognition.face_encodings(image)[0]
        known_face_encodings.append(face_encoding)
        roll_no = file[0:-4]
        known_face_rolls.append(roll_no)
        '''
        known_face_names.append(dictionary.get(roll_no))

        '''
    with open("encodings.pickle","wb") as f:
        pickle.dump(known_face_encodings, f)
    with open("rolls.pickle","wb") as f:
        pickle.dump(known_face_rolls, f)


    return known_face_encodings, known_face_rolls


# create_encodings("static/images/")


