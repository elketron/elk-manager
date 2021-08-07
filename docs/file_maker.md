# a file making script

## makes files and project folders from a template

### project folder
the easy way : make a zip file from a folder that is the template
- the less easy way: git repo where all templates are stored in folders of the programming language

data: json
layout:
key: file name
value: {
    language,
    type,
    file_path
}

:todo add ability to get template from git repo

### making files
taking a template file and renaming and placing it in the project structure

* variables
$name : file name
$folder : current folder
$path : relative path to current file
$full_path: full path to current file

class $name {};
