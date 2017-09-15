# change_line_ending
Ruby script that changes line endings 

**Usage:** `./change_line_ending directory_path desired_line_ending included_regexp(optional) log_dir(optional)`

If `log_dir` is not specified, program stores log files in directory path stored in `LOG_PATH` environmental variable.
If that variable is not set, log files are being stored in the directory of the script.

If `included_regexp` is not specified, all non-binary files form directory_path directory are proceseed.

**Warning:** script qualifies whether file is binary or not using ptools library, which is known to make mistakes,
so if `directory_path` contains binary files it's best to specify `included_regexp` to avoid accidentally processing them.
