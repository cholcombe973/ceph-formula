{% set release = grains['lsb_distrib_codename'] %}
ceph-repo:
  pkgrepo.managed:
    - humanname: Ceph Repo
    - name: deb http://ceph.com/debian-emperor/ {{release}} main
    - dist: {{release}}
    - file: /etc/apt/sources.list.d/ceph.list
    - key_url: https://ceph.com/git/?p=ceph.git;a=blob_plain;f=keys/release.asc
    - require_in:
      - pkg: ceph-packages

ceph:
  service:
    - name: ceph
    - running
    - enable: True
    - watch:
      - pkg: ceph-packages
      - file: /etc/ceph/ceph.conf

ceph-packages:
  pkg.installed:
    - pkgs:
      - ceph: 0.72.1-1{{release}}
      - ceph-common: 0.72.1-1{{release}}
      - ceph-deploy: 1.3.2-1{{release}}
      - ceph-fuse: 0.72.1-1{{release}}
      - ceph-fs-common: 0.72.1-1{{release}}
      - ceph-mds: 0.72.1-1{{release}}
      - libcephfs1: 0.72.1-1{{release}}
      - librados2: 0.72.1-1{{release}}
      - librbd1: 0.72.1-1{{release}}
      - python-ceph: 0.72.1-1{{release}}
      - python-pushy: 0.5.3-1{{release}}.ceph

/etc/ceph/ceph.conf:
  file.managed:
    - source: salt://etc/ceph/ceph.conf
    - makedirs: true
    - require:
      - pkg: ceph-packages

/var/lib/ceph/osd:
  file.directory:
    - user: root
    - group: root
    - mode: 755
    - makedirs: True

#Create all the osd directories
{% for osd in pillar.get('osds', {}).split() %}
/var/lib/ceph/osd/ceph-{{osd}}:
  file.directory:
    - user: root
    - group: root
    - mode: 755
    - makedirs: True
{% endfor %}

#Create the monitor directory
/var/lib/ceph/mon/ceph-{{ pillar['mon'] }}:
  file.directory:
    - user: root
    - group: root
    - mode: 755
    - makedirs: True
