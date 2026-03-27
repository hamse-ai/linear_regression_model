import joblib
import pandas as pd
import numpy as np
import os

BASE_DIR = os.path.dirname(os.path.abspath(__file__))
MODEL_PATH = os.path.join(BASE_DIR, "best_model.pkl")
SCALER_PATH = os.path.join(BASE_DIR, "scaler.pkl")

# Load model and scaler
model = joblib.load(MODEL_PATH)
scaler = joblib.load(SCALER_PATH)

def make_prediction(input_data: dict) -> float:
    # Expected categorical dummy columns from training:
    # 'reading score', 'writing score'
    # 'gender_male'
    # 'race/ethnicity_group B', 'race/ethnicity_group C', 'race/ethnicity_group D', 'race/ethnicity_group E'
    # 'parental level of education_bachelor\'s degree', 'parental level of education_high school', 
    # 'parental level of education_master\'s degree', 'parental level of education_some college', 
    # 'parental level of education_some high school'
    # 'lunch_standard'
    # 'test preparation course_none'
    # Create a base dataframe with all zeros/falses for dummy columns
    dummy_columns = [
        'reading score', 'writing score', 'gender_male',
        'race/ethnicity_group B', 'race/ethnicity_group C',
        'race/ethnicity_group D', 'race/ethnicity_group E',
        "parental level of education_bachelor's degree",
        "parental level of education_high school",
        "parental level of education_master's degree",
        "parental level of education_some college",
        "parental level of education_some high school",
        'lunch_standard', 'test preparation course_none'
    ]
    
    # Initialize dictionary with defaults
    data_dict = {col: [0] if 'score' in col else [False] for col in dummy_columns}
    
    # Fill in numeric features
    data_dict['reading score'] = [input_data['reading_score']]
    data_dict['writing score'] = [input_data['writing_score']]
    
    # Fill in categorical dummies (matching the training mapping)
    if input_data['gender'] == 'male':
        data_dict['gender_male'] = [True]
    
    race = input_data['race_ethnicity']
    if race in ['group B', 'group C', 'group D', 'group E']:
        data_dict[f'race/ethnicity_{race}'] = [True]
        
    education = input_data['parental_level_of_education']
    if education in ["bachelor's degree", "high school", "master's degree", "some college", "some high school"]:
        data_dict[f'parental level of education_{education}'] = [True]
        
    if input_data['lunch'] == 'standard':
        data_dict['lunch_standard'] = [True]
        
    if input_data['test_preparation_course'] == 'none':
        data_dict['test preparation course_none'] = [True]
        
    # Create DataFrame
    df = pd.DataFrame(data_dict)
    
    # Ensure correct column order
    df = df[dummy_columns]
    
    # Scale features
    df_scaled = scaler.transform(df)
    
    # Predict
    prediction = model.predict(df_scaled)
    
    return float(prediction[0])
