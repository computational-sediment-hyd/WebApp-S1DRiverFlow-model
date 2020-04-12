FROM continuumio/miniconda3

RUN . /opt/conda/bin/activate \
&& conda install -y -c conda-forge numpy cartopy jupyter

RUN . /opt/conda/bin/activate \
&& conda install -y -c pyviz holoviews geoviews panel

WORKDIR /app

COPY  app/s1dmodel.ipynb /app

# COPY data/ /app/data/