import face_recognition
import cv2
import numpy as np
from os import listdir
from os.path import isfile, join
from encoder import create_encodings,get_names_dictionary
import urllib.request 
from urllib.request import Request, urlopen
import pickle

# class AppURLopener(urllib.request.FancyURLopener):
#     version = "Mozilla/5.0"


def hello(url):
    print('URL:\n'+url)
    url= url[:89] + '%2F' + url[90:]
    print("Achchha URL:\n"+url)
    # Initialize some variables
    face_locations = []
    face_encodings = []
    face_names = []
    # filename = "test.jpg"
    #process_this_frame = True
    #req = Request(url, headers={'User-Agent': 'Mozilla/5.0'})
    #webpage = urlopen(req).read()
    # opener = AppURLopener()
    # webpage = opener.open(url)
    urllib.request.urlretrieve(url, "test.jpg")
    
    # file = opener.open(url);
    # print (file.read())

    #Loading a test image into img
    #test_img = face_recognition.load_image_file("test.jpg")
    test_img = face_recognition.load_image_file("test.jpg")

    face_locations = face_recognition.face_locations(test_img)

    #Create face encodings of detected faces
    face_encodings = face_recognition.face_encodings(test_img, face_locations)
    
    print(len(face_encodings))  

    dictionary = get_names_dictionary()
    # known_face_encodings, known_face_rolls = create_encodings("static/images/")
    with open("encodings.pickle", "rb") as f:
        known_face_encodings = pickle.load(f)
    with open("rolls.pickle", "rb") as f:
        known_face_rolls = pickle.load(f)

    for face_encoding in face_encodings:
        # See if the face is a match for the known face(s)
        
        matches = face_recognition.compare_faces(known_face_encodings, face_encoding, tolerance = 0.6)
        
        name = "Unk"
        threshold = 0.51
        # Or instead, use the known face with the smallest distance to the new face
        face_distances = face_recognition.face_distance(known_face_encodings, face_encoding)
        
        best_match_index = np.argmin(face_distances)
        if face_distances[best_match_index] <= threshold: 
            if matches[best_match_index]:
                name = known_face_rolls[best_match_index]
        # if name!="Unk":
        #     print(dictionary.get(name))
        # else:
        #     print("Unk")
        # print("Distance: ", face_distances[best_match_index])
        if name!="Unk":
            face_names.append(name)
    print(len(face_names))    

#     for (top, right, bottom, left), name in zip(face_locations, face_names):
#         # Scale back up face locations since the frame we detected in was scaled to 1/4 size
        
#         # Draw a box around the face
#         cv2.rectangle(test_img, (left, top), (right, bottom), (0, 0, 255), 2)

#         # Draw a label with a name below the face
#         cv2.rectangle(test_img, (left, bottom - 5), (right, bottom), (0, 0, 255), cv2.FILLED)
#         font = cv2.FONT_HERSHEY_DUPLEX
#         cv2.putText(test_img, name, (left + 6, bottom - 12), font, 0.4, (255, 255, 255), 1)
#         cv2.resize(test_img, (0, 0), fx=0.25, fy=0.25)
#         # Display the resulting image
        
#         # cv2.imshow('Result', test_img)
#         cv2.imwrite('New Res.jpg', test_img)



    print("Done")
    # cv2.waitKey(0)
    # cv2.destroyAllWindows()

    return sorted(face_names)




'''
while True:
    # Grab a single frame of video
    ret, frame = video_capture.read()

    # Resize frame of video to 1/4 size for faster face recognition processing
    small_frame = cv2.resize(frame, (0, 0), fx=0.25, fy=0.25)

    # Convert the image from BGR color (which OpenCV uses) to RGB color (which face_recognition uses)
    rgb_small_frame = small_frame[:, :, ::-1]

    # Only process every other frame of video to save time
    if process_this_frame:
        # Find all the faces and face encodings in the current frame of video
        face_locations = face_recognition.face_locations(rgb_small_frame)
        face_encodings = face_recognition.face_encodings(rgb_small_frame, face_locations)

        face_names = []
        for face_encoding in face_encodings:
            # See if the face is a match for the known face(s)
            matches = face_recognition.compare_faces(known_face_encodings, face_encoding)
            name = "U"

            # # If a match was found in known_face_encodings, just use the first one.
            # if True in matches:
            #     first_match_index = matches.index(True)
            #     name = known_face_names[first_match_index]

            # Or instead, use the known face with the smallest distance to the new face
            face_distances = face_recognition.face_distance(known_face_encodings, face_encoding)
            best_match_index = np.argmin(face_distances)
            if matches[best_match_index]:
                name = known_face_names[best_match_index]

            face_names.append(name)

    process_this_frame = not process_this_frame


    # Display the results
    for (top, right, bottom, left), name in zip(face_locations, face_names):
        # Scale back up face locations since the frame we detected in was scaled to 1/4 size
        top *= 4
        right *= 4
        bottom *= 4
        left *= 4

        # Draw a box around the face
        cv2.rectangle(frame, (left, top), (right, bottom), (0, 0, 255), 2)

        # Draw a label with a name below the face
        cv2.rectangle(frame, (left, bottom - 35), (right, bottom), (0, 0, 255), cv2.FILLED)
        font = cv2.FONT_HERSHEY_DUPLEX
        cv2.putText(frame, name, (left + 6, bottom - 6), font, 1.0, (255, 255, 255), 1)

    # Display the resulting image
    cv2.imshow('Video', frame)

    # Hit 'q' on the keyboard to quit!
    if cv2.waitKey(1) & 0xFF == ord('q'):
        break

# Release handle to the webcam
video_capture.release()
cv2.destroyAllWindows()
'''
