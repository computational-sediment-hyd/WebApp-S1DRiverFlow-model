FROM continuumio/miniconda3

RUN conda create -n pyviz python=3.7

# Make RUN commands use the new environment:
SHELL ["conda", "run", "-n", "pyviz", "/bin/bash", "-c"]

RUN conda run -n pyviz \
&& conda install -y -c conda-forge bokeh=1.4.0

RUN conda run -n pyviz \
&& conda install -y -c pyviz geoviews panel

WORKDIR /app

COPY source/ /app/source/

ENTRYPOINT ["conda","run","-n","base"]

# CMD ["conda","run","-n","pyviz","panel","serve","--address=0.0.0.0","--port=$PORT","source/s1dmodel.ipynb","--allow-websocket-origin=s1dmodel.herokuapp.com"]
