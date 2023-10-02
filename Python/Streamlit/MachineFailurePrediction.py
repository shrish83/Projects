
import numpy as np
import pickle
import streamlit as st

#loading the saved model
loaded_model = pickle.load(open("./rfmodel.sav",'rb'))

#creating function to take inputs from the user and predict
def predict_failure(input_data):
    #change shape and conver into array
    input_data_array = np.asarray(input_data,dtype=float)

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
    Air_temperature = st.number_input('Air temperature: ', format="%.6f")
    Process_temperature = st.number_input('Process temperature: ', format="%.6f")
    Rotational_speed = st.number_input('Rotational Speed: ', format="%.6f")
    Torque = st.number_input('Torque: ', format="%.6f")
    Tool_wear = st.number_input('Tool Wear: ', format="%.6f")
    Type_H = st.number_input('Type_H(0 or 1): ', step=1)
    Type_L = st.number_input('Type_L(0 or 1): ', step=1)
    Type_M = st.number_input('Type_M(0 or 1): ', step=1)
    TWF = st.number_input('TWF: ', step=1)
    HDF = st.number_input('HDF: ', step=1)
    PWF	= st.number_input('PWF: ', step=1)
    OSF	= st.number_input('OSF: ', step=1)
    RNF = st.number_input('RNF: ', step=1)


    #store result
    debug = ''

    #create button
    if st.button('Debug for failure'):
        debug = predict_failure([Air_temperature, Process_temperature,Rotational_speed,Torque,Tool_wear,Type_H, Type_L, Type_M, TWF, HDF, PWF, OSF, RNF])

    
    st.success(debug)


if __name__  == '__main__':
    main() 
