/mnt/ceph:
  file.directory:
    - user: root
    - group: root
    - mode: 775
    - makedirs: True
  mount.mounted:
    - device: 192.168.1.21:6789:/
    - fstype: ceph
    - mkmnt: True
    - opts:
      - defaults,noauto
