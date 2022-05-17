kdenlive:
  pkg.installed

/home/olmo/.config/kdenliverc:
  file.managed:
    - source: salt://kdenlive/kdenliverc
