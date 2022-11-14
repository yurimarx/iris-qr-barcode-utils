import cv2
from pyzbar.pyzbar import decode
import json

# Make one method to decode the barcode
class IrisBarcode:
	def __init__(self, bardata, bartype):
		self.bardata = bardata
		self.bartype = bartype
	def toJSON(self):
    		return json.dumps(self, default=lambda o: o.__dict__, 
            sort_keys=True, indent=4)

def BarcodeReader(image):

	result = []

	# read the image in numpy array using cv2
	img = cv2.imread(image)

	# Decode the barcode image
	detectedBarcodes = decode(img)

	# If not detected then print the message
	if detectedBarcodes:
		for barcodeitem in detectedBarcodes:
			item = IrisBarcode(barcodeitem.data.decode("utf-8"), barcodeitem.type)
			result.append(item)

	return json.dumps(result, default=vars)


if __name__ == "__main__":
	# Take the image from user
	image = "D:\projetos\isc\iris-qr-barcode-utils\images\sample4.png"
	print(BarcodeReader(image))



