FROM continuumio/miniconda3

RUN conda install -y -c conda-forge numpy cartopy
RUN conda install -y -c pyviz holoviews geoviews panel

WORKDIR /app

COPY  app/s1dmodel.py /app

# COPY data/ /app/data/