# file: app/api/analyze.py
import base64
import requests
from enum import Enum
from fastapi import FastAPI, File, UploadFile, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from app.core.settings import settings

HF_TOKEN = settings.HF_TOKEN
MODEL = settings.MODEL  # put: Qwen/Qwen3-VL-8B-Instruct
HF_URL = f"https://router.huggingface.co/models/{MODEL}"
HEADERS = {"Authorization": f"Bearer {HF_TOKEN}"}

app = FastAPI()
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # tighten for prod
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

class AnalyzeMode(str, Enum):
    DESCRIBE = "describe"
    OBJECTS = "objects"
    OCR = "ocr"
    QA = "qa"

PROMPTS = {
    AnalyzeMode.DESCRIBE: "Describe this image in detail, mentioning scene, main subjects and style.",
    AnalyzeMode.OBJECTS: "List all distinct objects visible in the image and give bounding-box-like descriptions (approx positions).",
    AnalyzeMode.OCR: "Extract **all** readable text from the image. Return plain text only.",
    AnalyzeMode.QA: "Answer questions about the image. If asked for facts, answer concisely and cite what you see."
}

@app.post("/analyze")
async def analyze(mode: AnalyzeMode = AnalyzeMode.DESCRIBE, file: UploadFile = File(...)):
    # read bytes
    img_bytes = await file.read()
    if not img_bytes:
        raise HTTPException(status_code=400, detail="Empty file uploaded")

    # encode to base64 (some providers accept raw bytes, but base64 JSON is widely supported)
    img_b64 = base64.b64encode(img_bytes).decode("utf-8")
    prompt = PROMPTS[mode]

    payload = {
        "inputs": prompt,
        "image": img_b64
    }

    try:
        resp = requests.post(HF_URL, headers=HEADERS, json=payload, timeout=60)
    except requests.exceptions.RequestException as e:
        raise HTTPException(status_code=502, detail=f"request error: {e}")

    # helpful debugging for 404/410 cases
    if resp.status_code == 404:
        # model likely not deployed via Inference Providers
        raise HTTPException(
            status_code=502,
            detail=(
                "HF 404: model not available via Inference Providers. "
                "Either the model isn't hosted for inference or the MODEL name is wrong. "
                "Try a provider-backed model (e.g. Qwen/Qwen3-VL-8B-Instruct) or deploy to an endpoint."
            )
        )

    if resp.status_code == 410:
        raise HTTPException(status_code=502, detail="HF 410: resource removed / not available for hosted inference")

    if resp.status_code != 200:
        # pass text for quick debugging (snippet)
        raise HTTPException(status_code=502, detail={
            "hf_status": resp.status_code,
            "hf_text": resp.text[:1000]
        })

    # try to parse JSON; if model returns plain text, wrap it
    try:
        return resp.json()
    except ValueError:
        return {"output_text": resp.text}
