FROM python:2.7

ADD . /app/

WORKDIR /app

RUN pip install -r requirements.txt
RUN apt-get update
RUN apt-get install -y python-qrtools python-qrcode python-qrencode

CMD python2 qrcode.py