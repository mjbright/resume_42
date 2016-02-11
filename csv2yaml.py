#!/usr/bin/env python

import os, sys
import csv, sys
import inspect
import copy

#csvfile = '2016-02.csv'
csvfile = sys.argv[1]
opfile = sys.argv[2]

def die(msg):
    callingframe = sys._getframe(1)
    print("die: " + msg, file=sys.stderr)
    frameinfo = inspect.currentframe().f_back #.callingframe()
    print('From line{} of {} in {}'.format(frameinfo.f_lineno, frameinfo.f_code.co_filename, frameinfo.f_code.co_name), file=sys.stderr)
    #print('from %r function in a %r class' % (
    #    callingframe.f_code.co_name, 
    #    callingframe.f_locals['self'].__class__.__name__), file=sys.stderr)*/
    sys.exit(1)
        
def debug(msg):
    print("debug: " + msg, file=sys.stderr)

def press(msg):
    print(msg, file=sys.stderr)
    print("Press <return> to continue", file=sys.stderr)
    input()
    
#csvfd = open(csv) or die("Failed to read file <" + csv + ">")

    
def addEntryField(ARRAY, ARRAY_NAME, ENTRY, ALLOWED_FIELDS, row):

    if row[0] == "SUBSECTION":
        if ENTRY != {}:
            debug("{} ADDING ENTRY <{}>".format(ARRAY_NAME, ENTRY))
            ARRAY.append( copy.copy(ENTRY) )
            ENTRY.clear()   # Empty ENTRY (note that ENTRY={} creates a 'new' empty Dict, doesn't modify passed in parameter)
            debug("RESETTING ENTRY to <{}>".format(ENTRY))
            #die("{} Expected empty entry <{}>".format(ARRAY_NAME, ENTRY))
        ENTRY.clear()   # Empty ENTRY (note that ENTRY={} creates a 'new' empty Dict, doesn't modify passed in parameter)
        return
          
    entryField = row[2]
    if not entryField in ALLOWED_FIELDS:
        die("disAllowed field '{}' for '{}' allowed[{}]".format(entryField, ARRAY_NAME, ALLOWED_FIELDS))
 
    if entryField == 'ITEMLIST':
        if not 'ITEMLIST' in ENTRY:
            ENTRY['ITEMLIST'] = [ ]
            
        ENTRY['ITEMLIST'].append(row[3])
        #debug("Appending ITEMLIST <{}>".format(row[3]))
        #debug("Now ITEMLIST has length <{}>".format(len(ENTRY['ITEMLIST'])))
        #die("X")
    else:
        ENTRY[entryField] = row[3]
    
def processCsvFile(reader):
    lno=0
    SECTION='HEADER'

    # Dict(s) of variables for english, french, spanish:
    VAR = {}
    VAR_fr = {}
    VAR_es = {}
    ENTRIES = []

    EXPERIENCES = []
    ACTIVITIES = []
    SKILLS = []
    EDUCATION = []
    
    ENTRY = {}
            
    for row in reader:
        lno += 1
        #print(lno)
        #if len(row) != 0:
    
        if len(row) == 0:
            continue
        
        debug("----LINE[{}]=<{}>".format(lno, row))

        if row[0] == "SECTION":
            SECTION = row[1]
            debug("section " + SECTION)
            continue
            
        # Treat header lines:
        if SECTION == 'HEADER':
            if row[0] == "SECTION":
                continue
    
            if row[0] == "TYPE":
                continue
        
            if row[0] == "VARIABLES":
                SECTION="VARIABLES"
                continue

            die("Unexpected line{} in <{}>".format(lno, str(row)))

        if SECTION == 'VARIABLES':
            if len(row) > 4:
                if row[2] != '':
                    varname=row[2]
                    value=row[3]
                    fr_value=row[5]
                    es_value=row[7]
                    debug("Adding VARIABLE '" +  varname + "'")
                    VAR[varname]=value
                    VAR_fr[varname]=fr_value
                    VAR_es[varname]=es_value
            else:
                debug("Error in line {} <{}>".format(lno, str(row)))
                die("X")

