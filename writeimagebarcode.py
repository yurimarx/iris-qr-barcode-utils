from barcode import EAN13
from barcode.writer import ImageWriter

def ImageBarcodeWriter(number):

	# Now, let's create an object of EAN13
	# class and pass the number
	my_code = EAN13(number, writer=ImageWriter())
	return my_code.save("new_code1")


if __name__ == "__main__":
	# Take the image from user
	number = '5901234123457'
	print(ImageBarcodeWriter(number))




