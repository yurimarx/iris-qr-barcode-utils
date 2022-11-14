# About iris-qr-barcode-utils Application
Read and write QR and Barcodes using InterSystems IRIS and Python

## Installation using ZPM
1. Execute this command from IRIS Terminal:
```
zpm "install iris-qr-barcode-utils"
```

## Installation using Docker Compose
1. Clone/git pull the repo into any local directory

```
$ git clone https://github.com/yurimarx/iris-qr-barcode-utils.git
```

2. Open a Docker terminal in this directory and run:

```
$ docker-compose build
```

3. Run the IRIS container:

```
$ docker-compose up -d 
```

4. Use Postman (or other REST Client) to Write a barcode to a value:

- Method: GET
- URL: http://localhost:52773/iris-qrbarcode/writeqrbarcodetoimage/1234567891234/test (template is: /writeqrbarcodetoimage/barcode number/image name)

![Write barcode](https://github.com/yurimarx/iris-qr-barcode-utils/raw/main/writebarcode.png "Write Bar code")


5. Use Postman to read a barcode value from an image (try EAN 128 type - the project has a sample on project-folder/code128.png): 

- Method: POST
- URL: http://localhost:52773/iris-qrbarcode/qrbarcodefromimage
- Body: form-data
- Key: file
- Value: select a file from your computer (sample on project-folder/code128.png)

![Read Image barcode](https://github.com/yurimarx/iris-qr-barcode-utils/raw/main/readbarcode.png "Read Image Barcode")

6. Use Postman to read a barcode value from a PDF (try a PDF with barcode and qrcode - the project has a sample on project-folder/product.pdf): 

- Method: POST
- URL: http://localhost:52773/iris-qrbarcode/qrbarcodefrompdf
- Body: form-data
- Key: file
- Value: select a file from your computer (sample on project-folder/product.pdf)

![Read PDF barcodes](https://github.com/yurimarx/iris-qr-barcode-utils/raw/main/readbarcodepdf.png "Read PDF Barcodes")
