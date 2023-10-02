
import numpy as np
import pickle
import streamlit as st

#loading the saved model
loaded_model = pickle.load(open("C:/Users/Shrishti Vaish/Documents/Projects/Python/Streamlit/rfmodel.sav",'rb'))

#creating function to take inputs from the user and predict
def predict_failure(input_data):
    #change shape and conver into array
    input_data_array = np.asarray(input_data)

    #reshape
    input_data_reshaped = input_data_array.reshape(1,-1)

    prediction = loaded_model.predict(input_data_reshaped)

    if prediction[0] == 0:
        return 'The machine is pretty safe before it breakdowns!'
    else:
        return 'The machine is quite possible to breakdown.'
    

def main():
    
    #title
    st.title('Machine Breakdown!')

    #get input data
    Air_temperature = st.text_input('Air temperature: ')
    Process_temperature = st.text_input('Process temperature: ')
    Rotational_speed = st.text_input('Rotational Speed: ')
    Torque = st.text_input('Torque: ')
    Tool_wear = st.text_input('Tool Wear: ')
    Type_H = st.text_input('Type_H(0 or 1): ')
    Type_L = st.text_input('Type_L(0 or 1): ')
    Type_M = st.text_input('Type_M(0 or 1): ')
    TWF = st.text_input('TWF: ')
    HDF = st.text_input('HDF: ')
    PWF	= st.text_input('PWF: ')
    OSF	= st.text_input('OSF: ')
    RNF = st.text_input('RNF: ')


    #store result
    debug = ''

    #create button
    if st.button('Debug for failure'):
        debug = predict_failure(['Air_temperature', 'Process_temperature','Rotational_speed','Torque','Tool_wear','Type_H', 'Type_L', 'Type_M', 'TWF', 'HDF', 'PWF', 'OSF', 'RNF'])

    
    st.success(debug)


if __name__  == '__main__':
    main() 