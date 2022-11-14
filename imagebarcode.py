from pyzbar.pyzbar import decode
import pypdfium2 as pdfium
import json

# Make one method to decode the barcode
class IrisBarcode:
	def __init__(self, bardata, bartype):
		self.bardata = bardata
		self.bartype = bartype
	def toJSON(self):
    		return json.dumps(self, default=lambda o: o.__dict__, 
            sort_keys=True, indent=4)

def PdfBarcodeReader(pdf_path):

	pdf = pdfium.PdfDocument(pdf_path)
	result = []
	pages = len(pdf)
	
	for currentPage in range(pages):
    		
		page = pdf.get_page(currentPage)
		pil_image = page.render_to(
			pdfium.BitmapConv.pil_image,
		)

		# Decode the barcode image
		detectedBarcodes = decode(pil_image)

		# If not detected then print the message
		if detectedBarcodes:
			for barcodeitem in detectedBarcodes:
				item = IrisBarcode(barcodeitem.data.decode("utf-8"), barcodeitem.type)
				result.append(item)

	return json.dumps(result, default=vars)


if __name__ == "__main__":
	# Take the image from user
	pdf = 'D:/projetos/isc/iris-qr-barcode-utils/images/barcode.pdf'
	print(PdfBarcodeReader(pdf))



