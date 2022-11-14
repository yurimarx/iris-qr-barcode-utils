Class dc.qrbarcode.QRBarcodeService
{

ClassMethod WriteBarcodeToImage(number, filename) [ Language = python ]
{
	from barcode import EAN13
	from barcode.writer import ImageWriter
	import base64

	my_code = EAN13(number, writer=ImageWriter())
	image = my_code.save(filename)
	return image
}

ClassMethod ReadQRBarcodeFromPDF(pdfpath) [ Language = python ]
{
	from pyzbar.pyzbar import decode
	import pypdfium2 as pdfium
	import json

	class IrisBarcode:
		def __init__(self, bardata, bartype):
			self.bardata = bardata
			self.bartype = bartype
		
	
	pdf = pdfium.PdfDocument(pdfpath) 
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
}

ClassMethod ReadQRBarcodeFromImage(image) [ Language = python ]
{
	import cv2
	from pyzbar.pyzbar import decode
	import json

	# Make one method to decode the barcode
	class IrisBarcode:
		def __init__(self, bardata, bartype):
			self.bardata = bardata
			self.bartype = bartype
		
	
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
}

ClassMethod ReadQRBarcodeFromImage2(image) [ Language = python ]
{
	return image
}

}
