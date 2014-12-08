sloc_counter
============

Basic SLOC counter. Counts lines of code in a group of directories.

Right now the calculation is super simple:

1. Sweep directories for files of indicated types
2. Count all lines that are non-empty (removes whitespace lines)
3. Add up counts from all files

```
# Array of directories and multiple file types
count_slocs_in_dir ['C:\dev\my_app\code', 'C:\dev\my_app\extras'], '{rb,java,js,xml}'

# Array of directories and any file type
count_slocs_in_dir ['C:\dev\my_app\code', 'C:\dev\my_app\extras']

# Single directory and single file type
count_slocs_in_dir 'C:\dev\my_app\code', '{java}'

# Single directory and any file type
count_slocs_in_dir 'C:\dev\my_app\code'
```
