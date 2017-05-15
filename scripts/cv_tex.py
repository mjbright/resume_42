#!/usr/bin/env python3

# Converts my Resume from YAML to TeX.
# Just don't forget to drop pdflatex on the output :)
# ------------------------------------------------------------------------------
# @contributor Aleksandr Mattal <https://github.com/qutebits>
# inspired by work of Brandon Amos <https://github.com/bamos/cv>

import re
import yaml
import sys

from datetime import date
from jinja2 import Environment, FileSystemLoader

THIS_FILE=sys.argv[0]

YAML_FILE=sys.argv[1]
TEMPLATE_FILE=sys.argv[2]
SECTION_TEMPLATE_FILE=sys.argv[3]
OP_FILE=sys.argv[4]

yaml_contents = yaml.load(open(YAML_FILE, 'r')) #read data

#env = Environment(loader=FileSystemLoader("template"),
env = Environment(loader=FileSystemLoader("/cv/template"),
  block_start_string='~{',block_end_string='}~',
  variable_start_string='~{{', variable_end_string='}}~')

this_loc = len(open(THIS_FILE, 'r').readlines()) #lets keep it at 42

def generate():
  body = ""
  for section in yaml_contents['order']: #generate sections 1 by 1
    contents = yaml_contents[section[0]]
    name = section[1].title()
    body += env.get_template(SECTION_TEMPLATE_FILE).render(
      name = name.upper(),
      contents = contents
    )
  #and then generate the TeX wrapper and fill it with generated sections
  result = open(OP_FILE, 'w')
  result.write(env.get_template(TEMPLATE_FILE).render(
    name = yaml_contents['name'].upper(),
    email = yaml_contents['email'],
    title = yaml_contents['title'],
    phone = yaml_contents['phone'],
    certification = yaml_contents['certification'],
    website = yaml_contents['website'],
    goal = yaml_contents['goal'],
    linkedin = yaml_contents['linkedin'],
    location = yaml_contents['location'],
    loc = this_loc, #lines of code in this very script :)
    body = body,
    today = date.today().strftime("%B %d, %Y") #generation date
  ))
  result.close()

generate() #finally, generate this beauty
