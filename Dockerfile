FROM ghcr.io/netbox-community/netbox
COPY topo.yaml '/run/config/extra/topo/topo.yaml'
COPY netbox-proxbox /tmp/netbox-proxbox
RUN set -x \
  && source /opt/netbox/venv/bin/activate \
  && cd /tmp/netbox-proxbox \
  && pip3 install build \
  && python3 -m build \
  && pip3 install dist/*.whl \
  && cd - \
  && rm -rf /tmp/netbox-proxbox \
  && sed -i "/^TEMPLATES_DIR =/a PROXBOX_TEMPLATE_DIR = BASE_DIR + '/netbox-proxbox/netbox_proxbox/templates/netbox_proxbox'" /opt/netbox/netbox/netbox/settings.py \
  && sed -i "s|'DIRS': [TEMPLATES_DIR],|'DIRS': [TEMPLATES_DIR, PROXBOX_TEMPLATE_DIR],|" /opt/netbox/netbox/netbox/settings.py \
  && /opt/netbox/venv/bin/pip install netbox-topology-views \
  && cp -r /opt/netbox/venv/lib/python3.9/site-packages/netbox_topology_views/static/netbox_topology_views /opt/netbox/netbox/static/ \
  && true


