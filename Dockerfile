FROM continuumio/miniconda3

# RUN . /opt/conda/bin/activate \
# && conda install -y -c conda-forge numpy cartopy jupyter

# USER root
# RUN chmod -R 777 ../opt/conda/
# RUN chown -hR root:root ../opt/conda/

RUN conda create -n pyviz python=3.7

SHELL ["conda", "run", "-n", "pyviz", "/bin/bash", "-c"]

# RUN . ../opt/conda/etc/profile.d/conda.sh && conda activate pyviz

# RUN . ../opt/conda/etc/profile.d/conda.sh \
RUN conda run -n pyviz \
&& conda install -y -c conda-forge bokeh=1.4.0

# RUN . ../opt/conda/etc/profile.d/conda.sh \
# RUN source activate pyviz \
RUN conda run -n pyviz \
&& conda install -y -c pyviz geoviews panel

# RUN . /opt/conda/etc/profile.d/conda.sh && conda activate base

# RUN . /opt/conda/etc/profile.d/conda.sh \
# && conda install -y -c conda-forge jupyter

# RUN . /opt/conda/etc/profile.d/conda.sh \
# && conda install -y -c pyviz panel

# RUN . /opt/conda/etc/profile.d/conda.sh \
# && conda install -y -c pyviz geoviews 
#holoviews

# SHELL ["conda", "run", "-n", "base", "/bin/bash", "-c"]

# Make RUN commands use the new environment:
# SHELL ["conda", "run", "-n", "pyviz", "/bin/bash", "-c"]

WORKDIR /app

COPY source/ /app/source/

# COPY data/ /app/data/

# ENTRYPOINT ["conda","run","-n","base"]
# CMD ["panel","serve","--address=0.0.0.0","--port=$PORT","s1dmodel.ipynb","--allow-websocket-origin=s1dmodel.herokuapp.com"]

CMD ["conda","run","-n","pyviz","bokeh","serve","--address=0.0.0.0","--port=$PORT","source/s1dmodel.ipynb","--allow-websocket-origin=s1dmodel.herokuapp.com"]

# ENTRYPOINT ["conda","run","-n","pyviz","bokeh","serve","source/s1dmodel.ipynb","--port","3128","--allow-websocket-origin=52.199.214.254"]
# CMD ["conda","run","-n","pyviz","bokeh","serve","source/s1dmodel.ipynb","--port","3128","--allow-websocket-origin=52.199.214.254"]
