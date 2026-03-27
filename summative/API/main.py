from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel, Field
from typing import Literal
from prediction import make_prediction

app = FastAPI(
    title="Student Math Score Prediction API",
    description="API for predicting math scores based on student performance data.",
    version="1.0.0"
)

# Add CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"], 
    allow_credentials=True,
    allow_methods=["*"], 
    allow_headers=["*"],
)

# Pydantic model for request body validation
class StudentData(BaseModel):
    gender: Literal["male", "female"] = Field(
        ..., description="Gender of the student"
    )
    race_ethnicity: Literal["group A", "group B", "group C", "group D", "group E"] = Field(
        ..., description="Race/ethnicity group"
    )
    parental_level_of_education: Literal[
        "bachelor's degree", "some college", "master's degree", 
        "associate's degree", "high school", "some high school"
    ] = Field(
        ..., description="Parent's level of education"
    )
    lunch: Literal["standard", "free/reduced"] = Field(
        ..., description="Lunch type"
    )
    test_preparation_course: Literal["none", "completed"] = Field(
        ..., description="Test preparation course completion status"
    )
    reading_score: int = Field(
        ..., ge=0, le=100, description="Reading score (0-100)"
    )
    writing_score: int = Field(
        ..., ge=0, le=100, description="Writing score (0-100)"
    )

@app.post("/predict")
async def predict_score(data: StudentData):
    """
    Takes student performance data and returns a predicted math score.
    """
    try:
        # Pydantic models can be safely converted to dict
        input_dict = data.model_dump()
        prediction = make_prediction(input_dict)
        return {
            "predicted_math_score": prediction,
            "status": "success"
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.post("/retrain")
async def retrain_model():
    """
    Endpoint to trigger model retraining when new data is uploaded.
    """
    # Logic for retraining could be triggered here
    return {"message": "Model retraining triggered successfully (Stub)."}

if __name__ == "__main__":
    import uvicorn
    uvicorn.run("main:app", host="0.0.0.0", port=8000, reload=True)
