FROM intersystemsdc/iris-community

USER root

ENV DEBIAN_FRONTEND noninteractive


# install libraries required for geocoder process geocoding
RUN apt-get -y update \
    && apt-get -y install apt-utils \
    && apt-get install -y build-essential unzip pkg-config wget \
    && apt-get install -y python3-pip python3-opencv zbar-tools 

# use pip3 (the python zpm) to install geocoder dependencies
RUN pip3 install --upgrade pip setuptools wheel
RUN pip3 install --target /usr/irissys/mgr/python opencv-python pyzbar pypdfium2 Pillow python-barcode

USER root   
WORKDIR /opt/irisbuild
RUN chown ${ISC_PACKAGE_MGRUSER}:${ISC_PACKAGE_IRISGROUP} /opt/irisbuild
USER ${ISC_PACKAGE_MGRUSER}

WORKDIR /opt/irisbuild
COPY  src src
COPY  images images
COPY Installer.cls Installer.cls
COPY module.xml module.xml
COPY iris.script iris.script

USER root
RUN chmod -R 777 /opt/irisbuild/images

USER ${ISC_PACKAGE_MGRUSER}

RUN iris start IRIS \
	&& iris session IRIS < iris.script \
    && iris stop IRIS quietly
