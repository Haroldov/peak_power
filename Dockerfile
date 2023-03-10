FROM python:3.10-buster

# upgrade pip
RUN pip install --upgrade pip

RUN apt-get update
RUN apt-get install -y python-enchant

# permissions and nonroot user for tightened security
RUN useradd -ms /bin/bash nonroot
RUN mkdir /home/app/ && chown -R nonroot:nonroot /home/app
RUN mkdir -p /var/log/flask-app && touch /var/log/flask-app/flask-app.err.log && touch /var/log/flask-app/flask-app.out.log
RUN chown -R nonroot:nonroot /var/log/flask-app
WORKDIR /home/app

USER nonroot

# copy all the files to the container
COPY --chown=nonroot:nonroot ./app/. .
COPY --chown=nonroot:nonroot ./requirements.txt .

# venv
ENV VIRTUAL_ENV=/home/app/venv

# python setup
RUN python -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"
RUN export FLASK_APP=app.py
RUN pip install -r requirements.txt

EXPOSE 5000

CMD ["python", "app.py"]
