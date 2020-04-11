#!/usr/bin/env python
# coding: utf-8

# In[ ]:


import numpy as np
import geoviews as gv
import holoviews as hv
from holoviews.streams import Selection1D
import panel as pn
from cartopy import crs
import json

hv.extension('bokeh',logo=False)
gv.extension('bokeh',logo=False)
pn.extension()


# In[ ]:


def plot(jsonsect):
    
    def from3Dto2D(pointz, porg):
        point = pointz[:,:2]
        d = point - porg[:2]
        L = np.sqrt(d[:,0]**2 + d[:,1]**2)
        Z = pointz[:,2]
        return L, Z
    
    geom = jsonsect['features'][0]['geometry']
    
    pointz = np.array(geom['coordinates'])
    porg = pointz[0]
    
    L, Z = from3Dto2D(pointz, porg)
    
    sect = hv.Curve((L,Z)).options(color='k',width=600,height=250)
    
    calc = jsonsect['features'][0]['properties']['calc-input']
    
    sectcal = []
    manning = []
    
    for i, dcalc in enumerate(calc):
        pcalc = dcalc['point']
        Ld, Zd = from3Dto2D(np.array(pcalc), porg)
#         sectcal.append( hv.Curve((Ld,Zd),label='subsection' + str(i).zfill(2) ).options(line_dash='dashed') )
        sectcal.append( hv.Curve((Ld,Zd),label='subsection' + str(i) ).options(line_dash='dashed') )
        
        LL = np.c_[Ld, Ld].flatten()[1:-1]
        
        n = np.array(dcalc['manning'])
        
        if len(n) == 1:
            nn = np.full_like(LL, n[0])
        else:
            nn = np.c_[n, n].flatten()
            
        manning.append( hv.Curve((LL,nn),label='sub' + str(i), vdims=['n'] ).options(color='k', line_width=3) )
#         manning.append( hv.Curve((LL,nn),label='sub' + str(i).zfill(2), vdims=['n'] ).options(color='k', line_width=3) )
        
    sectcala = hv.Overlay( sectcal )
    manninga = hv.Overlay( manning ).options(title='Manning\'s roughness coefficient', width=600,height=150, show_legend=False,ylabel='manning coef').redim(n={'range':(0,None)})
    
    
    outcrs = crs.epsg( jsonsect['crs']['properties']['name'][-4:] )
    geomap = gv.tile_sources.EsriImagery.options(width=600, height=400)
    g = geomap *  gv.Points(pointz, crs=outcrs).options(title='Location', color='r', size=5, tools=['box_select'])
    
    def selectpfig(index):
        sindex = sorted(index)
        return hv.Points( (L[sindex], Z[sindex]),vdims=['elevation']).options(color='r', size=10, ylabel='elevation')
    
    p = Selection1D(source=g)
    selectp = hv.DynamicMap(selectpfig, streams=[p]).options(title='Cross Section', legend_position='right')

    return (g + (selectp * sect * sectcala + manninga)).cols(1)


# In[ ]:


file_input = pn.widgets.FileInput(accept='.geojson')
button1 = pn.widgets.Button(name='drawing', button_type='primary') 
# str_pane = pn.pane.Str(' ', style={'font-size': '40pt'})

if file_input.value is not None:
    obj = pn.Row( pn.Column(file_input,button1), plot(json.loads(file_input.value)), width_policy='max', height_policy='max')
else:
#     obj = pn.Row( pn.Column(file_input,button1), str_pane, width_policy='max', height_policy='max')
    obj = pn.Row( pn.Column(file_input,button1), '', width_policy='max', height_policy='max')

def update(event): 
    if file_input.value is not None:
        obj[-1] = plot(json.loads(file_input.value)) 
        
button1.on_click(update)


# In[ ]:


obj.servable(title='S1D-model')

