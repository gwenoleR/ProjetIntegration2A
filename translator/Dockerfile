FROM python:3.5.3

ADD . /app/

WORKDIR /app

RUN pip install -r requirements.txt
RUN pip3 install --upgrade watson-developer-cloud

CMD python translator.py
