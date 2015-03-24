#!/bin/bash

template(){
export id=$1
export config_files_dir
export template_files_dir
export container_expr

python <<@@
import os 
from jinja2 import Template
import jinja2


config_dir=os.environ["config_files_dir"]
template_dir=os.environ["template_files_dir"]
AL_ROOT=os.path.dirname(os.path.abspath(__file__))
AL_ROOT=AL_ROOT+"/"
container_expr=os.environ["container_expr"]

id=os.environ["id"]
name=container_expr+"-"+id
brname="br-"+id
#ipv4="10.0.0.%s/24"%id
ipv4="10.0.0.1/24"

def template_it():
	try: 
		templateEnv = jinja2.Environment( loader=jinja2.FileSystemLoader( searchpath="/" ), trim_blocks=True )
		TEMPLATE_FILE = AL_ROOT+template_dir+"lxc-conf.jinja"
		template = templateEnv.get_template( TEMPLATE_FILE )

		templateVars = { "ipv4" : ipv4,
		                 "brname" : brname,
		                 "name": name
		               }
	             
		outputText = template.render( templateVars )
		#print outputText
		return outputText
	except:
		#print "jinja2 template does nos exists"
		return ""


## write the file
def write_the_template():
	conf_file=AL_ROOT+config_dir+name+".conf"
	text_file = open(conf_file, "w")
	text_file.write(template_it())
	text_file.close()
	return conf_file

print write_the_template()

@@

}