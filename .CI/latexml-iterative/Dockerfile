FROM modelicaspec/latexml:20190319

RUN apt-get update \
 && export DEBIAN_FRONTEND=noninteractive \
 && apt-get install -qy make \
 && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/ /root/.cpanm/work*