# TODO: check for SUBSECTIONS each with TITLE, START, END, ITEMLIST
# TODO: IMPLEMENT SECTION: SKILLS
# TODO: IMPLEMENT SECTION: EDUCATION
# TODO: IMPLEMENT SECTION: ACTIVITIES

        if SECTION == "EXPERIENCE":
            addEntryField(EXPERIENCES, 'EXPERIENCE', ENTRY, ['TITLE', 'EMPLOYER', 'ROLE', 'START', 'END', 'ITEMLIST'], row)
        if SECTION == "SKILLS":
            addEntryField(SKILLS,      'SKILLS',     ENTRY, ['TITLE', 'ITEMLIST'], row)
        if SECTION == "EDUCATION":
            addEntryField(EDUCATION,   'EDUCATION',  ENTRY, ['TITLE', 'SCHOOL', 'START', 'END', 'ITEMLIST'], row)
        if SECTION == "ACTIVITIES":
            addEntryField(ACTIVITIES,  'ACTIVITIES', ENTRY, ['TITLE', 'ITEMLIST'], row)

    endrow = [ 'SUBSECTION', '', '' ]
    addEntryField(ACTIVITIES,  'ACTIVITIES', ENTRY, ['ITEMLIST'], endrow)

    debug("Read {} {} entries".format(len(VAR.keys()),  'VARIABLE'))
    debug("Read {} {} entries".format(len(EXPERIENCES), 'EXPERIENCE'))
    debug("Read {} {} entries".format(len(SKILLS),      'SKILLS'))
    debug("Read {} {} entries".format(len(EDUCATION),   'EDUCATION'))
    debug("Read {} {} entries".format(len(ACTIVITIES),  'ACTIVITIES'))
    
    for var in VAR:
        debug("VAR[{}]={} / {} / {}".format(var, VAR[var], VAR_fr[var], VAR_es[var]))
    for exp in EXPERIENCES:
        debug("EXPERIENCE {}".format(exp['TITLE']))
    for skills in SKILLS:
        debug("SKILLS {}".format(skills['TITLE']))
    for edu in EDUCATION:
        debug("EDUCATION {}".format(edu['TITLE']))
    for act in ACTIVITIES:
        debug("ACTIVITIES {}".format(act['TITLE']))
    #for item in ACTIVITIES[0]['ITEMLIST']:
    #    debug("ITEM[]={}".format(item))
    return (VAR, EXPERIENCES, SKILLS, EDUCATION, ACTIVITIES)

def writeCVYaml(opfile, VAR, EXPERIENCES, SKILLS, EDUCATION, ACTIVITIES):
    f = open(opfile, 'w')
    
    f.write('name: {}\n'.format(VAR['NAME']))
    f.write('email: {}\n'.format(VAR['EMAIL']))
    f.write('\n')
    
    f.write('order:\n')
    #f.write('- [life_education, LIFE / EDUCATION]\n')
    f.write('- [industry, WORK EXPERIENCE]\n')
    f.write('- [skills, SKILLS]\n')
    f.write('- [education, EDUCATION]\n')
    #f.write('- [research, RESEARCH EXPERIENCE]\n')
    #f.write('- [portfolios, PORTFOLIO]\n')
    f.write('- [activities, ACTIVITIES]\n')
    #f.write('- [personal_projects, PERSONAL PROJECTS]\n')
    #f.write('- [honors, ACHIEVEMENTS]\n')
    #f.write('- [languages, HUMAN LANGUAGES]\n')
    f.write('\n')

    f.write('industry:\n')
    for EXPERIENCE in EXPERIENCES:
        f.write("  - place: " + EXPERIENCE['EMPLOYER'] + "\n")
        f.write("    title: " + EXPERIENCE['TITLE'] + "\n")
        f.write("    dates: " + EXPERIENCE['START'] + ", " + EXPERIENCE['END'] + "\n")
        f.write("    details:\n")
        for item in EXPERIENCE['ITEMLIST']:
            f.write("      - " + item + "\n")
        #  - place: nCube, Ravelin, Murat Diril etc.
        #location: London, UK
        #title: 'Freelancer as a Developer / Designer'
        #languages: JavaScript, PHP, Python
        #dates: 2014--Present
        #details:
        #  - "Hybrid app UI for a cool home automation system (AngularJS/Ionic),"
    
    f.write('skills:\n')
    for SKILL in SKILLS:
        f.write("  - title: " + SKILL['TITLE'] + "\n")
        f.write("    details:\n")
        for item in SKILL['ITEMLIST']:
            f.write("      - " + item + "\n")
        #    - title: Languages of choice
        #      details: JavaScript, PHP, Python

    f.write('education:\n')
    for EDU in EDUCATION:
        f.write("  - title: " + EDU['TITLE'] + "\n")
        f.write("  - place: " + EDU['SCHOOL'] + "\n")

        f.write("    dates: " + EDU['START'] + ", " + EDU['END'] + "\n")
        f.write("    details:\n")
        for item in EDU['ITEMLIST']:
            f.write("      - " + item + "\n")
        
    f.write('activities:\n')
    for ACTIVITY in ACTIVITIES:
        f.write("  - title: " + ACTIVITY['TITLE'] + "\n")
        f.write("    details:\n")
        for item in ACTIVITY['ITEMLIST']:
            f.write("      - " + item + "\n")
        

with open(csvfile, 'r') as f:

    reader = csv.reader(f)
    try:
        (VAR, EXPERIENCES, SKILLS, EDUCATION, ACTIVITIES) = processCsvFile(reader)

    except csv.Error as e:
        sys.exit('file %s, line %d: %s' % (csvfile, reader.line_num, e))
        
    writeCVYaml(opfile, VAR, EXPERIENCES, SKILLS, EDUCATION, ACTIVITIES)




