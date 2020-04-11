FROM continuumio/miniconda3

RUN conda install -y -c pyviz holoviews geoviews panel cartopy

WORKDIR /app

COPY  app/s1dmodel.ipynb /app

# COPY data/ /app/data/