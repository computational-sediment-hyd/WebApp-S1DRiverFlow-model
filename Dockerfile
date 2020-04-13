FROM continuumio/miniconda3

# RUN . /opt/conda/bin/activate \
# && conda install -y -c conda-forge numpy cartopy jupyter

USER root
RUN chmod -R 777 /opt/conda/
RUN chown -hR root:root /opt/conda/

RUN . /opt/conda/etc/profile.d/conda.sh && conda activate base

# RUN . /opt/conda/etc/profile.d/conda.sh \
# && conda install -y -c conda-forge jupyter

RUN . /opt/conda/etc/profile.d/conda.sh \
&& conda install -y -c pyviz panel

RUN . /opt/conda/etc/profile.d/conda.sh \
&& conda install -y -c pyviz geoviews 
#holoviews

SHELL ["conda", "run", "-n", "base", "/bin/bash", "-c"]

WORKDIR /app

COPY s1dmodel.ipynb /app

# COPY data/ /app/data/

ENTRYPOINT ["conda","run","-n","base"]

# CMD ["conda","run","-n","base","panel","serve","--address=0.0.0.0","--port=$PORT","s1dmodel.ipynb","--allow-websocket-origin=s1dmodel.herokuapp.com"]
