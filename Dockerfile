FROM continuumio/miniconda3
USER root
RUN chmod -R 777 /opt/conda/
RUN chown -hR root:root /opt/conda/

RUN conda install -y -c conda-forge numpy cartopy jupyter
RUN conda install -y -c pyviz holoviews geoviews panel

WORKDIR /app

COPY  app/s1dmodel.ipynb /app

# COPY data/ /app/data/