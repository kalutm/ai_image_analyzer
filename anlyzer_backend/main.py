from fastapi import FastAPI, UploadFile, File
from PIL import Image
import torch
from transformers import (
    BlipProcessor,
    BlipForConditionalGeneration,
    DetrImageProcessor,
    DetrForObjectDetection,
    TrOCRProcessor,
    VisionEncoderDecoderModel
)

app = FastAPI()

device = "cpu"
torch.set_num_threads(4)


# -------------------------
# Load Caption Model (BLIP)
# -------------------------
blip_processor = BlipProcessor.from_pretrained("Salesforce/blip-image-captioning-base")
blip_model = BlipForConditionalGeneration.from_pretrained(
    "Salesforce/blip-image-captioning-base"
).to(device)

# -------------------------
# Load Object Detection Model (DETR)
# -------------------------
detr_processor = DetrImageProcessor.from_pretrained("facebook/detr-resnet-50")
detr_model = DetrForObjectDetection.from_pretrained(
    "facebook/detr-resnet-50"
).to(device)

# -------------------------
# Load OCR Model (TrOCR)
# -------------------------
trocr_processor = TrOCRProcessor.from_pretrained("microsoft/trocr-base-stage1")
trocr_model = VisionEncoderDecoderModel.from_pretrained(
    "microsoft/trocr-base-stage1"
).to(device)


@app.post("/caption")
async def caption(file: UploadFile = File(...)):
    image = Image.open(file.file).convert("RGB")
    inputs = blip_processor(image, return_tensors="pt").to(device)
    output = blip_model.generate(**inputs)
    text = blip_processor.decode(output[0], skip_special_tokens=True)
    return {"caption": text}


@app.post("/detect")
async def detect(file: UploadFile = File(...)):
    image = Image.open(file.file).convert("RGB")
    inputs = detr_processor(images=image, return_tensors="pt").to(device)
    outputs = detr_model(**inputs)

    results = detr_processor.post_process_object_detection(
        outputs,
        threshold=0.9,
        target_sizes=[image.size[::-1]]
    )[0]

    objects = []
    for score, label, box in zip(
        results["scores"], results["labels"], results["boxes"]
    ):
        objects.append({
            "label": detr_model.config.id2label[label.item()],
            "score": round(score.item(), 3),
            "box": [round(i, 2) for i in box.tolist()]
        })

    return {"objects": objects}


@app.post("/ocr")
async def ocr(file: UploadFile = File(...)):
    image = Image.open(file.file).convert("RGB")
    pixel_values = trocr_processor(image, return_tensors="pt").pixel_values.to(device)

    generated_ids = trocr_model.generate(pixel_values)
    text = trocr_processor.batch_decode(
        generated_ids, skip_special_tokens=True
    )[0]

    return {"text": text}
